package com.djtech.monai.feature.categories.presentation.categoryform.preview

import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.presentation.categoryform.CategoryFormState
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryColorChoice
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryIconChoice

internal object CategoryFormPreviewData {
    val state = CategoryFormState(
        type = CategoryType.EXPENSE,
        name = "Kopi",
        icon = CategoryIconChoice.Coffee,
        color = CategoryColorChoice.Indigo,
    )
}
