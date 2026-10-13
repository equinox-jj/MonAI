package com.djtech.monai.feature.categories.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
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

    private companion object {
        val CREATED: Instant = Instant.parse("2026-10-10T05:40:00Z")
    }
}
