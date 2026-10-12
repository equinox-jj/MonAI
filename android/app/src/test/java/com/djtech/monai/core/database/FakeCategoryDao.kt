package com.djtech.monai.core.database

import com.djtech.monai.core.database.dao.CategoryDao
import com.djtech.monai.core.database.entity.CategoryEntity
import com.djtech.monai.core.model.CategoryType
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

/** In-memory [CategoryDao] ordered like the real queries: by name ignoring case. */
class FakeCategoryDao(initial: List<CategoryEntity> = emptyList()) : CategoryDao {
    private val rows = MutableStateFlow(initial.associateBy { it.id })

    /** When set, every write throws it, like a database that cannot be written. */
    var failure: Exception? = null

    val categories: List<CategoryEntity> get() = rows.value.values.sorted()

    override fun observeAll(): Flow<List<CategoryEntity>> = rows.map { it.values.sorted() }

    override fun observeByType(type: CategoryType): Flow<List<CategoryEntity>> =
        rows.map { all -> all.values.filter { it.type == type }.sorted() }

    override suspend fun upsertAll(categories: List<CategoryEntity>) {
        failure?.let { throw it }
        rows.value += categories.associateBy { it.id }
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
    override suspend fun replaceAll(categories: List<CategoryEntity>) {
        failure?.let { throw it }
        rows.value = categories.associateBy { it.id }
    }

    private fun Collection<CategoryEntity>.sorted(): List<CategoryEntity> =
        sortedWith(compareBy(String.CASE_INSENSITIVE_ORDER) { it.name })
}
