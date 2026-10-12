package com.djtech.monai.feature.transactions.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import java.time.YearMonth

/** Serves [transactions] as the cache, sorted like the DAO, and records each refresh. */
class FakeTransactionRepository(transactions: List<Transaction> = emptyList()) : TransactionRepository {
    val transactions = MutableStateFlow(transactions)
    var refreshResult: TransactionResult<Unit> = Outcome.Success(Unit)
    val refreshes = mutableListOf<Pair<YearMonth, Int>>()

    override fun observeRecentTransactions(month: YearMonth, limit: Int): Flow<List<Transaction>> =
        transactions.map { list ->
            list.filter { YearMonth.from(it.date) == month }
                .sortedWith(compareByDescending<Transaction> { it.date }.thenByDescending { it.id })
                .take(limit)
        }

    override suspend fun refreshRecentTransactions(month: YearMonth, limit: Int): TransactionResult<Unit> {
        refreshes += month to limit
        return refreshResult
    }
}
