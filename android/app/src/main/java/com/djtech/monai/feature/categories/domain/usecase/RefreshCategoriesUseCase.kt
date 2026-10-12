package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.feature.categories.domain.model.CategoryResult
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import javax.inject.Inject

/** Replaces the cached categories with the server's, hidden ones included. */
class RefreshCategoriesUseCase @Inject constructor(private val categoryRepository: CategoryRepository) {
    suspend operator fun invoke(): CategoryResult<Unit> = categoryRepository.refresh()
}
