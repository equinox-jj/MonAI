package com.djtech.monai.core.database.dao

import androidx.room3.Dao
import androidx.room3.Query
import androidx.room3.Transaction
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.WalletEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface WalletDao {

    /** Default wallet first, then by name. Archived wallets are included; callers filter. */
    @Query("SELECT * FROM wallets ORDER BY is_default DESC, name COLLATE NOCASE ASC")
    fun observeAll(): Flow<List<WalletEntity>>

    @Query("SELECT * FROM wallets WHERE id = :id")
    fun observe(id: String): Flow<WalletEntity?>

    @Upsert
    suspend fun upsertAll(wallets: List<WalletEntity>)

    @Query("DELETE FROM wallets WHERE id = :id")
    suspend fun delete(id: String)

    @Query("DELETE FROM wallets")
    suspend fun deleteAll()

    /** Swaps in a full list from the server, dropping wallets it no longer returns. */
    @Transaction
    suspend fun replaceAll(wallets: List<WalletEntity>) {
        deleteAll()
        upsertAll(wallets)
    }
}
