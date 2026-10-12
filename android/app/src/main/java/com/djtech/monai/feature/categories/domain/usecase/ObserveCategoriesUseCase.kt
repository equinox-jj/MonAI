package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.model.Category
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** Every cached category, hidden ones included, by name. */
class ObserveCategoriesUseCase @Inject constructor(private val categoryRepository: CategoryRepository) {
    operator fun invoke(): Flow<List<Category>> = categoryRepository.observeCategories()
}
