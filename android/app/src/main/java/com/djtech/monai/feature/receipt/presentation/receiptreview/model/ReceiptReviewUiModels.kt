package com.djtech.monai.feature.receipt.presentation.receiptreview.model

import androidx.compose.runtime.Immutable
import java.time.LocalDate
import java.time.YearMonth

/** An open picker; its choice applies on confirm. */
@Immutable
sealed interface ReceiptSheet {
    data class Amount(val amount: Long) : ReceiptSheet

    data class Category(val selectedId: String?) : ReceiptSheet

    data class Wallet(val selectedId: String?) : ReceiptSheet

    data class Date(val selected: LocalDate, val shownMonth: YearMonth) : ReceiptSheet
}
