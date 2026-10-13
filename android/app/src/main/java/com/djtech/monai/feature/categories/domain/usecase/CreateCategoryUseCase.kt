package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Category
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.model.CategoryResult
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import com.djtech.monai.feature.categories.domain.validation.nameIssue
import com.djtech.monai.feature.categories.domain.validation.normalized
import javax.inject.Inject

/** Creates a custom category; a blank or too-long name fails without a request. */
class CreateCategoryUseCase @Inject constructor(private val categoryRepository: CategoryRepository) {

    suspend operator fun invoke(input: CategoryInput): CategoryResult<Category> {
        val normalized = input.normalized()
        normalized.nameIssue()?.let { return Outcome.Failure(CategoryError.InvalidName(it)) }
        return categoryRepository.createCategory(normalized)
    }
}
