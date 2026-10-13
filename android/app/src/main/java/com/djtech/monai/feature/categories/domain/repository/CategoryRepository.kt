package com.djtech.monai.feature.categories.domain.repository

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryInput
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

    /** Creates a custom category and caches it. Input is sent as given. */
    suspend fun createCategory(input: CategoryInput): CategoryResult<Category>

    /** Renames, restyles, hides or unhides a category and caches the result. */
    suspend fun updateCategory(id: String, changes: CategoryChanges): CategoryResult<Category>

    /**
     * Deletes a custom category. Its transactions, if any, move to [moveTo] (a category of the same
     * type), in the cache too; without one, a category in use fails with `HasTransactions`.
     */
    suspend fun deleteCategory(id: String, moveTo: String?): CategoryResult<Unit>
}
