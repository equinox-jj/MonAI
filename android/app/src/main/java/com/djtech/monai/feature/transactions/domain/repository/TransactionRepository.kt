package com.djtech.monai.feature.transactions.domain.repository

import androidx.paging.PagingData
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import kotlinx.coroutines.flow.Flow
import java.time.LocalDate
import java.time.YearMonth

/**
 * Transactions read from the local cache, which the refresh and paging methods fill from the API.
 * Writes go to the API first and update the cache with what it returns. Paged lists report a
 * failed page as a [com.djtech.monai.feature.transactions.domain.model.TransactionLoadException].
 */
interface TransactionRepository {

    /** The newest [limit] transactions of [month], newest first (date, then id). */
    fun observeRecentTransactions(month: YearMonth, limit: Int): Flow<List<Transaction>>

    /**
     * Fetches the first [limit] (1–100) transactions of [month] and replaces the part of the
     * cache they cover. The API lists one month at a time, so this never reaches older months.
     */
    suspend fun refreshRecentTransactions(month: YearMonth, limit: Int): TransactionResult<Unit>

    /** [month]'s transactions matching [filter], newest first, paged from the cache as the API fills it. */
    fun pagedTransactions(month: YearMonth, filter: TransactionFilter): Flow<PagingData<Transaction>>

    /** Income minus expenses of each cached day of [month] matching [filter]; transfers count as zero. */
    fun observeDailyNets(month: YearMonth, filter: TransactionFilter): Flow<Map<LocalDate, Long>>

    /** Transactions of [month] whose note or merchant contains [query], straight from the API. */
    fun searchTransactions(
        query: String,
        month: YearMonth,
        filter: TransactionFilter,
    ): Flow<PagingData<Transaction>>

    /**
     * Cached transactions of any month whose note or merchant has a word starting with each word of
     * [query]. Works offline; only finds what earlier lists and searches cached.
     */
    fun searchCachedTransactions(query: String, filter: TransactionFilter): Flow<PagingData<Transaction>>

    /** One cached transaction; null when it isn't cached. */
    fun observeTransaction(id: String): Flow<Transaction?>

    /** Fetches one transaction into the cache. Fails with NotFound, and drops it from the cache, when it is gone. */
    suspend fun refreshTransaction(id: String): TransactionResult<Unit>

    /** [input] must already be valid (see the create use case). */
    suspend fun createTransaction(input: TransactionInput): TransactionResult<Transaction>

    /** Replaces every field of transaction [id] with [input], which must already be valid. */
    suspend fun updateTransaction(id: String, input: TransactionInput): TransactionResult<Transaction>

    /**
     * Soft-deletes [id] on the server and drops it from the cache. Returns the deleted transaction
     * when it was cached, so it can be named in the undo message, and emits it on [deletions].
     */
    suspend fun deleteTransaction(id: String): TransactionResult<Transaction?>

    /** Undoes a delete and caches the restored transaction. */
    suspend fun restoreTransaction(id: String): TransactionResult<Transaction>

    /** Transactions deleted through [deleteTransaction], for the undo message on whichever screen shows it. */
    val deletions: Flow<Transaction>
}
