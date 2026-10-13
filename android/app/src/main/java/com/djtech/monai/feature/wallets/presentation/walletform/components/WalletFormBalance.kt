package com.djtech.monai.feature.wallets.presentation.walletform.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.common.format.formatThousands
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAIInlineAlert
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.walletform.model.BalanceShift

/**
 * The wallet's opening amount: "Current balance" when adding, "Starting balance" when editing, with
 * a note on how much the current balance moves once the starting balance changes.
 */
@Composable
internal fun WalletFormBalance(
    amount: Long,
    isEdit: Boolean,
    shift: BalanceShift?,
    error: UiText?,
    onChange: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        MonAITextField(
            // Shown grouped ("Rp 1.250.000"); the ViewModel keeps only the digits of what is typed.
            value = if (amount == 0L) "" else "Rp " + formatThousands(amount),
            onValueChange = onChange,
            label = stringResource(
                if (isEdit) R.string.wallet_form_starting_balance else R.string.wallet_form_current_balance,
            ),
            placeholder = "Rp 0",
            supportingText = error?.asString()
                ?: stringResource(R.string.wallet_form_current_balance_help).takeUnless { isEdit },
            tone = if (error != null) MonAIFieldTone.Error else MonAIFieldTone.Neutral,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
        )
        if (shift != null) {
            MonAIInlineAlert(
                stringResource(
                    R.string.wallet_form_balance_shift,
                    formatRupiah(shift.from),
                    formatRupiah(shift.to),
                    formatRupiahSigned(
                        shift.delta,
                        if (shift.delta < 0) MoneySign.Negative else MoneySign.Positive,
                    ),
                ),
                tone = MonAIAlertTone.Warning,
            )
        }
    }
}
