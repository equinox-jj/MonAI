package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.feature.categories.domain.model.CategoryResult
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import javax.inject.Inject

/**
 * Deletes a custom category. Try without [moveTo] first: a category in use fails with
 * `HasTransactions`, and the user then picks where its transactions go.
 */
class DeleteCategoryUseCase @Inject constructor(private val categoryRepository: CategoryRepository) {
    suspend operator fun invoke(id: String, moveTo: String? = null): CategoryResult<Unit> =
        categoryRepository.deleteCategory(id, moveTo)
}
