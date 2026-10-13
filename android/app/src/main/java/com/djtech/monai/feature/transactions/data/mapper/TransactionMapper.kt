package com.djtech.monai.feature.transactions.data.mapper

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.FieldError
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.transactions.data.dto.CreateTransactionRequestDto
import com.djtech.monai.feature.transactions.data.dto.TransactionDto
import com.djtech.monai.feature.transactions.data.dto.UpdateTransactionRequestDto
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import java.time.Instant
import java.time.LocalDate

fun TransactionDto.asModel(): Transaction = Transaction(
    id = id,
    type = type,
    amount = amount,
    walletId = walletId,
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = LocalDate.parse(date),
    note = note,
    merchant = merchant,
    receiptUrl = receiptUrl,
    source = source,
    createdAt = Instant.parse(createdAt),
    updatedAt = Instant.parse(updatedAt),
)

// The use cases validate input before it gets here, so a missing wallet is a bug.
fun TransactionInput.toCreateRequest() = CreateTransactionRequestDto(
    type = type,
    amount = amount,
    walletId = checkNotNull(walletId) { "walletId is validated by the use case" },
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = date.toString(),
    note = note,
    merchant = merchant,
    source = source,
    receiptKey = receiptKey,
)

fun TransactionInput.toUpdateRequest() = UpdateTransactionRequestDto(
    type = type,
    amount = amount,
    walletId = checkNotNull(walletId) { "walletId is validated by the use case" },
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = date.toString(),
    note = note,
    merchant = merchant,
)

// NetworkJson leaves nulls out, but a PATCH needs them sent: a missing key keeps the old value.
private val ExplicitNullsJson = Json(from = NetworkJson) { explicitNulls = true }
private val JsonMediaType = "application/json".toMediaType()

fun UpdateTransactionRequestDto.toRequestBody(): RequestBody =
    ExplicitNullsJson.encodeToString(UpdateTransactionRequestDto.serializer(), this).toRequestBody(JsonMediaType)

// Branches on the backend's stable error codes, never on the message.
fun ApiError.toTransactionError(): TransactionError = when (this) {
    ApiError.Network -> TransactionError.Network
    is ApiError.Unknown -> TransactionError.Unexpected
    is ApiError.Http -> when (code) {
        "not_found" -> TransactionError.NotFound
        "wallet_archived" -> TransactionError.WalletArchived
        "rate_limited" -> TransactionError.RateLimited(retryAfter)
        "validation_failed" -> fields.toPhotoError() ?: fields
            .mapNotNull { field -> API_FIELDS[field.field]?.let { TransactionFieldError(it, field.toFieldIssue()) } }
            .takeIf { it.isNotEmpty() }
            ?.let(TransactionError::InvalidFields)
            ?: TransactionError.Unexpected

        else -> TransactionError.Unexpected
    }
}

// A receipt upload reports its problems on the `file` field.
private fun List<FieldError>.toPhotoError(): TransactionError? = firstOrNull { it.field == "file" }?.let {
    if (it.code == "max_size") TransactionError.PhotoTooLarge else TransactionError.PhotoUnsupported
}

private fun FieldError.toFieldIssue(): TransactionFieldIssue = when (code) {
    // An amount of 0 fails `min`; the form treats it like a missing amount.
    "required", "min" -> TransactionFieldIssue.REQUIRED
    "max", "max_length" -> TransactionFieldIssue.TOO_LARGE
    "future_date" -> TransactionFieldIssue.FUTURE_DATE
    "not_equal" -> TransactionFieldIssue.SAME_WALLET
    "type_mismatch" -> TransactionFieldIssue.TYPE_MISMATCH
    "archived" -> TransactionFieldIssue.ARCHIVED
    "not_found" -> TransactionFieldIssue.NOT_FOUND
    else -> TransactionFieldIssue.INVALID
}

private val API_FIELDS = mapOf(
    "amount" to TransactionField.AMOUNT,
    "wallet_id" to TransactionField.WALLET,
    "to_wallet_id" to TransactionField.TO_WALLET,
    "category_id" to TransactionField.CATEGORY,
    "date" to TransactionField.DATE,
    "note" to TransactionField.NOTE,
)
