package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** Cached categories of [type] that are not hidden, by name. For pickers. */
class ObserveVisibleCategoriesUseCase @Inject constructor(private val categoryRepository: CategoryRepository) {
    operator fun invoke(type: CategoryType): Flow<List<Category>> = categoryRepository.observeVisibleCategories(type)
}
