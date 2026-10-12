package com.djtech.monai.feature.transactions.presentation.transactionform.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue

/** The category type a transaction type uses; transfers have none. */
fun TransactionType.categoryType(): CategoryType? = when (this) {
    TransactionType.EXPENSE -> CategoryType.EXPENSE
    TransactionType.INCOME -> CategoryType.INCOME
    TransactionType.TRANSFER -> null
}

/** One message per field; the first issue of a field wins. */
fun List<TransactionFieldError>.toFieldMessages(): Map<TransactionField, UiText> =
    groupBy(TransactionFieldError::field).mapValues { (field, errors) -> errors.first().issue.message(field) }

private fun TransactionFieldIssue.message(field: TransactionField): UiText = UiText.Resource(
    when (this) {
        TransactionFieldIssue.REQUIRED -> when (field) {
            TransactionField.AMOUNT -> R.string.transaction_form_error_amount_required
            TransactionField.WALLET -> R.string.transaction_form_error_wallet_required
            TransactionField.TO_WALLET -> R.string.transaction_form_error_to_wallet_required
            TransactionField.CATEGORY -> R.string.transaction_form_error_category_required
            TransactionField.DATE, TransactionField.NOTE -> R.string.transaction_form_error_invalid
        }

        TransactionFieldIssue.TOO_LARGE -> if (field == TransactionField.NOTE) {
            R.string.transaction_form_error_note_too_long
        } else {
            R.string.transaction_form_error_amount_too_large
        }

        TransactionFieldIssue.FUTURE_DATE -> R.string.transaction_form_error_future_date
        TransactionFieldIssue.SAME_WALLET -> R.string.transaction_form_error_same_wallet
        TransactionFieldIssue.TYPE_MISMATCH -> R.string.transaction_form_error_category_mismatch
        TransactionFieldIssue.ARCHIVED -> R.string.transaction_form_error_archived
        TransactionFieldIssue.NOT_FOUND -> R.string.transaction_form_error_not_found
        TransactionFieldIssue.INVALID -> R.string.transaction_form_error_invalid
    },
)
