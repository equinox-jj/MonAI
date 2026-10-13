package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.common.result.map
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryResult
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import javax.inject.Inject

/** Hides a category from the pickers, or shows it again. Its transactions keep it either way. */
class SetCategoryHiddenUseCase @Inject constructor(private val categoryRepository: CategoryRepository) {
    suspend operator fun invoke(id: String, hidden: Boolean): CategoryResult<Unit> =
        categoryRepository.updateCategory(id, CategoryChanges(isHidden = hidden)).map { }
}
