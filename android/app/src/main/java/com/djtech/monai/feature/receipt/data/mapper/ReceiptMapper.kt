package com.djtech.monai.feature.receipt.data.mapper

import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.model.ReceiptItem
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.model.asModel
import com.djtech.monai.feature.receipt.data.dto.ReceiptDraftDto
import com.djtech.monai.feature.receipt.data.dto.ReceiptItemDto
import com.djtech.monai.feature.receipt.domain.model.ReceiptError
import java.time.LocalDate

fun ReceiptDraftDto.asModel(): ReceiptDraft = ReceiptDraft(
    draft = TransactionDraft(
        type = type,
        amount = amount,
        walletId = walletId,
        toWalletId = toWalletId,
        categoryId = categoryId,
        date = date?.let(LocalDate::parse),
        note = note,
        merchant = merchant,
        confidence = confidence.asModel(),
    ),
    items = items.map(ReceiptItemDto::asModel),
)

fun ReceiptItemDto.asModel(): ReceiptItem = ReceiptItem(name = name, quantity = quantity, amount = amount)

// Branches on the backend's stable error codes, never on the message.
fun ApiError.toReceiptError(): ReceiptError = when (this) {
    ApiError.Network -> ReceiptError.Network
    is ApiError.Unknown -> ReceiptError.Unexpected
    is ApiError.Http -> when (code) {
        "rate_limited" -> ReceiptError.RateLimited
        "ai_unavailable" -> ReceiptError.AiUnavailable
        else -> ReceiptError.Unexpected
    }
}
