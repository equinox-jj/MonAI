package com.djtech.monai.feature.categories.domain.usecase

import com.djtech.monai.core.model.Category
import com.djtech.monai.feature.categories.domain.event.CategoryCreationEvents
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** Each category as it is created, so a picker can select the one just added. */
class ObserveCreatedCategoriesUseCase @Inject constructor(private val creationEvents: CategoryCreationEvents) {
    operator fun invoke(): Flow<Category> = creationEvents.created
}
