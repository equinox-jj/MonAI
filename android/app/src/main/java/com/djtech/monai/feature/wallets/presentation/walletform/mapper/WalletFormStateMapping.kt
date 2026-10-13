package com.djtech.monai.feature.wallets.presentation.walletform.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue

/** One message per field, the first error found for it. */
internal fun List<WalletFieldError>.toFieldMessages(): Map<WalletField, UiText> =
    groupBy(WalletFieldError::field).mapValues { (_, errors) -> errors.first().toMessage() }

private fun WalletFieldError.toMessage(): UiText = UiText.Resource(
    when (issue) {
        WalletFieldIssue.REQUIRED -> when (field) {
            WalletField.TYPE -> R.string.wallet_form_error_type_required
            else -> R.string.wallet_form_error_name_required
        }

        WalletFieldIssue.TOO_LONG -> R.string.wallet_form_error_name_too_long
        WalletFieldIssue.TOO_LARGE -> R.string.wallet_form_error_balance_too_large
        WalletFieldIssue.ALREADY_EXISTS -> R.string.wallet_form_error_name_taken
        WalletFieldIssue.INVALID -> R.string.wallet_form_error_invalid
    },
)
