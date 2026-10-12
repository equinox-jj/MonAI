package com.djtech.monai.feature.transactions.presentation.search

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextInput
import androidx.paging.LoadState
import androidx.paging.LoadStates
import androidx.paging.PagingData
import androidx.paging.compose.collectAsLazyPagingItems
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.presentation.TransactionTestData
import kotlinx.coroutines.flow.flowOf
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class SearchScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val baseState = SearchState(
        month = TransactionTestData.october,
        currentMonth = TransactionTestData.october,
        today = TransactionTestData.today,
        zone = TransactionTestData.zone,
        lookups = TransactionTestData.lookups,
        recentSearches = listOf("parkir", "listrik"),
    )
    private var state by mutableStateOf(baseState)
    private val intents = mutableListOf<SearchIntent>()

    // Every page loaded, so the count is exact.
    private val complete = LoadStates(
        refresh = LoadState.NotLoading(endOfPaginationReached = true),
        prepend = LoadState.NotLoading(endOfPaginationReached = true),
        append = LoadState.NotLoading(endOfPaginationReached = true),
    )

    private fun setContent(results: List<Transaction> = emptyList()) {
        compose.setContent {
            val paged = remember { flowOf(PagingData.from(results, complete)) }.collectAsLazyPagingItems()
            MonAITheme(darkTheme = false) { SearchScreen(state, paged, onIntent = { intents += it }) }
        }
    }

    @Test
    fun recentSearchesShowBeforeTyping() {
        setContent()

        compose.onNodeWithText("Recent searches").assertIsDisplayed()
        compose.onNodeWithText("parkir").performClick()

        assertEquals(listOf<SearchIntent>(SearchIntent.UseRecent("parkir")), intents)
    }

    @Test
    fun typingSendsTheText() {
        setContent()

        compose.onNodeWithText("Search note or merchant").performTextInput("kopi")

        assertTrue(intents.contains(SearchIntent.QueryChanged("kopi")))
    }

    @Test
    fun resultsShowTheirCountAndOpen() {
        state = baseState.copy(query = "kopi")
        setContent(
            listOf(
                TransactionTestData.transaction("a", "Kopi susu", amount = 25_000),
                TransactionTestData.transaction("b", "Kopi pagi", amount = 18_000),
            ),
        )

        compose.onNodeWithText("2 results").assertIsDisplayed()
        compose.onNodeWithText("−Rp 43.000").assertIsDisplayed()
        compose.onNodeWithText("Kopi susu").performClick()
        compose.onNodeWithText("Search all months").performClick()

        assertEquals(listOf(SearchIntent.OpenResult("a"), SearchIntent.SearchAllMonths), intents)
    }

    @Test
    fun noResultsOfferToSearchEveryMonth() {
        state = baseState.copy(query = "kopi")
        setContent()

        compose.onNodeWithText("No results for “kopi”").assertIsDisplayed()
        compose.onNodeWithText("Search all months").performClick()

        assertEquals(listOf<SearchIntent>(SearchIntent.SearchAllMonths), intents)
    }
}
