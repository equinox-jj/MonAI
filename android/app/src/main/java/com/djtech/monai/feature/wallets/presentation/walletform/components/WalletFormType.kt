package com.djtech.monai.feature.wallets.presentation.walletform.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAISegment
import com.djtech.monai.core.designsystem.component.MonAISegmentedControl
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.WalletType

/** Cash / Bank / E-wallet / Other. A provider's type is shown but can't be changed. */
@Composable
internal fun WalletFormType(
    type: WalletType?,
    isLocked: Boolean,
    error: UiText?,
    onSelect: (WalletType) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val types = WalletType.entries
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.fieldLabelGap)) {
        Text(
            stringResource(R.string.wallet_form_type),
            style = MonAITheme.typography.labelMedium,
            color = colors.textSecondary,
        )
        MonAISegmentedControl(
            segments = types.map { MonAISegment(it.label()) },
            selectedIndex = types.indexOf(type),
            onSelect = { if (!isLocked) onSelect(types[it]) },
        )
        val note = when {
            error != null -> error.asString()
            isLocked -> stringResource(R.string.wallet_form_type_locked)
            else -> null
        }
        if (note != null) {
            Text(
                note,
                style = MonAITheme.typography.bodySmall,
                color = if (error != null) colors.errorText else colors.textTertiary,
            )
        }
    }
}
