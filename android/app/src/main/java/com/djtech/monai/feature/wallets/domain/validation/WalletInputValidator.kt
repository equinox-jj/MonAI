package com.djtech.monai.feature.wallets.domain.validation

import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue
import com.djtech.monai.feature.wallets.domain.model.WalletInput

/** The API's limits on wallet fields. */
const val MAX_WALLET_NAME_LENGTH = 30
const val MAX_INITIAL_BALANCE = 999_999_999_999_999L

private val HEX_COLOR = Regex("^#[0-9A-Fa-f]{6}$")

/** Trims the name and drops a blank color, so the form never sends whitespace. */
fun WalletInput.normalized(): WalletInput = copy(
    name = name.trim(),
    color = color?.trim()?.takeIf(String::isNotEmpty),
)

/** The API's create rules, checked on the device so the form can point at every bad field at once. */
fun WalletInput.validate(): List<WalletFieldError> = buildList {
    fun fail(field: WalletField, issue: WalletFieldIssue) = add(WalletFieldError(field, issue))

    when {
        name.isBlank() -> fail(WalletField.NAME, WalletFieldIssue.REQUIRED)
        name.length > MAX_WALLET_NAME_LENGTH -> fail(WalletField.NAME, WalletFieldIssue.TOO_LONG)
    }
    if (type == null && !hasProvider) fail(WalletField.TYPE, WalletFieldIssue.REQUIRED)
    when {
        initialBalance < 0 -> fail(WalletField.INITIAL_BALANCE, WalletFieldIssue.INVALID)
        initialBalance > MAX_INITIAL_BALANCE -> fail(WalletField.INITIAL_BALANCE, WalletFieldIssue.TOO_LARGE)
    }
    if (color != null && !HEX_COLOR.matches(color)) fail(WalletField.COLOR, WalletFieldIssue.INVALID)
}
