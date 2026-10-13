package com.djtech.monai.feature.quickadd.presentation.quickaddreview

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewDraft
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewOutcome
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSummaryRow
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewWalletTarget
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import java.time.LocalDate

@RunWith(AndroidJUnit4::class)
class QuickAddReviewScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val today = LocalDate.of(2026, 10, 10)
    private val intents = mutableListOf<QuickAddReviewIntent>()

    private fun setContent(state: QuickAddReviewState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { QuickAddReviewScreen(state, onIntent = { intents += it }) }
        }
    }

    private val reviewing = QuickAddReviewState(
        today = today,
        phrase = "kopi 25rb sama parkir",
        total = 2,
        draft = ReviewDraft(
            type = TransactionType.EXPENSE,
            amount = null,
            walletId = "bca",
            toWalletId = null,
            categoryId = null,
            date = today,
            note = "Parkir",
            highlights = mapOf(
                TransactionField.AMOUNT to FieldHighlight.Low,
                TransactionField.WALLET to FieldHighlight.Low,
            ),
        ),
        walletName = "BCA",
    )

    @Test
    fun showsTheDraftWithItsPlaceAndWhatToCheck() {
        setContent(reviewing)

        compose.onNodeWithText("1 of 2").assertIsDisplayed()
        compose.onNodeWithText("From “kopi 25rb sama parkir”").assertIsDisplayed()
        compose.onNodeWithText("BCA").assertIsDisplayed()
        compose.onNodeWithText("Please check this value.").assertIsDisplayed()
        compose.onNodeWithText("Save & next").assertIsDisplayed()
    }

    @Test
    fun theAmountWalletSkipAndSaveSendTheirIntents() {
        setContent(reviewing)

        compose.onNodeWithContentDescription("Change the amount, Rp —").performClick()
        compose.onNodeWithText("BCA").performClick()
        compose.onNodeWithText("Skip").performClick()
        compose.onNodeWithText("Save & next").performClick()

        assertEquals(
            listOf(
                QuickAddReviewIntent.OpenAmount,
                QuickAddReviewIntent.OpenWallet(ReviewWalletTarget.SOURCE),
                QuickAddReviewIntent.Skip,
                QuickAddReviewIntent.Save,
            ),
            intents,
        )
    }

    @Test
    fun theSummaryCountsWhatWasSaved() {
        setContent(
            QuickAddReviewState(
                today = today,
                phrase = "kopi 25rb sama parkir",
                total = 2,
                index = 2,
                summary = listOf(
                    ReviewSummaryRow(
                        outcome = ReviewOutcome.SAVED,
                        type = TransactionType.EXPENSE,
                        amount = 25_000,
                        title = "Kopi",
                        category = null,
                        walletName = "BCA",
                        date = today,
                    ),
                    ReviewSummaryRow(
                        outcome = ReviewOutcome.SKIPPED,
                        type = TransactionType.EXPENSE,
                        amount = null,
                        title = "Parkir",
                        category = null,
                        walletName = null,
                        date = today,
                    ),
                ),
            ),
        )

        compose.onNodeWithText("1 transaction saved").assertIsDisplayed()
        compose.onNodeWithText("Saved · BCA · Today").assertIsDisplayed()
        compose.onNodeWithText("Skipped").assertIsDisplayed()

        compose.onNodeWithText("Back to home").performClick()
        assertEquals(listOf<QuickAddReviewIntent>(QuickAddReviewIntent.Finish), intents)
    }
}
