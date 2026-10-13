package com.djtech.monai.feature.categories.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.update
import java.time.Instant

/**
 * Serves [categories] as the cache and answers refresh with [refreshResult]. A create records its
 * input and, unless [createError] is set, caches the category.
 */
class FakeCategoryRepository(categories: List<Category> = emptyList()) : CategoryRepository {
    val categories = MutableStateFlow(categories)
    var refreshResult: CategoryResult<Unit> = Outcome.Success(Unit)
    var refreshCount = 0
    var createError: CategoryError? = null
    val createdInputs = mutableListOf<CategoryInput>()
    val updates = mutableListOf<Pair<String, CategoryChanges>>()
    var updateError: CategoryError? = null
    val deletions = mutableListOf<Pair<String, String?>>()

    /** Fails deletes without a target, like the server does for a category in use. */
    val categoriesInUse = mutableSetOf<String>()
    var deleteError: CategoryError? = null

    override fun observeCategories(): Flow<List<Category>> = categories

    override fun observeVisibleCategories(type: CategoryType): Flow<List<Category>> =
        categories.map { list -> list.filter { it.type == type && !it.isHidden } }

    override suspend fun refresh(): CategoryResult<Unit> {
        refreshCount++
        return refreshResult
    }

    override suspend fun createCategory(input: CategoryInput): CategoryResult<Category> {
        createdInputs += input
        createError?.let { return Outcome.Failure(it) }
        val category = Category(
            id = "created-${createdInputs.size}",
            name = input.name,
            type = input.type,
            icon = input.icon,
            color = input.color,
            isDefault = false,
            isSystem = false,
            isHidden = false,
            createdAt = CREATED,
            updatedAt = CREATED,
        )
        this.categories.update { it + category }
        return Outcome.Success(category)
    }

    override suspend fun updateCategory(id: String, changes: CategoryChanges): CategoryResult<Category> {
        updates += id to changes
        updateError?.let { return Outcome.Failure(it) }
        val current = categories.value.firstOrNull { it.id == id } ?: return Outcome.Failure(CategoryError.NotFound)
        val updated = current.copy(
            name = changes.name ?: current.name,
            icon = changes.icon ?: current.icon,
            color = changes.color ?: current.color,
            isHidden = changes.isHidden ?: current.isHidden,
        )
        categories.update { list -> list.map { if (it.id == id) updated else it } }
        return Outcome.Success(updated)
    }

    override suspend fun deleteCategory(id: String, moveTo: String?): CategoryResult<Unit> {
        deletions += id to moveTo
        deleteError?.let { return Outcome.Failure(it) }
        if (moveTo == null && id in categoriesInUse) return Outcome.Failure(CategoryError.HasTransactions)
        categories.update { list -> list.filterNot { it.id == id } }
        return Outcome.Success(Unit)
    }

    private companion object {
        val CREATED: Instant = Instant.parse("2026-10-10T05:40:00Z")
    }
}
