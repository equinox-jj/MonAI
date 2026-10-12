package com.djtech.monai.core.database.dao

import androidx.room3.Dao
import androidx.room3.Query
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.TransactionRemoteKeyEntity

@Dao
interface TransactionRemoteKeyDao {

    @Query("SELECT * FROM transaction_remote_keys WHERE query_key = :queryKey")
    suspend fun get(queryKey: String): TransactionRemoteKeyEntity?

    @Upsert
    suspend fun upsert(key: TransactionRemoteKeyEntity)

    @Query("DELETE FROM transaction_remote_keys WHERE query_key = :queryKey")
    suspend fun delete(queryKey: String)
}
