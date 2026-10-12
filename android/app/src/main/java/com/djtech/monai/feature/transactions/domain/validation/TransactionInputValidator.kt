package com.djtech.monai.feature.transactions.domain.validation

import com.djtech.monai.core.common.format.MAX_AMOUNT
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import java.time.LocalDate

/** The API's limit on notes. */
const val MAX_NOTE_LENGTH = 200

/**
 * Trims the note and drops fields the type doesn't use (a category on a transfer, a destination
 * on an expense), so switching type on the form never sends a stale value.
 */
fun TransactionInput.normalized(): TransactionInput = copy(
    toWalletId = toWalletId.takeIf { type == TransactionType.TRANSFER },
    categoryId = categoryId.takeIf { type != TransactionType.TRANSFER },
    note = note?.trim()?.takeIf(String::isNotEmpty),
    merchant = merchant?.trim()?.takeIf(String::isNotEmpty),
)

/** The API's create rules, checked on the device so the form can point at every bad field at once. */
fun TransactionInput.validate(today: LocalDate): List<TransactionFieldError> = buildList {
    fun fail(field: TransactionField, issue: TransactionFieldIssue) = add(TransactionFieldError(field, issue))

    when {
        amount <= 0 -> fail(TransactionField.AMOUNT, TransactionFieldIssue.REQUIRED)
        amount > MAX_AMOUNT -> fail(TransactionField.AMOUNT, TransactionFieldIssue.TOO_LARGE)
    }
    if (walletId == null) fail(TransactionField.WALLET, TransactionFieldIssue.REQUIRED)
    if (type == TransactionType.TRANSFER) {
        when {
            toWalletId == null -> fail(TransactionField.TO_WALLET, TransactionFieldIssue.REQUIRED)
            toWalletId == walletId -> fail(TransactionField.TO_WALLET, TransactionFieldIssue.SAME_WALLET)
        }
    } else if (categoryId == null) {
        fail(TransactionField.CATEGORY, TransactionFieldIssue.REQUIRED)
    }
    if (date.isAfter(today)) fail(TransactionField.DATE, TransactionFieldIssue.FUTURE_DATE)
    if ((note?.length ?: 0) > MAX_NOTE_LENGTH) fail(TransactionField.NOTE, TransactionFieldIssue.TOO_LARGE)
}
