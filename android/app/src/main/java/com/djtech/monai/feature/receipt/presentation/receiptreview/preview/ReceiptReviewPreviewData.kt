package com.djtech.monai.feature.receipt.presentation.receiptreview.preview

import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.ReceiptItem
import com.djtech.monai.feature.receipt.presentation.receiptreview.ReceiptReviewState
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import java.time.Instant
import java.time.LocalDate

/** Sample states for the receipt review previews, matching the design canvas. */
internal object ReceiptReviewPreviewData {
    private val today = LocalDate.of(2026, 10, 10)

    val filled = ReceiptReviewState(
        today = today,
        photoUri = "",
        amount = 187_500,
        merchant = "Toko Sumber Rejeki",
        merchantFromAi = true,
        note = "Belanja bulanan",
        category = Category(
            id = "shopping",
            name = "Shopping",
            type = CategoryType.EXPENSE,
            icon = "shopping_bag",
            color = "#EC4899",
            isDefault = true,
            isSystem = false,
            isHidden = false,
            createdAt = Instant.EPOCH,
            updatedAt = Instant.EPOCH,
        ),
        walletName = "BCA",
        date = today.minusDays(1),
        items = listOf(
            ReceiptItem("Beras 5 kg", 1.0, 74_000),
            ReceiptItem("Minyak goreng 2 L", 1.0, 38_500),
            ReceiptItem("Telur 1 kg", 1.0, 29_000),
            ReceiptItem("Sabun cuci", 1.0, 46_000),
        ),
        highlights = mapOf(
            TransactionField.AMOUNT to FieldHighlight.Ai,
            TransactionField.CATEGORY to FieldHighlight.Ai,
            TransactionField.DATE to FieldHighlight.Low,
        ),
    )

    val aiFailed = ReceiptReviewState(today = today, photoUri = "", aiFailed = true)
}
