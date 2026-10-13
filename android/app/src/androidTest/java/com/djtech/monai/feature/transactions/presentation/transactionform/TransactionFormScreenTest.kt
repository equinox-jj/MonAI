package com.djtech.monai.feature.transactions.presentation.transactionform

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.presentation.TransactionTestData
import com.djtech.monai.feature.transactions.presentation.transactionform.model.FormSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormMode
import com.djtech.monai.feature.transactions.presentation.transactionform.model.WalletTarget
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class TransactionFormScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val intents = mutableListOf<TransactionFormIntent>()
    private val add = TransactionFormState(
        mode = TransactionFormMode.Add,
        today = TransactionTestData.today,
        amount = 35_000,
        walletId = "bca",
        categories = TransactionTestData.categories.filter { it.type == CategoryType.EXPENSE },
        wallets = TransactionTestData.wallets,
        lookups = TransactionTestData.lookups,
    )

    private fun setContent(state: TransactionFormState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { TransactionFormScreen(state, onIntent = { intents += it }) }
        }
    }

    @Test
    fun aNewExpenseShowsItsAmountChipsWalletAndDate() {
        setContent(add)

        compose.onNodeWithText("New transaction").assertIsDisplayed()
        compose.onNodeWithContentDescription("Amount, −Rp 35.000").assertIsDisplayed()
        compose.onNodeWithText("Food").assertIsDisplayed()
        compose.onNodeWithText("BCA Tabungan").assertIsDisplayed()
        compose.onNodeWithText("Today, 10 Oct").assertIsDisplayed()
        compose.onNodeWithText("Save expense").assertIsDisplayed()
    }

    @Test
    fun theKeypadAndTabsSendTheirIntents() {
        setContent(add)

        compose.onNodeWithText("7").performClick()
        compose.onNodeWithText("000").performClick()
        compose.onNodeWithContentDescription("Delete digit").performClick()
        compose.onNodeWithText("Income").performClick()
        compose.onNodeWithText("Food").performClick()

        assertEquals(
            listOf(
                TransactionFormIntent.Digit(7),
                TransactionFormIntent.TripleZero,
                TransactionFormIntent.Backspace,
                TransactionFormIntent.SelectType(TransactionType.INCOME),
                TransactionFormIntent.PickCategory("food"),
            ),
            intents,
        )
    }

    @Test
    fun aTransferPicksBothWallets() {
        setContent(add.copy(type = TransactionType.TRANSFER, toWalletId = "gopay"))

        compose.onNodeWithText("Save transfer").assertIsDisplayed()
        compose.onNodeWithText("GoPay").performClick()

        assertEquals(
            listOf<TransactionFormIntent>(TransactionFormIntent.OpenWalletPicker(WalletTarget.DESTINATION)),
            intents,
        )
    }

    @Test
    fun fieldErrorsShowUnderTheirFields() {
        setContent(
            add.copy(
                amount = 0,
                errors = mapOf(
                    TransactionField.AMOUNT to UiText.Resource(R.string.transaction_form_error_amount_required),
                    TransactionField.CATEGORY to UiText.Resource(R.string.transaction_form_error_category_required),
                ),
            ),
        )

        compose.onNodeWithText("Enter an amount.").assertIsDisplayed()
        compose.onNodeWithText("Choose a category.").assertIsDisplayed()
    }

    @Test
    fun editingShowsTheSavedAmountAndCanDelete() {
        setContent(
            add.copy(
                mode = TransactionFormMode.Edit("t1"),
                amount = 53_000,
                originalAmount = 35_000,
                categoryId = "food",
            ),
        )

        compose.onNodeWithText("Edit transaction").assertIsDisplayed()
        compose.onNodeWithText("Was Rp 35.000").assertIsDisplayed()
        compose.onNodeWithText("Save changes").performClick()
        compose.onNodeWithContentDescription("Delete transaction").performClick()

        assertEquals(listOf(TransactionFormIntent.Save, TransactionFormIntent.Delete), intents)
    }

    @Test
    fun closingWithChangesAsksFirst() {
        setContent(add.copy(showDiscardDialog = true))

        compose.onNodeWithText("Discard changes?").assertIsDisplayed()
        compose.onNodeWithText("Discard").performClick()

        assertEquals(listOf<TransactionFormIntent>(TransactionFormIntent.ConfirmDiscard), intents)
    }

    @Test
    fun theCategoryPickerOffersANewCategory() {
        setContent(add.copy(sheet = FormSheet.Category(selectedId = null)))

        compose.onNodeWithText("New").performClick()

        assertEquals(listOf<TransactionFormIntent>(TransactionFormIntent.NewCategory), intents)
    }
}
