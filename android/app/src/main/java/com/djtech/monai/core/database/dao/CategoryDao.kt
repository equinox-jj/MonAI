package com.djtech.monai.core.database.dao

import androidx.room3.Dao
import androidx.room3.Query
import androidx.room3.Transaction
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.CategoryEntity
import com.djtech.monai.core.model.CategoryType
import kotlinx.coroutines.flow.Flow

@Dao
interface CategoryDao {

    @Query("SELECT * FROM categories ORDER BY name COLLATE NOCASE ASC")
    fun observeAll(): Flow<List<CategoryEntity>>

    @Query("SELECT * FROM categories WHERE type = :type ORDER BY name COLLATE NOCASE ASC")
    fun observeByType(type: CategoryType): Flow<List<CategoryEntity>>

    @Upsert
    suspend fun upsertAll(categories: List<CategoryEntity>)

    @Query("DELETE FROM categories WHERE id = :id")
    suspend fun delete(id: String)

    @Query("DELETE FROM categories")
    suspend fun deleteAll()

    /** Swaps in a full list from the server, dropping categories it no longer returns. */
    @Transaction
    suspend fun replaceAll(categories: List<CategoryEntity>) {
        deleteAll()
        upsertAll(categories)
    }
}
