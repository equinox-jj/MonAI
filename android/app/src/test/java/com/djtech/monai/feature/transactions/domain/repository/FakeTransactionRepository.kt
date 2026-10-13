package com.djtech.monai.feature.transactions.domain.repository

import androidx.paging.PagingData
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth

/**
 * Serves [transactions] as the cache, sorted like the DAO, and records every call. Paged lists
 * are one page of the cache when collected, filtered like the API; searches match note or merchant
 * ignoring case.
 */
class FakeTransactionRepository(transactions: List<Transaction> = emptyList()) : TransactionRepository {
    val transactions = MutableStateFlow(transactions)
    var refreshResult: TransactionResult<Unit> = Outcome.Success(Unit)
    val refreshes = mutableListOf<Pair<YearMonth, Int>>()

    /** Answers create and update; null echoes the input back as a saved transaction. */
    var saveResult: TransactionResult<Transaction>? = null
    var deleteResult: TransactionResult<Unit> = Outcome.Success(Unit)
    var restoreResult: TransactionResult<Transaction>? = null
    var refreshTransactionResult: TransactionResult<Unit> = Outcome.Success(Unit)

    /** When set, writes suspend until it completes, to observe the in-flight state. */
    var gate: CompletableDeferred<Unit>? = null

    val created = mutableListOf<TransactionInput>()
    val updated = mutableListOf<Pair<String, TransactionInput>>()
    val deletedIds = mutableListOf<String>()
    val restoredIds = mutableListOf<String>()
    val refreshedIds = mutableListOf<String>()
    val pagedQueries = mutableListOf<Pair<YearMonth, TransactionFilter>>()
    val searches = mutableListOf<Triple<String, YearMonth?, TransactionFilter>>()

    private val deleted = MutableSharedFlow<Transaction>(extraBufferCapacity = 8)
    override val deletions: Flow<Transaction> = deleted

    override fun observeRecentTransactions(month: YearMonth, limit: Int): Flow<List<Transaction>> =
        transactions.map { list -> list.filter { YearMonth.from(it.date) == month }.sorted().take(limit) }

    override suspend fun refreshRecentTransactions(month: YearMonth, limit: Int): TransactionResult<Unit> {
        refreshes += month to limit
        return refreshResult
    }

    override fun pagedTransactions(month: YearMonth, filter: TransactionFilter): Flow<PagingData<Transaction>> {
        pagedQueries += month to filter
        return page { list -> list.filter { YearMonth.from(it.date) == month && it.matches(filter) } }
    }

    override fun observeDailyNets(month: YearMonth, filter: TransactionFilter): Flow<Map<LocalDate, Long>> =
        transactions.map { list ->
            list.filter { YearMonth.from(it.date) == month && it.matches(filter) }
                .groupBy { it.date }
                .mapValues { (_, day) -> day.sumOf { it.signedAmount() } }
        }

    override fun observeDailyOutflows(month: YearMonth, walletId: String): Flow<Map<LocalDate, Long>> =
        transactions.map { list ->
            list.filter {
                YearMonth.from(it.date) == month && it.walletId == walletId && it.type != TransactionType.INCOME
            }
                .groupBy { it.date }
                .mapValues { (_, day) -> day.sumOf { it.amount } }
        }

    override fun searchTransactions(
        query: String,
        month: YearMonth,
        filter: TransactionFilter,
    ): Flow<PagingData<Transaction>> {
        searches += Triple(query, month, filter)
        return page { list ->
            list.filter { YearMonth.from(it.date) == month && it.matches(filter) && it.contains(query) }
        }
    }

    override fun searchCachedTransactions(query: String, filter: TransactionFilter): Flow<PagingData<Transaction>> {
        searches += Triple(query, null, filter)
        return page { list -> list.filter { it.matches(filter) && it.contains(query) } }
    }

    override fun observeTransaction(id: String): Flow<Transaction?> =
        transactions.map { list -> list.find { it.id == id } }

    override suspend fun refreshTransaction(id: String): TransactionResult<Unit> {
        refreshedIds += id
        return refreshTransactionResult
    }

    override suspend fun createTransaction(input: TransactionInput): TransactionResult<Transaction> {
        created += input
        gate?.await()
        return saveResult ?: Outcome.Success(input.toTransaction("new"))
    }

    override suspend fun updateTransaction(id: String, input: TransactionInput): TransactionResult<Transaction> {
        updated += id to input
        gate?.await()
        return saveResult ?: Outcome.Success(input.toTransaction(id))
    }

    override suspend fun deleteTransaction(id: String): TransactionResult<Transaction?> {
        deletedIds += id
        gate?.await()
        return when (val result = deleteResult) {
            is Outcome.Failure -> result
            is Outcome.Success -> {
                val cached = transactions.value.find { it.id == id }
                transactions.value = transactions.value.filterNot { it.id == id }
                if (cached != null) deleted.emit(cached)
                Outcome.Success(cached)
            }
        }
    }

    override suspend fun restoreTransaction(id: String): TransactionResult<Transaction> {
        restoredIds += id
        return restoreResult ?: Outcome.Failure(TransactionError.NotFound)
    }

    // One page of what is cached when collected; a finite flow, so Paging's asSnapshot completes.
    private fun page(select: (List<Transaction>) -> List<Transaction>): Flow<PagingData<Transaction>> =
        flow { emit(PagingData.from(select(transactions.value).sorted())) }

    private fun List<Transaction>.sorted() =
        sortedWith(compareByDescending<Transaction> { it.date }.thenByDescending { it.id })

    private fun Transaction.matches(filter: TransactionFilter) =
        (filter.walletId == null || walletId == filter.walletId || toWalletId == filter.walletId) &&
            (filter.categoryId == null || categoryId == filter.categoryId) &&
            (filter.type == null || type == filter.type)

    private fun Transaction.signedAmount(): Long = when (type) {
        TransactionType.INCOME -> amount
        TransactionType.EXPENSE -> -amount
        TransactionType.TRANSFER -> 0
    }

    private fun Transaction.contains(query: String) =
        listOfNotNull(note, merchant).any { it.contains(query.trim(), ignoreCase = true) }

    private fun TransactionInput.toTransaction(id: String) = Transaction(
        id = id,
        type = type,
        amount = amount,
        walletId = walletId.orEmpty(),
        toWalletId = toWalletId,
        categoryId = categoryId,
        date = date,
        note = note,
        merchant = merchant,
        receiptUrl = null,
        source = TransactionSource.MANUAL,
        createdAt = Instant.EPOCH,
        updatedAt = Instant.EPOCH,
    )
}
