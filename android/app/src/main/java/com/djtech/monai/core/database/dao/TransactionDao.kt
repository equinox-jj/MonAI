package com.djtech.monai.core.database.dao

import androidx.paging.PagingSource
import androidx.room3.Dao
import androidx.room3.Query
import androidx.room3.Transaction
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.DailyAmount
import com.djtech.monai.core.database.entity.DailyNet
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.TransactionRemoteKeyEntity
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

    /** Each cached day's net for the list's day headers. Same filters as [pagingSource]. */
    @Query(
        """
        SELECT date, SUM(CASE type WHEN 'INCOME' THEN amount WHEN 'EXPENSE' THEN -amount ELSE 0 END) AS net
        FROM transactions
        WHERE date BETWEEN :from AND :to
          AND (:walletId IS NULL OR wallet_id = :walletId OR to_wallet_id = :walletId)
          AND (:categoryId IS NULL OR category_id = :categoryId)
          AND (:type IS NULL OR type = :type)
        GROUP BY date
        """,
    )
    fun observeDailyNets(
        from: LocalDate,
        to: LocalDate,
        walletId: String?,
        categoryId: String?,
        type: TransactionType?,
    ): Flow<List<DailyNet>>

    /**
     * Each cached day's money leaving [walletId]: its expenses plus transfers out of it, for the
     * wallet detail's "Money out" chart. Transfers into the wallet don't count.
     */
    @Query(
        """
        SELECT date, SUM(amount) AS amount
        FROM transactions
        WHERE date BETWEEN :from AND :to
          AND wallet_id = :walletId
          AND type IN ('EXPENSE', 'TRANSFER')
        GROUP BY date
        """,
    )
    fun observeDailyOutflows(from: LocalDate, to: LocalDate, walletId: String): Flow<List<DailyAmount>>

    @Query("SELECT * FROM transactions WHERE id = :id")
    fun observe(id: String): Flow<TransactionEntity?>

    /** The newest [limit] transactions dated between [from] and [to]. */
    @Query("SELECT * FROM transactions WHERE date BETWEEN :from AND :to ORDER BY date DESC, id DESC LIMIT :limit")
    fun observeRecent(from: LocalDate, to: LocalDate, limit: Int): Flow<List<TransactionEntity>>

    /**
     * The category of the newest [type] transaction whose note or merchant, trimmed and lowercased,
     * is [text] (already lowercase). Newest by last edit, so a corrected category wins next time.
     */
    @Query(
        """
        SELECT category_id FROM transactions
        WHERE type = :type
          AND category_id IS NOT NULL
          AND (lower(trim(note)) = :text OR lower(trim(merchant)) = :text)
        ORDER BY updated_at DESC
        LIMIT 1
        """,
    )
    suspend fun latestCategoryForText(text: String, type: TransactionType): String?

    @Upsert
    suspend fun upsertAll(transactions: List<TransactionEntity>)

    @Query("DELETE FROM transactions WHERE id = :id")
    suspend fun delete(id: String)

    /** Follows the server moving a deleted category's transactions to [to]. */
    @Query("UPDATE transactions SET category_id = :to WHERE category_id = :from")
    suspend fun moveCategory(from: String, to: String)

    /** Drops a date range before a RemoteMediator refresh re-fills it. */
    @Query("DELETE FROM transactions WHERE date BETWEEN :from AND :to")
    suspend fun deleteInRange(from: LocalDate, to: LocalDate)

    /** Drops rows up to [to] that sort at or before the ([date], [id]) key in list order. */
    @Query("DELETE FROM transactions WHERE date <= :to AND (date > :date OR (date = :date AND id >= :id))")
    suspend fun deleteFromKey(date: LocalDate, id: String, to: LocalDate)

    /** Drops the rows of a date range that a filtered list shows, before its RemoteMediator refresh re-fills them. */
    @Query(
        """
        DELETE FROM transactions
        WHERE date BETWEEN :from AND :to
          AND (:walletId IS NULL OR wallet_id = :walletId OR to_wallet_id = :walletId)
          AND (:categoryId IS NULL OR category_id = :categoryId)
          AND (:type IS NULL OR type = :type)
        """,
    )
    suspend fun deleteMatching(
        from: LocalDate,
        to: LocalDate,
        walletId: String?,
        categoryId: String?,
        type: TransactionType?,
    )

    @Query("SELECT * FROM transaction_remote_keys WHERE query_key = :queryKey")
    suspend fun remoteKey(queryKey: String): TransactionRemoteKeyEntity?

    @Upsert
    suspend fun upsertRemoteKey(key: TransactionRemoteKeyEntity)

    /**
     * A RemoteMediator refresh: replaces what the list's query covers with its first page and
     * saves where the next page starts, in one transaction so the list never shows a gap.
     */
    @Transaction
    suspend fun replaceQueryPage(
        from: LocalDate,
        to: LocalDate,
        walletId: String?,
        categoryId: String?,
        type: TransactionType?,
        transactions: List<TransactionEntity>,
        key: TransactionRemoteKeyEntity,
    ) {
        deleteMatching(
            from,
            to,
            walletId,
            categoryId,
            type,
        )
        upsertAll(transactions)
        upsertRemoteKey(key)
    }

    /** A RemoteMediator append: adds the next page and moves the cursor on. */
    @Transaction
    suspend fun appendQueryPage(transactions: List<TransactionEntity>, key: TransactionRemoteKeyEntity) {
        upsertAll(transactions)
        upsertRemoteKey(key)
    }

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
