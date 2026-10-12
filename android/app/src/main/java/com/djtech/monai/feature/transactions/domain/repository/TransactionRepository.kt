package com.djtech.monai.feature.transactions.domain.repository

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth

/** Transactions read from the local cache; the refresh methods fill it from the API. */
interface TransactionRepository {

    /** The newest [limit] transactions of [month], newest first (date, then id). */
    fun observeRecentTransactions(month: YearMonth, limit: Int): Flow<List<Transaction>>

    /**
     * Fetches the first [limit] (1–100) transactions of [month] and replaces the part of the
     * cache they cover. The API lists one month at a time, so this never reaches older months.
     */
    suspend fun refreshRecentTransactions(month: YearMonth, limit: Int): TransactionResult<Unit>
}
