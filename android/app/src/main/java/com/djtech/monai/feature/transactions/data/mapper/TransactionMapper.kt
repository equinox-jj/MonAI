package com.djtech.monai.feature.transactions.data.mapper

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.transactions.data.dto.TransactionDto
import com.djtech.monai.feature.transactions.domain.model.TransactionError
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

// Reads only fail offline or unexpectedly; write error codes are mapped once transactions can be edited.
fun ApiError.toTransactionError(): TransactionError = when (this) {
    ApiError.Network -> TransactionError.Network
    is ApiError.Http, is ApiError.Unknown -> TransactionError.Unexpected
}
