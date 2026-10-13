package com.djtech.monai.feature.budgets.presentation.budget

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextReplacement
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.budgets.presentation.budget.preview.BudgetPreviewData
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class BudgetScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val intents = mutableListOf<BudgetIntent>()

    private fun setContent(state: BudgetState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { BudgetScreen(state, onIntent = { intents += it }) }
        }
    }

    @Test
    fun showsTheLimitAndPreviewsItAgainstThisMonthsSpending() {
        setContent(BudgetPreviewData.state)

        compose.onNodeWithText("October budget").assertIsDisplayed()
        compose.onNodeWithText("3.000.000").assertIsDisplayed()
        compose.onNodeWithText("Rp 2.415.000 spent").assertIsDisplayed()
        compose.onNodeWithText("80%").assertIsDisplayed()
        compose.onNodeWithText("Rp 585.000 left").assertIsDisplayed()
    }

    @Test
    fun typingSendsTheLimitInRupiah() {
        setContent(BudgetPreviewData.empty)

        compose.onNodeWithContentDescription("Monthly limit in rupiah").performTextReplacement("2500000")

        assertEquals(listOf<BudgetIntent>(BudgetIntent.LimitChanged(2_500_000)), intents)
    }

    @Test
    fun aPresetSendsItsLimit() {
        setContent(BudgetPreviewData.empty)

        compose.onNodeWithText("2,5 jt").performClick()

        assertEquals(listOf<BudgetIntent>(BudgetIntent.PickPreset(2_500_000)), intents)
    }

    @Test
    fun anEmptyLimitCantBeSavedAndHasNoRemove() {
        setContent(BudgetPreviewData.empty)

        compose.onNodeWithText("Save budget").assertIsNotEnabled()
        compose.onNodeWithText("Remove budget for October").assertDoesNotExist()
    }

    @Test
    fun saveAndRemoveSendTheirIntents() {
        setContent(BudgetPreviewData.state)

        compose.onNodeWithText("Save budget").performClick()
        compose.onNodeWithText("Remove budget for October").performClick()

        assertEquals(listOf(BudgetIntent.Save, BudgetIntent.Delete), intents)
    }

    @Test
    fun removingAsksFirst() {
        setContent(BudgetPreviewData.state.copy(isConfirmingDelete = true))

        compose.onNodeWithText("Remove the October budget?").assertIsDisplayed()
        compose.onNodeWithText("Remove").performClick()

        assertEquals(listOf<BudgetIntent>(BudgetIntent.ConfirmDelete), intents)
    }

    @Test
    fun aRefusedLimitIsShownUnderTheField() {
        setContent(BudgetPreviewData.state.copy(limitError = UiText.Resource(R.string.budget_error_invalid_limit)))

        compose.onNodeWithText("Enter a limit between Rp 1 and Rp 999.999.999.999.").assertIsDisplayed()
    }
}
