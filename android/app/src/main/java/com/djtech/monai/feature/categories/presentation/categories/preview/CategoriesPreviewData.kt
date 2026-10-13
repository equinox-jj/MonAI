package com.djtech.monai.feature.categories.presentation.categories.preview

import com.djtech.monai.feature.categories.presentation.categories.CategoriesState
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryKind
import com.djtech.monai.feature.categories.presentation.categories.model.CategoryRow

internal object CategoriesPreviewData {
    val state = CategoriesState(
        isLoading = false,
        rows = listOf(
            row(
                "food",
                "Food",
                "restaurant",
                "#F97316",
            ),
            row(
                "transport",
                "Transport",
                "directions_car",
                "#0EA5E9",
            ),
            row(
                "fun",
                "Entertainment",
                "movie",
                "#F59E0B",
                isHidden = true,
            ),
            row(
                "kopi",
                "Kopi",
                "local_cafe",
                "#6366F1",
                kind = CategoryKind.CUSTOM,
            ),
            row(
                "other",
                "Other",
                "category",
                "#64748B",
                kind = CategoryKind.SYSTEM,
            ),
        ),
    )

    private fun row(
        id: String,
        name: String,
        icon: String,
        color: String,
        kind: CategoryKind = CategoryKind.DEFAULT,
        isHidden: Boolean = false,
    ) = CategoryRow(
        id = id,
        name = name,
        icon = icon,
        color = color,
        kind = kind,
        isHidden = isHidden,
    )
}
