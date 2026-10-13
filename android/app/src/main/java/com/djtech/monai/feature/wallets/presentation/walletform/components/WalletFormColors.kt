package com.djtech.monai.feature.wallets.presentation.walletform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.WalletColor

/** "Card color": one swatch per [WalletColor], the picked one ringed and checked. */
@Composable
internal fun WalletFormColors(
    selected: WalletColor?,
    onPick: (WalletColor) -> Unit,
    modifier: Modifier = Modifier,
) {
    val dark = MonAITheme.colors.isDark
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        Text(
            stringResource(R.string.wallet_form_card_color),
            style = MonAITheme.typography.labelMedium,
            color = MonAITheme.colors.textSecondary,
        )
        Row(
            Modifier.selectableGroup(),
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5),
        ) {
            WalletColor.entries.forEach { color ->
                val isSelected = color == selected
                val name = color.label()
                Box(
                    Modifier
                        .size(MonAITheme.sizes.touchTarget)
                        .then(
                            if (isSelected) {
                                Modifier
                                    .border(MonAITheme.sizes.borderFocused, MonAITheme.colors.focus, CircleShape)
                                    .padding(MonAITheme.spacing.x1)
                            } else {
                                Modifier
                            },
                        )
                        .clip(CircleShape)
                        .background(color.gradient(dark).brush)
                        .selectable(selected = isSelected, role = Role.RadioButton, onClick = { onPick(color) })
                        .semantics { contentDescription = name },
                    contentAlignment = Alignment.Center,
                ) {
                    if (isSelected) {
                        Icon(
                            MonAIIcons.Check,
                            contentDescription = null,
                            modifier = Modifier.size(MonAITheme.sizes.iconLg),
                            tint = Color.White,
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun WalletColor.label(): String = stringResource(
    when (this) {
        WalletColor.Indigo -> R.string.wallet_form_color_indigo
        WalletColor.Teal -> R.string.wallet_form_color_teal
        WalletColor.Green -> R.string.wallet_form_color_green
        WalletColor.Violet -> R.string.wallet_form_color_violet
        WalletColor.Rose -> R.string.wallet_form_color_rose
        WalletColor.Slate -> R.string.wallet_form_color_slate
    },
)
