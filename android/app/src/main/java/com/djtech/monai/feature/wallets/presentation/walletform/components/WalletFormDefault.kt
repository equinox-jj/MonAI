package com.djtech.monai.feature.wallets.presentation.walletform.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.selection.toggleable
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CheckboxDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.theme.MonAITheme

/**
 * "Make this my default wallet". Once a wallet is the default it can't be unticked: another
 * wallet has to become the default instead.
 */
@Composable
internal fun WalletFormDefault(
    checked: Boolean,
    isEdit: Boolean,
    enabled: Boolean,
    defaultWalletName: String?,
    onChange: (Boolean) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val subtitle = when {
        !isEdit -> stringResource(R.string.wallet_form_make_default_help)
        !enabled -> stringResource(R.string.wallet_form_default_current)
        defaultWalletName != null -> stringResource(R.string.wallet_form_default_other, defaultWalletName)
        else -> null
    }
    Row(
        modifier
            .heightIn(min = MonAITheme.sizes.buttonMedium)
            .toggleable(value = checked, enabled = enabled, role = Role.Checkbox, onValueChange = onChange),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Column(Modifier.weight(1f)) {
            Text(
                stringResource(if (isEdit) R.string.wallet_form_default else R.string.wallet_form_make_default),
                style = MonAITheme.typography.titleSmall,
                color = colors.textPrimary,
            )
            if (subtitle != null) {
                Text(subtitle, style = MonAITheme.typography.bodySmall, color = colors.textTertiary)
            }
        }
        Checkbox(
            checked = checked,
            onCheckedChange = null,
            enabled = enabled,
            colors = CheckboxDefaults.colors(checkedColor = colors.primary, uncheckedColor = colors.borderStrong),
        )
    }
}
