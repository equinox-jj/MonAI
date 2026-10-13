package com.djtech.monai.feature.wallets.presentation.walletform.components

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

/** "Wallet name" with [hint] under it, replaced by [error] when there is one. */
@Composable
internal fun WalletFormName(
    name: String,
    hint: String,
    error: UiText?,
    onNameChange: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    MonAITextField(
        value = name,
        onValueChange = onNameChange,
        modifier = modifier,
        label = stringResource(R.string.wallet_form_name),
        supportingText = error?.asString() ?: hint,
        tone = if (error != null) MonAIFieldTone.Error else MonAIFieldTone.Neutral,
        keyboardOptions = KeyboardOptions(
            capitalization = KeyboardCapitalization.Words,
            imeAction = ImeAction.Next,
        ),
    )
}
