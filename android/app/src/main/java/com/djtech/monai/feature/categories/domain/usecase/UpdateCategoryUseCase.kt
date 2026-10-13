package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Category
import com.djtech.monai.feature.categories.domain.model.CategoryChanges
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryResult
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import com.djtech.monai.feature.categories.domain.validation.nameIssue
import com.djtech.monai.feature.categories.domain.validation.normalized
import javax.inject.Inject

/**
 * Renames or restyles [original] to match [input], sending only what changed; a blank or too-long
 * name fails without a request. The type can't change.
 */
class UpdateCategoryUseCase @Inject constructor(private val categoryRepository: CategoryRepository) {

    suspend operator fun invoke(original: Category, input: CategoryInput): CategoryResult<Category> {
        val normalized = input.normalized()
        normalized.nameIssue()?.let { return Outcome.Failure(CategoryError.InvalidName(it)) }
        val changes = CategoryChanges(
            name = normalized.name.takeIf { it != original.name },
            icon = normalized.icon.takeIf { it != original.icon },
            color = normalized.color.takeIf { it != original.color },
        )
        if (changes == CategoryChanges()) return Outcome.Success(original)
        return categoryRepository.updateCategory(original.id, changes)
    }
}
