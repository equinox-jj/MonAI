package com.djtech.monai.core.database

import com.djtech.monai.core.database.dao.WalletDao
import com.djtech.monai.core.database.entity.WalletEntity
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

/** In-memory [WalletDao] ordered like the real query: default first, then by name ignoring case. */
class FakeWalletDao(initial: List<WalletEntity> = emptyList()) : WalletDao {
    private val rows = MutableStateFlow(initial.associateBy { it.id })

    /** When set, every write throws it, like a database that cannot be written. */
    var failure: Exception? = null

    val wallets: List<WalletEntity> get() = rows.value.values.sorted()

    override fun observeAll(): Flow<List<WalletEntity>> = rows.map { it.values.sorted() }

    override fun observe(id: String): Flow<WalletEntity?> = rows.map { it[id] }

    override suspend fun upsertAll(wallets: List<WalletEntity>) {
        failure?.let { throw it }
        rows.value += wallets.associateBy { it.id }
    }

    override suspend fun delete(id: String) {
        failure?.let { throw it }
        rows.value -= id
    }

    override suspend fun deleteAll() {
        failure?.let { throw it }
        rows.value = emptyMap()
    }

    // One update, as Room's @Transaction would emit once.
    override suspend fun replaceAll(wallets: List<WalletEntity>) {
        failure?.let { throw it }
        rows.value = wallets.associateBy { it.id }
    }

    private fun Collection<WalletEntity>.sorted(): List<WalletEntity> =
        sortedWith(compareByDescending<WalletEntity> { it.isDefault }.thenBy(String.CASE_INSENSITIVE_ORDER) { it.name })
}
