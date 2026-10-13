package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.model.Category
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** Each category as it is created, so a picker can select the one just added. */
class ObserveCreatedCategoriesUseCase @Inject constructor(private val categoryRepository: CategoryRepository) {
    operator fun invoke(): Flow<Category> = categoryRepository.created
}
