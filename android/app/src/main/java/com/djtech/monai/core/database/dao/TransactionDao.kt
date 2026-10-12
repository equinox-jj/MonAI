package com.djtech.monai.core.database.dao

import androidx.paging.PagingSource
import androidx.room3.Dao
import androidx.room3.Query
import androidx.room3.Transaction
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.model.TransactionType
import kotlinx.coroutines.flow.Flow
import java.time.LocalDate

/**
 * Lists match the API's order (date, then id, both descending). Null filters match
 * everything; [walletId] matches the source or destination wallet like `GET /transactions`.
 */
@Dao
interface TransactionDao {

    @Query(
        """
        SELECT * FROM transactions
        WHERE date BETWEEN :from AND :to
          AND (:walletId IS NULL OR wallet_id = :walletId OR to_wallet_id = :walletId)
          AND (:categoryId IS NULL OR category_id = :categoryId)
          AND (:type IS NULL OR type = :type)
        ORDER BY date DESC, id DESC
        """,
    )
    fun pagingSource(
        from: LocalDate,
        to: LocalDate,
        walletId: String?,
        categoryId: String?,
        type: TransactionType?,
    ): PagingSource<Int, TransactionEntity>

    /** Offline search; build [match] with `toFtsMatchQuery`. */
    @Query(
        """
        SELECT transactions.* FROM transactions
        JOIN transactions_fts ON transactions.rowid = transactions_fts.rowid
        WHERE transactions_fts MATCH :match
          AND date BETWEEN :from AND :to
          AND (:walletId IS NULL OR wallet_id = :walletId OR to_wallet_id = :walletId)
          AND (:categoryId IS NULL OR category_id = :categoryId)
          AND (:type IS NULL OR type = :type)
        ORDER BY date DESC, id DESC
        """,
    )
    fun searchPagingSource(
        match: String,
        from: LocalDate,
        to: LocalDate,
        walletId: String?,
        categoryId: String?,
        type: TransactionType?,
    ): PagingSource<Int, TransactionEntity>

    @Query("SELECT * FROM transactions WHERE id = :id")
    fun observe(id: String): Flow<TransactionEntity?>

    /** The newest [limit] transactions dated between [from] and [to]. */
    @Query("SELECT * FROM transactions WHERE date BETWEEN :from AND :to ORDER BY date DESC, id DESC LIMIT :limit")
    fun observeRecent(from: LocalDate, to: LocalDate, limit: Int): Flow<List<TransactionEntity>>

    @Upsert
    suspend fun upsertAll(transactions: List<TransactionEntity>)

    @Query("DELETE FROM transactions WHERE id = :id")
    suspend fun delete(id: String)

    /** Drops a date range before a RemoteMediator refresh re-fills it. */
    @Query("DELETE FROM transactions WHERE date BETWEEN :from AND :to")
    suspend fun deleteInRange(from: LocalDate, to: LocalDate)

    /** Drops rows up to [to] that sort at or before the ([date], [id]) key in list order. */
    @Query("DELETE FROM transactions WHERE date <= :to AND (date > :date OR (date = :date AND id >= :id))")
    suspend fun deleteFromKey(date: LocalDate, id: String, to: LocalDate)

    /**
     * Swaps in the first page of `GET /transactions` for the range. Only what the page covers is
     * replaced: the whole range when [hasMore] is false, else from its oldest row up, so older
     * rows a RemoteMediator cached survive.
     */
    @Transaction
    suspend fun replaceRecent(
        from: LocalDate,
        to: LocalDate,
        transactions: List<TransactionEntity>,
        hasMore: Boolean,
    ) {
        val oldest = transactions.lastOrNull()
        if (!hasMore || oldest == null) {
            deleteInRange(from, to)
        } else {
            deleteFromKey(oldest.date, oldest.id, to)
        }
        upsertAll(transactions)
    }
}
