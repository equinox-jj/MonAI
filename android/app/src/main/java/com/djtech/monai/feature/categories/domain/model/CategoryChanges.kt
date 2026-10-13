package com.djtech.monai.feature.categories.domain.model

/** A `PATCH /categories/{id}`: only the non-null fields change. */
data class CategoryChanges(
    val name: String? = null,
    val icon: String? = null,
    val color: String? = null,
    val isHidden: Boolean? = null,
)
