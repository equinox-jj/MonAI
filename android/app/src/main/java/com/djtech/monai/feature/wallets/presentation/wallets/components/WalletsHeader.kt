package com.djtech.monai.feature.wallets.presentation.wallets.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIScreenTitle
import com.djtech.monai.core.designsystem.icon.MonAIIcons

/** "Wallets" with the "Add wallet" pill. */
@Composable
internal fun WalletsHeader(onAdd: () -> Unit, modifier: Modifier = Modifier) {
    MonAIScreenTitle(
        stringResource(R.string.wallets_title),
        modifier,
        action = {
            MonAIButton(
                stringResource(R.string.wallets_add),
                onClick = onAdd,
                variant = MonAIButtonVariant.Tonal,
                size = MonAIButtonSize.Small,
                leadingIcon = MonAIIcons.Add,
            )
        },
    )
}
