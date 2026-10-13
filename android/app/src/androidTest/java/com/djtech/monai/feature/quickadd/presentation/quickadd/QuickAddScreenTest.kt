package com.djtech.monai.feature.quickadd.presentation.quickadd

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextInput
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.ChipKind
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.EngineNote
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddChip
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddDraftRow
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import java.time.LocalDate

@RunWith(AndroidJUnit4::class)
class QuickAddScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val today = LocalDate.of(2026, 10, 10)
    private val intents = mutableListOf<QuickAddIntent>()

    private fun setContent(state: QuickAddState) {
        compose.setContent { MonAITheme(darkTheme = false) { QuickAddScreen(state, onIntent = { intents += it }) } }
    }

    private val lunch = QuickAddDraftRow(
        type = TransactionType.EXPENSE,
        amount = 35_000,
        title = "Makan siang",
        categoryName = "Food",
        categoryIcon = "restaurant",
        categoryColor = null,
        walletName = "GoPay",
        walletIsDefault = false,
        toWalletName = null,
        date = today,
    )

    @Test
    fun anEmptyInputOffersExamplesAndCannotContinue() {
        setContent(QuickAddState(today = today))

        compose.onNodeWithText("“kopi 25rb sama parkir 5rb kmrn”").performClick()
        compose.onNodeWithText("Review draft").assertIsNotEnabled()
        assertEquals(listOf<QuickAddIntent>(QuickAddIntent.PickExample("kopi 25rb sama parkir 5rb kmrn")), intents)
    }

    @Test
    fun typingSendsTheText() {
        setContent(QuickAddState(today = today))

        compose.onNodeWithContentDescription("Describe your transaction").performTextInput("kopi")

        assertEquals(listOf<QuickAddIntent>(QuickAddIntent.TextChanged("kopi")), intents)
    }

    @Test
    fun showsWhatWasUnderstoodAndReviews() {
        setContent(
            QuickAddState(
                today = today,
                text = "makan siang 35rb pakai gopay",
                chips = listOf(
                    QuickAddChip(ChipKind.AMOUNT, false, amount = 35_000),
                    QuickAddChip(ChipKind.WALLET, true),
                ),
                drafts = listOf(lunch),
                engineNote = EngineNote.OnPhone,
            ),
        )

        compose.onNodeWithText("Rp 35.000").assertIsDisplayed()
        compose.onNodeWithText("Wallet?").assertIsDisplayed()
        compose.onNodeWithText("Understood on your phone — nothing sent to AI").assertIsDisplayed()
        compose.onNodeWithText("Makan siang").assertIsDisplayed()
        compose.onNodeWithText("−Rp 35.000").assertIsDisplayed()

        compose.onNodeWithText("Review draft").performClick()
        assertEquals(listOf<QuickAddIntent>(QuickAddIntent.Submit), intents)
    }

    @Test
    fun aBusyAiShowsTheNoticeAndAMissingAmountWarns() {
        setContent(
            QuickAddState(
                today = today,
                text = "bayar arisan",
                drafts = listOf(lunch.copy(amount = null), lunch),
                showFallback = true,
                amountMissing = true,
            ),
        )

        compose.onNodeWithText("AI is busy right now").assertIsDisplayed()
        compose.onNodeWithText("Rp —").assertIsDisplayed()
        compose.onNodeWithText("We couldn't find an amount. You'll enter it on the next step.").assertIsDisplayed()
        compose.onNodeWithText("Review 2 drafts").assertIsDisplayed()
    }

    @Test
    fun closeSendsClose() {
        setContent(QuickAddState(today = today))

        compose.onNodeWithContentDescription("Close quick add").performClick()

        assertTrue(intents.single() == QuickAddIntent.Close)
    }
}
