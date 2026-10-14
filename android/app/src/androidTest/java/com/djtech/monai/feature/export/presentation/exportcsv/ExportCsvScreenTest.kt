package com.djtech.monai.feature.export.presentation.exportcsv

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsEnabled
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onAllNodesWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.export.domain.model.CsvDelimiter
import com.djtech.monai.feature.export.domain.model.ExportRange
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import java.time.YearMonth

@RunWith(AndroidJUnit4::class)
class ExportCsvScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val october = YearMonth.of(2026, 10)
    private val intents = mutableListOf<ExportCsvIntent>()

    private fun setContent(state: ExportCsvState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { ExportCsvScreen(state, onIntent = { intents += it }) }
        }
    }

    private fun state(from: YearMonth = october, to: YearMonth = october) =
        ExportCsvState(range = ExportRange(from, to), currentMonth = october)

    @Test
    fun showsBothMonthsAndOnlyLetsTheEndsMoveUpToThisMonth() {
        setContent(state(from = october.minusMonths(2)))

        compose.onNodeWithText("August 2026").assertIsDisplayed()
        compose.onNodeWithText("October 2026").assertIsDisplayed()
        val next = compose.onAllNodesWithContentDescription("Next month")
        next[0].assertIsEnabled()
        next[1].assertIsNotEnabled()
    }

    @Test
    fun steppersMoveTheirEnd() {
        setContent(state())

        val previous = compose.onAllNodesWithContentDescription("Previous month")
        previous[0].performClick()
        previous[1].performClick()

        assertEquals(listOf(ExportCsvIntent.MoveFrom(-1), ExportCsvIntent.MoveTo(-1)), intents)
    }

    @Test
    fun picksTheDelimiter() {
        setContent(state())

        compose.onNodeWithText("Semicolon ( ; )").performClick()

        assertEquals(listOf(ExportCsvIntent.PickDelimiter(CsvDelimiter.SEMICOLON)), intents)
    }

    @Test
    fun showsWhyTheLastExportFailed() {
        setContent(state().copy(error = UiText.Resource(R.string.export_error_empty)))

        compose.onNodeWithText("No transactions in these months.").assertIsDisplayed()
    }

    @Test
    fun steppersAreDisabledWhileExporting() {
        setContent(state(from = october.minusMonths(1)).copy(isExporting = true))

        compose.onAllNodesWithContentDescription("Previous month")[0].assertIsNotEnabled()
        compose.onAllNodesWithContentDescription("Next month")[0].assertIsNotEnabled()
    }
}
