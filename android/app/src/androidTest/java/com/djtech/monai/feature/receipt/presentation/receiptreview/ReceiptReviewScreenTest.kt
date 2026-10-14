package com.djtech.monai.feature.receipt.presentation.receiptreview

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollTo
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.ReceiptItem
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import java.time.LocalDate

@RunWith(AndroidJUnit4::class)
class ReceiptReviewScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val today = LocalDate.of(2026, 10, 10)
    private val intents = mutableListOf<ReceiptReviewIntent>()

    private fun setContent(state: ReceiptReviewState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { ReceiptReviewScreen(state, onIntent = { intents += it }) }
        }
    }

    private val filled = ReceiptReviewState(
        today = today,
        photoUri = "",
        amount = 187_500,
        merchant = "Toko Sumber Rejeki",
        merchantFromAi = true,
        walletName = "BCA",
        date = LocalDate.of(2026, 10, 9),
        items = listOf(ReceiptItem("Beras 5 kg", 1.0, 74_000), ReceiptItem("Telur 1 kg", 1.0, 29_000)),
        highlights = mapOf(TransactionField.DATE to FieldHighlight.Low),
    )

    @Test
    fun showsTheReceiptsFieldsAndItems() {
        setContent(filled)

        compose.onNodeWithText("We filled the marked fields from your receipt. Check them before saving.")
            .assertIsDisplayed()
        compose.onNodeWithText("187.500").assertIsDisplayed()
        compose.onNodeWithText("Toko Sumber Rejeki").assertIsDisplayed()
        compose.onNodeWithText("Please check this value.").performScrollTo().assertIsDisplayed()
        compose.onNodeWithText("2 items found").performScrollTo().assertIsDisplayed()
        compose.onNodeWithText("Beras 5 kg").performScrollTo().assertIsDisplayed()
    }

    @Test
    fun typeRetakeAndSaveSendTheirIntents() {
        setContent(filled)

        compose.onNodeWithText("Income").performClick()
        compose.onNodeWithText("Retake").performClick()
        compose.onNodeWithText("Save expense").performClick()

        assertEquals(
            listOf(
                ReceiptReviewIntent.SelectType(TransactionType.INCOME),
                ReceiptReviewIntent.Retake,
                ReceiptReviewIntent.Save,
            ),
            intents,
        )
    }

    @Test
    fun afterAnAiFailureItSaysToFillItIn() {
        setContent(ReceiptReviewState(today = today, photoUri = "", aiFailed = true))

        compose.onNodeWithText("AI couldn't read this receipt right now. Fill in the details — your photo is kept.")
            .assertIsDisplayed()
    }

    @Test
    fun theSaveButtonShowsUploadProgress() {
        setContent(filled.copy(isSaving = true, uploadProgress = 0.42f))

        compose.onNodeWithText("Uploading photo… 42%").assertIsDisplayed()
    }
}
