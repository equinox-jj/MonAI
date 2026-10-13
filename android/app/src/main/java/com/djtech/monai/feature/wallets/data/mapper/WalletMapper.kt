package com.djtech.monai.feature.wallets.data.mapper

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.FieldError
import com.djtech.monai.feature.wallets.data.dto.CreateWalletRequestDto
import com.djtech.monai.feature.wallets.data.dto.UpdateWalletRequestDto
import com.djtech.monai.feature.wallets.data.dto.WalletDto
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import java.time.Instant

fun WalletDto.asModel(): Wallet = Wallet(
    id = id,
    providerId = providerId,
    name = name,
    type = type,
    logoUrl = logoUrl,
    initialBalance = initialBalance,
    currentBalance = currentBalance,
    icon = icon,
    color = color,
    isDefault = isDefault,
    isArchived = isArchived,
    createdAt = Instant.parse(createdAt),
    updatedAt = Instant.parse(updatedAt),
)

// The use case resolves a seed provider's slug to its id before this; the slug is never sent.
fun WalletInput.toCreateRequest() = CreateWalletRequestDto(
    providerId = providerId,
    name = name,
    type = type,
    initialBalance = initialBalance,
    color = color,
    isDefault = isDefault,
)

fun WalletChanges.toUpdateRequest() = UpdateWalletRequestDto(
    name = name,
    type = type,
    initialBalance = initialBalance,
    color = color,
    isDefault = isDefault,
    isArchived = isArchived,
)

/**
 * Branches on the backend's stable error codes, never on the message. The API answers a taken name
 * and two concurrent default changes both with a bare `conflict`, so [nameSent] tells them apart:
 * a conflict counts as a taken name only when the request carried one.
 */
fun ApiError.toWalletError(nameSent: Boolean = false): WalletError = when (this) {
    ApiError.Network -> WalletError.Network
    is ApiError.Unknown -> WalletError.Unexpected
    is ApiError.Http -> when (code) {
        "not_found" -> WalletError.NotFound
        "wallet_has_transactions" -> WalletError.HasTransactions
        "default_wallet_required" -> WalletError.DefaultRequired
        "validation_failed" -> fields.toInvalidFields() ?: WalletError.Unexpected
        "conflict" -> fields.toInvalidFields()
            ?: if (nameSent) WalletError.InvalidFields(listOf(NAME_TAKEN)) else WalletError.Unexpected

        else -> WalletError.Unexpected
    }
}

private val NAME_TAKEN = WalletFieldError(WalletField.NAME, WalletFieldIssue.ALREADY_EXISTS)

// Fields the form doesn't show (provider_id) are dropped; with nothing left the error is unexpected.
private fun List<FieldError>.toInvalidFields(): WalletError.InvalidFields? =
    mapNotNull { error -> API_FIELDS[error.field]?.let { WalletFieldError(it, error.toFieldIssue(it)) } }
        .takeIf { it.isNotEmpty() }
        ?.let(WalletError::InvalidFields)

private fun FieldError.toFieldIssue(field: WalletField): WalletFieldIssue = when (code) {
    "required" -> WalletFieldIssue.REQUIRED
    "max_length" -> WalletFieldIssue.TOO_LONG
    "max" -> if (field == WalletField.NAME) WalletFieldIssue.TOO_LONG else WalletFieldIssue.TOO_LARGE
    "already_exists" -> WalletFieldIssue.ALREADY_EXISTS
    else -> WalletFieldIssue.INVALID
}

private val API_FIELDS = mapOf(
    "name" to WalletField.NAME,
    "type" to WalletField.TYPE,
    "initial_balance" to WalletField.INITIAL_BALANCE,
    "color" to WalletField.COLOR,
)
