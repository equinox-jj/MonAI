package com.djtech.monai.core.database.dao

import androidx.room3.Dao
import androidx.room3.Query
import androidx.room3.Transaction
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.PaymentProviderCatalogEntity
import com.djtech.monai.core.database.entity.PaymentProviderEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface PaymentProviderDao {

    @Query("SELECT * FROM payment_providers ORDER BY sort_order ASC, name COLLATE NOCASE ASC")
    fun observeAll(): Flow<List<PaymentProviderEntity>>

    /** Null until the catalog has been cached once. */
    @Query("SELECT * FROM payment_provider_catalog WHERE id = 0")
    suspend fun catalogMeta(): PaymentProviderCatalogEntity?

    @Upsert
    suspend fun upsertMeta(meta: PaymentProviderCatalogEntity)

    @Upsert
    suspend fun upsertAll(providers: List<PaymentProviderEntity>)

    @Query("DELETE FROM payment_providers")
    suspend fun deleteAll()

    /** Stores a new catalog and its version/ETag together, so they never disagree. */
    @Transaction
    suspend fun replaceCatalog(
        meta: PaymentProviderCatalogEntity,
        providers: List<PaymentProviderEntity>,
    ) {
        deleteAll()
        upsertAll(providers)
        upsertMeta(meta)
    }
}
