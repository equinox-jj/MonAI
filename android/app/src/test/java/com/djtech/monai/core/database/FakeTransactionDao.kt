package com.djtech.monai.core.database

import androidx.paging.PagingSource
import com.djtech.monai.core.database.dao.TransactionDao
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.model.TransactionType
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import java.time.LocalDate

/**
 * In-memory [TransactionDao] ordered like the real queries (date, then id, both descending).
 * [replaceRecent] is the interface's own default, so it runs on these writes. Paging isn't faked.
 */
class FakeTransactionDao(initial: List<TransactionEntity> = emptyList()) : TransactionDao {
    private val rows = MutableStateFlow(initial.associateBy { it.id })

    /** When set, every write throws it, like a database that cannot be written. */
    var failure: Exception? = null

    val transactions: List<TransactionEntity> get() = rows.value.values.sorted()

    override fun pagingSource(
        from: LocalDate,
        to: LocalDate,
        walletId: String?,
        categoryId: String?,
        type: TransactionType?,
    ): PagingSource<Int, TransactionEntity> = error("Not faked")

    override fun searchPagingSource(
        match: String,
        from: LocalDate,
        to: LocalDate,
        walletId: String?,
        categoryId: String?,
        type: TransactionType?,
    ): PagingSource<Int, TransactionEntity> = error("Not faked")

    override fun observe(id: String): Flow<TransactionEntity?> = rows.map { it[id] }

    override fun observeRecent(from: LocalDate, to: LocalDate, limit: Int): Flow<List<TransactionEntity>> =
        rows.map { all -> all.values.filter { it.date in from..to }.sorted().take(limit) }

    override suspend fun upsertAll(transactions: List<TransactionEntity>) {
        failure?.let { throw it }
        rows.value += transactions.associateBy { it.id }
    }

    override suspend fun delete(id: String) {
        failure?.let { throw it }
        rows.value -= id
    }

    override suspend fun deleteInRange(from: LocalDate, to: LocalDate) {
        failure?.let { throw it }
        rows.value = rows.value.filterValues { it.date !in from..to }
    }

    override suspend fun deleteFromKey(date: LocalDate, id: String, to: LocalDate) {
        failure?.let { throw it }
        rows.value = rows.value.filterValues { row ->
            val atOrAfterKey = row.date > date || (row.date == date && row.id >= id)
            !(row.date <= to && atOrAfterKey)
        }
    }

    private fun Collection<TransactionEntity>.sorted(): List<TransactionEntity> =
        sortedWith(compareByDescending<TransactionEntity> { it.date }.thenByDescending { it.id })
}
