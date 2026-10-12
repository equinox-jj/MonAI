package com.djtech.monai.feature.categories.domain.repository

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.model.CategoryResult
import kotlinx.coroutines.flow.Flow

/** Categories read from the local cache; [refresh] fills it from the API. */
interface CategoryRepository {

    /** Every category, hidden ones included, by name. For labelling transactions by category id. */
    fun observeCategories(): Flow<List<Category>>

    /** Categories of [type] that are not hidden, by name. For pickers. */
    fun observeVisibleCategories(type: CategoryType): Flow<List<Category>>

    /** Replaces the cache with the server's categories, hidden ones included. */
    suspend fun refresh(): CategoryResult<Unit>
}
