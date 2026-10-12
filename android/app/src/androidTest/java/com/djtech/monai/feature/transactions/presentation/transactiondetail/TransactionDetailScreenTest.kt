package com.djtech.monai.feature.transactions.presentation.transactiondetail

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.presentation.TransactionTestData
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class TransactionDetailScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val intents = mutableListOf<TransactionDetailIntent>()

    private fun setContent(state: TransactionDetailState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { TransactionDetailScreen(state, onIntent = { intents += it }) }
        }
    }

    private fun state(transaction: Transaction?) = TransactionDetailState(
        today = TransactionTestData.today,
        transaction = transaction,
        lookups = TransactionTestData.lookups,
        isLoading = false,
    )

    @Test
    fun showsTheAmountAndEveryField() {
        setContent(
            state(
                TransactionTestData.transaction(
                    "t1",
                    note = "Belanja bulanan",
                    amount = 187_500,
                    walletId = "bca",
                    merchant = "Toko Sumber Rejeki",
                    source = TransactionSource.RECEIPT,
                ),
            ),
        )

        compose.onNodeWithText("−Rp 187.500").assertIsDisplayed()
        compose.onNodeWithText("Food").assertIsDisplayed()
        compose.onNodeWithText("BCA Tabungan").assertIsDisplayed()
        compose.onNodeWithText("Today, 10 Oct").assertIsDisplayed()
        compose.onNodeWithText("Toko Sumber Rejeki").assertIsDisplayed()
        compose.onNodeWithText("Receipt scan").assertIsDisplayed()
    }

    @Test
    fun aTransferShowsBothWallets() {
        setContent(
            state(
                TransactionTestData.transaction(
                    "t2",
                    note = "Top up",
                    type = TransactionType.TRANSFER,
                    walletId = "bca",
                    toWalletId = "gopay",
                    categoryId = null,
                ),
            ),
        )

        compose.onNodeWithText("From").assertIsDisplayed()
        compose.onNodeWithText("To").assertIsDisplayed()
        compose.onNodeWithText("GoPay").assertIsDisplayed()
    }

    @Test
    fun editDeleteAndTheReceiptSendTheirIntents() {
        setContent(state(TransactionTestData.transaction("t1", "Lunch", receiptUrl = "https://example.com/r.jpg")))

        compose.onNodeWithContentDescription("Edit transaction").performClick()
        compose.onNodeWithContentDescription("Delete transaction").performClick()
        compose.onNodeWithText("View").performClick()

        assertEquals(
            listOf(
                TransactionDetailIntent.Edit,
                TransactionDetailIntent.Delete,
                TransactionDetailIntent.OpenReceipt,
            ),
            intents,
        )
    }

    @Test
    fun aFailedLoadOffersARetry() {
        setContent(state(null).copy(loadError = UiText.Resource(R.string.transaction_error_not_found)))

        compose.onNodeWithText("This transaction no longer exists.").assertIsDisplayed()
        compose.onNodeWithText("Try again").performClick()

        assertEquals(listOf<TransactionDetailIntent>(TransactionDetailIntent.Retry), intents)
    }
}
