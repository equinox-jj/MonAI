package com.djtech.monai.feature.reports.presentation.report

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollTo
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.reports.presentation.report.model.ReportBudgetCard
import com.djtech.monai.feature.reports.presentation.report.preview.ReportPreviewData
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import java.time.YearMonth

@RunWith(AndroidJUnit4::class)
class ReportScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val intents = mutableListOf<ReportIntent>()

    private fun setContent(state: ReportState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { ReportScreen(state, onIntent = { intents += it }) }
        }
    }

    @Test
    fun showsTheMonthsTotalsAndComparison() {
        setContent(ReportPreviewData.state)

        compose.onNodeWithText("October 2026").assertIsDisplayed()
        compose.onNodeWithText("+Rp 8.500.000").assertIsDisplayed()
        compose.onNodeWithText("−Rp 2.415.000").assertIsDisplayed()
        compose.onNodeWithText("+Rp 6.085.000").assertIsDisplayed()
        compose.onNodeWithText("Spent 10% less than Sep").assertIsDisplayed()
    }

    @Test
    fun listsEachCategoryWithItsShareAndChange() {
        setContent(ReportPreviewData.state)

        compose.onNodeWithText("Transport").performScrollTo().assertIsDisplayed()
        compose.onNodeWithText("Rp 420.000").assertIsDisplayed()
        compose.onNodeWithText("17% of spending").assertIsDisplayed()
        compose.onNodeWithContentDescription("11 percent more than Sep").assertIsDisplayed()
    }

    @Test
    fun theCurrentMonthCantGoForward() {
        setContent(ReportPreviewData.state)

        compose.onNodeWithContentDescription("Next month, November 2026").assertIsNotEnabled()
        compose.onNodeWithContentDescription("Previous month, September 2026").performClick()

        assertEquals(listOf<ReportIntent>(ReportIntent.PreviousMonth), intents)
    }

    @Test
    fun theBudgetCardOpensTheBudget() {
        setContent(ReportPreviewData.state)

        compose.onNodeWithText("Change").performScrollTo().performClick()

        assertEquals(listOf<ReportIntent>(ReportIntent.OpenBudget), intents)
    }

    @Test
    fun aMonthWithoutBudgetPromptsToSetOne() {
        setContent(ReportPreviewData.state.copy(budget = ReportBudgetCard.NotSet))

        compose.onNodeWithText("No budget for October").performScrollTo().performClick()

        assertEquals(listOf<ReportIntent>(ReportIntent.OpenBudget), intents)
    }

    @Test
    fun aMonthWithoutSpendingSaysSo() {
        setContent(ReportPreviewData.state.copy(categories = emptyList()))

        compose.onNodeWithText("No spending in October").assertIsDisplayed()
    }

    @Test
    fun aFailedLoadOffersToRetry() {
        setContent(
            ReportState(
                month = YearMonth.of(2026, 8),
                canGoNext = true,
                isLoading = false,
                loadError = UiText.Resource(R.string.report_load_failed_network),
            ),
        )

        compose.onNodeWithText("You're offline. Connect to the internet to load this month.").assertIsDisplayed()
        compose.onNodeWithText("Try again").performClick()

        assertEquals(listOf<ReportIntent>(ReportIntent.Retry), intents)
    }
}
