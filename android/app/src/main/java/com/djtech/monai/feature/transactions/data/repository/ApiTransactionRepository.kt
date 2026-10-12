package com.djtech.monai.feature.transactions.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.database.dao.TransactionDao
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.feature.transactions.data.dto.TransactionDto
import com.djtech.monai.feature.transactions.data.mapper.asModel
import com.djtech.monai.feature.transactions.data.mapper.toTransactionError
import com.djtech.monai.feature.transactions.data.remote.TransactionApiService
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.time.YearMonth
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.cancellation.CancellationException

@Singleton
class ApiTransactionRepository @Inject constructor(
    private val transactionApiService: TransactionApiService,
    private val apiCaller: ApiCaller,
    private val transactionDao: TransactionDao,
    private val errorLogger: ErrorLogger,
) : TransactionRepository {

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
                cache(month, transactions, hasMore)
            }

            is Outcome.Failure -> Outcome.Failure(result.error.toTransactionError())
        }
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private suspend fun cache(
        month: YearMonth,
        transactions: List<Transaction>,
        hasMore: Boolean,
    ): TransactionResult<Unit> = try {
        transactionDao.replaceRecent(
            from = month.atDay(1),
            to = month.atEndOfMonth(),
            transactions = transactions.map(Transaction::asEntity),
            hasMore = hasMore,
        )
        Outcome.Success(Unit)
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Caching transactions failed", e)
        Outcome.Failure(TransactionError.Unexpected)
    }
}
