package com.djtech.monai.feature.transactions.data.repository

import androidx.paging.ExperimentalPagingApi
import androidx.paging.Pager
import androidx.paging.PagingConfig
import androidx.paging.PagingData
import androidx.paging.map
import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.map
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.database.dao.TransactionDao
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.database.toFtsMatchQuery
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.feature.transactions.data.dto.TransactionDto
import com.djtech.monai.feature.transactions.data.mapper.asModel
import com.djtech.monai.feature.transactions.data.mapper.toCreateRequest
import com.djtech.monai.feature.transactions.data.mapper.toRequestBody
import com.djtech.monai.feature.transactions.data.mapper.toTransactionError
import com.djtech.monai.feature.transactions.data.mapper.toUpdateRequest
import com.djtech.monai.feature.transactions.data.paging.TransactionPage
import com.djtech.monai.feature.transactions.data.paging.TransactionRemoteMediator
import com.djtech.monai.feature.transactions.data.paging.TransactionSearchPagingSource
import com.djtech.monai.feature.transactions.data.remote.TransactionApiService
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.flow.map
import java.time.LocalDate
import java.time.YearMonth
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.cancellation.CancellationException

/** Rows per page of a paged list; the API allows up to 100. */
internal const val TRANSACTION_PAGE_SIZE = 20

@Singleton
class ApiTransactionRepository @Inject constructor(
    private val transactionApiService: TransactionApiService,
    private val apiCaller: ApiCaller,
    private val transactionDao: TransactionDao,
    private val clock: AppClock,
    private val errorLogger: ErrorLogger,
) : TransactionRepository {

    private val deletedTransactions = MutableSharedFlow<Transaction>(extraBufferCapacity = 8)
    override val deletions: Flow<Transaction> = deletedTransactions.asSharedFlow()

    override fun observeRecentTransactions(month: YearMonth, limit: Int): Flow<List<Transaction>> =
        transactionDao.observeRecent(month.atDay(1), month.atEndOfMonth(), limit)
            .map { entities -> entities.map(TransactionEntity::asModel) }

    override suspend fun refreshRecentTransactions(month: YearMonth, limit: Int): TransactionResult<Unit> {
        // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
        val result = apiCaller.callRaw {
            val page = transactionApiService.getTransactions(month.toApiString(), limit)
            page.data.map(TransactionDto::asModel) to page.meta.hasMore
        }
        return when (result) {
            is Outcome.Success -> {
                val (transactions, hasMore) = result.data
                cacheWrite("Caching transactions failed") {
                    transactionDao.replaceRecent(
                        from = month.atDay(1),
                        to = month.atEndOfMonth(),
                        transactions = transactions.map(Transaction::asEntity),
                        hasMore = hasMore,
                    )
                }
            }

            is Outcome.Failure -> Outcome.Failure(result.error.toTransactionError())
        }
    }

    @OptIn(ExperimentalPagingApi::class)
    override fun pagedTransactions(month: YearMonth, filter: TransactionFilter): Flow<PagingData<Transaction>> =
        Pager(
            config = pagingConfig(),
            remoteMediator = TransactionRemoteMediator(
                month,
                filter,
                transactionApiService,
                apiCaller,
                transactionDao,
                clock,
                errorLogger,
            ),
            pagingSourceFactory = {
                transactionDao.pagingSource(
                    from = month.atDay(1),
                    to = month.atEndOfMonth(),
                    walletId = filter.walletId,
                    categoryId = filter.categoryId,
                    type = filter.type,
                )
            },
        ).flow.map { page -> page.map(TransactionEntity::asModel) }

    override fun observeDailyNets(month: YearMonth, filter: TransactionFilter): Flow<Map<LocalDate, Long>> =
        transactionDao.observeDailyNets(
            from = month.atDay(1),
            to = month.atEndOfMonth(),
            walletId = filter.walletId,
            categoryId = filter.categoryId,
            type = filter.type,
        ).map { days -> days.associate { it.date to it.net } }

    override fun observeDailyOutflows(month: YearMonth, walletId: String): Flow<Map<LocalDate, Long>> =
        transactionDao.observeDailyOutflows(
            from = month.atDay(1),
            to = month.atEndOfMonth(), walletId = walletId,
        ).map { days -> days.associate { it.date to it.amount } }

    override fun searchTransactions(
        query: String,
        month: YearMonth,
        filter: TransactionFilter,
    ): Flow<PagingData<Transaction>> = Pager(
        config = pagingConfig(),
        pagingSourceFactory = {
            TransactionSearchPagingSource { cursor, limit ->
                fetchSearchPage(
                    query,
                    month,
                    filter,
                    cursor,
                    limit,
                )
            }
        },
    ).flow

    override fun searchCachedTransactions(query: String, filter: TransactionFilter): Flow<PagingData<Transaction>> {
        val match = toFtsMatchQuery(query) ?: return flowOf(PagingData.empty())
        return Pager(
            config = pagingConfig(),
            pagingSourceFactory = {
                transactionDao.searchPagingSource(
                    match = match,
                    from = EARLIEST,
                    to = LATEST,
                    walletId = filter.walletId,
                    categoryId = filter.categoryId,
                    type = filter.type,
                )
            },
        ).flow.map { page -> page.map(TransactionEntity::asModel) }
    }

    override fun observeTransaction(id: String): Flow<Transaction?> = transactionDao.observe(id).map { it?.asModel() }

    override suspend fun refreshTransaction(id: String): TransactionResult<Unit> {
        val result = apiCaller.call { transactionApiService.getTransaction(id) }.map(TransactionDto::asModel)
        return when (result) {
            is Outcome.Success -> cacheWrite("Caching a transaction failed") {
                transactionDao.upsertAll(listOf(result.data.asEntity()))
            }

            is Outcome.Failure -> {
                val error = result.error.toTransactionError()
                if (error == TransactionError.NotFound) {
                    cacheWrite("Dropping a missing transaction failed") { transactionDao.delete(id) }
                }
                Outcome.Failure(error)
            }
        }
    }

    override suspend fun createTransaction(input: TransactionInput): TransactionResult<Transaction> = write {
        transactionApiService.createTransaction(input.toCreateRequest()).data
    }

    override suspend fun updateTransaction(id: String, input: TransactionInput): TransactionResult<Transaction> =
        write {
            transactionApiService.updateTransaction(id, input.toUpdateRequest().toRequestBody()).data
        }

    override suspend fun deleteTransaction(id: String): TransactionResult<Transaction?> {
        val cached = transactionDao.observe(id).first()?.asModel()
        val result = apiCaller.callRaw { transactionApiService.deleteTransaction(id) }
            .mapError { it.toTransactionError() }
        // Already gone on the server is the outcome the user asked for.
        if (result is Outcome.Failure && result.error != TransactionError.NotFound) return Outcome.Failure(result.error)

        cacheWrite("Dropping a deleted transaction failed") { transactionDao.delete(id) }
        if (cached != null) deletedTransactions.emit(cached)

        return Outcome.Success(cached)
    }

    override suspend fun restoreTransaction(id: String): TransactionResult<Transaction> = write {
        transactionApiService.restoreTransaction(id).data
    }

    /**
     * Runs a write and caches the transaction it returns. The server already saved it, so a failed
     * cache write is only logged: reporting a failure would invite the user to save it twice.
     */
    private suspend fun write(call: suspend () -> TransactionDto): TransactionResult<Transaction> {
        val result = apiCaller.callRaw { call().asModel() }.mapError { it.toTransactionError() }
        if (result is Outcome.Success) {
            cacheWrite("Caching a saved transaction failed") {
                transactionDao.upsertAll(listOf(result.data.asEntity()))
            }
        }
        return result
    }

    private suspend fun fetchSearchPage(
        query: String,
        month: YearMonth,
        filter: TransactionFilter,
        cursor: String?,
        limit: Int,
    ): TransactionResult<TransactionPage> {
        val result = apiCaller.callRaw {
            val page = transactionApiService.getTransactions(
                month = month.toApiString(),
                limit = limit,
                walletId = filter.walletId,
                categoryId = filter.categoryId,
                type = filter.type,
                query = query,
                cursor = cursor,
            )
            TransactionPage(page.data.map(TransactionDto::asModel), page.meta.nextCursor.takeIf { page.meta.hasMore })
        }.mapError { it.toTransactionError() }
        // Cached so the results open offline and show up in later offline searches.
        if (result is Outcome.Success) {
            cacheWrite("Caching search results failed") {
                transactionDao.upsertAll(result.data.transactions.map(Transaction::asEntity))
            }
        }
        return result
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private suspend fun cacheWrite(what: String, block: suspend () -> Unit): TransactionResult<Unit> = try {
        block()
        Outcome.Success(Unit)
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log(what, e)
        Outcome.Failure(TransactionError.Unexpected)
    }

    private fun pagingConfig() = PagingConfig(pageSize = TRANSACTION_PAGE_SIZE, enablePlaceholders = false)

    private companion object {
        // ISO dates sort as text, so this range covers every cached date.
        val EARLIEST: LocalDate = LocalDate.of(1, 1, 1)
        val LATEST: LocalDate = LocalDate.of(9999, 12, 31)
    }
}
