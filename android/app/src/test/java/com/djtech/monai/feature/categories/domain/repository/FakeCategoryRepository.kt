package com.djtech.monai.feature.categories.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.model.CategoryResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

/** Serves [categories] as the cache and answers refresh with [refreshResult]. */
class FakeCategoryRepository(categories: List<Category> = emptyList()) : CategoryRepository {
    val categories = MutableStateFlow(categories)
    var refreshResult: CategoryResult<Unit> = Outcome.Success(Unit)
    var refreshCount = 0

    override fun observeCategories(): Flow<List<Category>> = categories

    override fun observeVisibleCategories(type: CategoryType): Flow<List<Category>> =
        categories.map { list -> list.filter { it.type == type && !it.isHidden } }

    override suspend fun refresh(): CategoryResult<Unit> {
        refreshCount++
        return refreshResult
    }
}
