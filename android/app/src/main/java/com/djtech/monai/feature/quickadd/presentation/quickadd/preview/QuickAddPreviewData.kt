package com.djtech.monai.feature.quickadd.presentation.quickadd.preview

import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.quickadd.presentation.quickadd.QuickAddState
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.ChipKind
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.EngineNote
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddChip
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddDraftRow
import java.time.LocalDate

/** Sample states for the Quick add previews, matching the design canvas. */
internal object QuickAddPreviewData {
    private val today = LocalDate.of(2026, 10, 10)

    val empty = QuickAddState(today = today)

    val single = QuickAddState(
        today = today,
        text = "makan siang 35rb pakai gopay",
        chips = listOf(
            QuickAddChip(ChipKind.AMOUNT, false, amount = 35_000),
            QuickAddChip(ChipKind.CATEGORY, false, name = "Food"),
            QuickAddChip(ChipKind.WALLET, false, name = "GoPay"),
            QuickAddChip(ChipKind.DATE, false, date = today),
        ),
        drafts = listOf(
            QuickAddDraftRow(
                type = TransactionType.EXPENSE,
                amount = 35_000,
                title = "Makan siang",
                categoryName = "Food",
                categoryIcon = "restaurant",
                categoryColor = "#F97316",
                walletName = "GoPay",
                walletIsDefault = false,
                toWalletName = null,
                date = today,
            ),
        ),
        engineNote = EngineNote.OnPhone,
    )

    val fallback = QuickAddState(
        today = today,
        text = "bayar laundry 45 ribu kemarin",
        chips = listOf(
            QuickAddChip(ChipKind.AMOUNT, false, amount = 45_000),
            QuickAddChip(ChipKind.CATEGORY, true, name = "Other"),
            QuickAddChip(ChipKind.WALLET, true),
            QuickAddChip(ChipKind.DATE, false, date = today.minusDays(1)),
        ),
        drafts = listOf(
            QuickAddDraftRow(
                type = TransactionType.EXPENSE,
                amount = 45_000,
                title = "Bayar laundry",
                categoryName = "Other",
                categoryIcon = "category",
                categoryColor = "#64748B",
                walletName = "BCA Tabungan",
                walletIsDefault = true,
                toWalletName = null,
                date = today.minusDays(1),
            ),
        ),
        engineNote = EngineNote.DefaultWallet("BCA Tabungan"),
        showFallback = true,
    )
}
