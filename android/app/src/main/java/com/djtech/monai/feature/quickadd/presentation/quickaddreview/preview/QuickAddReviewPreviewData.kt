package com.djtech.monai.feature.quickadd.presentation.quickaddreview.preview

import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.QuickAddReviewState
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewDraft
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewOutcome
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSummaryRow
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import java.time.Instant
import java.time.LocalDate

/** Sample states for the review previews, matching the design canvas. */
internal object QuickAddReviewPreviewData {
    private val today = LocalDate.of(2026, 10, 10)
    private val food = Category(
        id = "food",
        name = "Food",
        type = CategoryType.EXPENSE,
        icon = "restaurant",
        color = "#F97316",
        isDefault = true,
        isSystem = false,
        isHidden = false,
        createdAt = Instant.EPOCH,
        updatedAt = Instant.EPOCH,
    )

    val reviewing = QuickAddReviewState(
        today = today,
        phrase = "kopi 25rb sama parkir 5rb kmrn",
        total = 2,
        draft = ReviewDraft(
            type = TransactionType.EXPENSE,
            amount = 25_000,
            walletId = "bca",
            toWalletId = null,
            categoryId = "food",
            date = today.minusDays(1),
            note = "Kopi",
            highlights = mapOf(
                TransactionField.CATEGORY to FieldHighlight.Ai,
                TransactionField.WALLET to FieldHighlight.Low,
                TransactionField.DATE to FieldHighlight.Ai,
            ),
        ),
        category = food,
        walletName = "BCA Tabungan",
    )

    val done = QuickAddReviewState(
        today = today,
        phrase = "kopi 25rb sama parkir 5rb kmrn",
        total = 2,
        index = 2,
        summary = listOf(
            ReviewSummaryRow(
                outcome = ReviewOutcome.SAVED,
                type = TransactionType.EXPENSE,
                amount = 25_000,
                title = "Kopi",
                category = food,
                walletName = "BCA",
                date = today,
            ),
            ReviewSummaryRow(
                outcome = ReviewOutcome.SKIPPED,
                type = TransactionType.EXPENSE,
                amount = 5_000,
                title = "Parkir",
                category = null,
                walletName = null,
                date = today,
            ),
        ),
    )
}
