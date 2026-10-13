package com.djtech.monai.feature.categories.presentation.categoryform.components

import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.model.CategoryType

/** The name, with the category's type and a character count under it, or why it was refused. */
@Composable
internal fun CategoryFormName(
    name: String,
    type: CategoryType,
    maxLength: Int,
    error: UiText?,
    onNameChange: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    val caption = stringResource(
        when (type) {
            CategoryType.EXPENSE -> R.string.category_form_expense_caption
            CategoryType.INCOME -> R.string.category_form_income_caption
        },
        name.length,
        maxLength,
    )
    MonAITextField(
        value = name,
        onValueChange = onNameChange,
        modifier = modifier,
        label = stringResource(R.string.category_form_name),
        placeholder = stringResource(R.string.category_form_name_placeholder),
        supportingText = error?.asString() ?: caption,
        tone = if (error != null) MonAIFieldTone.Error else MonAIFieldTone.Neutral,
        keyboardOptions = KeyboardOptions(
            capitalization = KeyboardCapitalization.Words,
            imeAction = ImeAction.Done,
        ),
    )
}
