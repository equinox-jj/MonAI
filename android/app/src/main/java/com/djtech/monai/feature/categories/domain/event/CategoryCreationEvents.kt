package com.djtech.monai.feature.categories.domain.event

import com.djtech.monai.core.model.Category
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Categories created from any screen, so a picker on another screen can select the one just added.
 * A singleton because the category form and the picker's screen don't share a scope. Nothing is
 * replayed.
 */
@Singleton
class CategoryCreationEvents @Inject constructor() {
    private val createdCategories = MutableSharedFlow<Category>(extraBufferCapacity = 8)
    val created: Flow<Category> = createdCategories.asSharedFlow()

    suspend fun emit(category: Category) = createdCategories.emit(category)
}
