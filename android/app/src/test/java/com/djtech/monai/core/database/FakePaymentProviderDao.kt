package com.djtech.monai.core.database

import com.djtech.monai.core.database.dao.PaymentProviderDao
import com.djtech.monai.core.database.entity.PaymentProviderCatalogEntity
import com.djtech.monai.core.database.entity.PaymentProviderEntity
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

/** In-memory [PaymentProviderDao] ordered like the real query: by sort order, then by name ignoring case. */
class FakePaymentProviderDao(
    initial: List<PaymentProviderEntity> = emptyList(),
    var meta: PaymentProviderCatalogEntity? = null,
) : PaymentProviderDao {
    private val rows = MutableStateFlow(initial)

    /** When set, every write throws it, like a database that cannot be written. */
    var failure: Exception? = null

    val providers: List<PaymentProviderEntity> get() = rows.value.sorted()

    override fun observeAll(): Flow<List<PaymentProviderEntity>> = rows.map { it.sorted() }

    override suspend fun catalogMeta(): PaymentProviderCatalogEntity? = meta

    override suspend fun upsertMeta(meta: PaymentProviderCatalogEntity) {
        failure?.let { throw it }
        this.meta = meta
    }

    override suspend fun upsertAll(providers: List<PaymentProviderEntity>) {
        failure?.let { throw it }
        val byId = rows.value.associateBy { it.id } + providers.associateBy { it.id }
        rows.value = byId.values.toList()
    }

    override suspend fun deleteAll() {
        failure?.let { throw it }
        rows.value = emptyList()
    }

    // One update, as Room's @Transaction would emit once.
    override suspend fun replaceCatalog(meta: PaymentProviderCatalogEntity, providers: List<PaymentProviderEntity>) {
        failure?.let { throw it }
        rows.value = providers
        this.meta = meta
    }

    private fun List<PaymentProviderEntity>.sorted(): List<PaymentProviderEntity> =
        sortedWith(compareBy<PaymentProviderEntity> { it.sortOrder }.thenBy(String.CASE_INSENSITIVE_ORDER) { it.name })
}
