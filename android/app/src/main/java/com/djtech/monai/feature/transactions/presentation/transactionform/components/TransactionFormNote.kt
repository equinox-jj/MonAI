package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.icon.MonAIIcons

/** The optional note, a single line of up to 200 characters. */
@Composable
internal fun TransactionFormNote(
    note: String,
    onNoteChange: (String) -> Unit,
    error: String?,
    modifier: Modifier = Modifier,
) {
    MonAITextField(
        value = note,
        onValueChange = onNoteChange,
        modifier = modifier,
        placeholder = stringResource(R.string.transaction_form_note_hint),
        leadingIcon = MonAIIcons.EditNote,
        supportingText = error,
        tone = if (error != null) MonAIFieldTone.Error else MonAIFieldTone.Neutral,
        compact = true,
        keyboardOptions = KeyboardOptions(
            capitalization = KeyboardCapitalization.Sentences,
            imeAction = ImeAction.Done,
        ),
        contentDescription = stringResource(R.string.transaction_form_note),
    )
}
