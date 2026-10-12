package com.djtech.monai.feature.transactions.presentation.transactions

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.paging.LoadState
import androidx.paging.LoadStates
import androidx.paging.PagingData
import androidx.paging.compose.collectAsLazyPagingItems
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.component.MonAIWidthClass
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.presentation.TransactionTestData
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheetKind
import com.djtech.monai.feature.transactions.presentation.common.model.MonthTotals
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionListItem
import kotlinx.coroutines.flow.flowOf
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class TransactionsScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val lunch = TransactionTestData.transaction("lunch", "Makan siang")
    private val bus = TransactionTestData.transaction(
        "bus",
        "Ojek ke kantor",
        date = TransactionTestData.today.minusDays(1),
        amount = 28_000,
        categoryId = "transport",
    )
    private val items = listOf(
        TransactionListItem.Day(lunch.date),
        TransactionListItem.Entry(lunch),
        TransactionListItem.Day(bus.date),
        TransactionListItem.Entry(bus),
    )
    private val baseState = TransactionsState(
        month = TransactionTestData.october,
        currentMonth = TransactionTestData.october,
        today = TransactionTestData.today,
        zone = TransactionTestData.zone,
        lookups = TransactionTestData.lookups,
        wallets = TransactionTestData.wallets,
        categories = TransactionTestData.categories,
        totals = MonthTotals(income = 8_500_000, expense = 2_415_000),
        dailyNets = mapOf(lunch.date to -35_000L),
    )
    private var state by mutableStateOf(baseState)
    private val intents = mutableListOf<TransactionsIntent>()

    // Every page loaded, as when the month is fully cached.
    private val complete = LoadStates(
        refresh = LoadState.NotLoading(endOfPaginationReached = true),
        prepend = LoadState.NotLoading(endOfPaginationReached = true),
        append = LoadState.NotLoading(endOfPaginationReached = true),
    )

    private fun setContent(
        rows: List<TransactionListItem> = items,
        widthClass: MonAIWidthClass = MonAIWidthClass.Compact,
    ) {
        compose.setContent {
            val paged = remember { flowOf(PagingData.from(rows, complete)) }.collectAsLazyPagingItems()
            MonAITheme(darkTheme = false) {
                TransactionsScreen(state, paged, onIntent = { intents += it }, widthClass = widthClass)
            }
        }
    }

    @Test
    fun showsTheMonthItsTotalsAndItsDays() {
        setContent()

        compose.onNodeWithText("October 2026").assertIsDisplayed()
        compose.onNodeWithText("+Rp 8.500.000").assertIsDisplayed()
        compose.onNodeWithText("−Rp 2.415.000").assertIsDisplayed()
        compose.onNodeWithText("Today · Sat, 10 Oct").assertIsDisplayed()
        compose.onNodeWithText("Yesterday · Fri, 9 Oct").assertIsDisplayed()
        compose.onNodeWithText("Makan siang").assertIsDisplayed()
        compose.onNodeWithText("Food · GoPay · 12:40").assertIsDisplayed()
        compose.onNodeWithText("Ojek ke kantor").assertIsDisplayed()
    }

    @Test
    fun theNextMonthIsDisabledOnTheCurrentMonth() {
        setContent()

        compose.onNodeWithContentDescription("Next month").assertIsNotEnabled()
        compose.onNodeWithContentDescription("Previous month").performClick()

        assertEquals(listOf<TransactionsIntent>(TransactionsIntent.PreviousMonth), intents)
    }

    @Test
    fun searchAndRowsOpenTheirScreens() {
        setContent()

        compose.onNodeWithText("Search note or merchant").performClick()
        compose.onNodeWithText("Makan siang").performClick()

        assertEquals(
            listOf(
                TransactionsIntent.Open(TransactionsDestination.Search(TransactionTestData.october)),
                TransactionsIntent.Open(TransactionsDestination.Detail("lunch")),
            ),
            intents,
        )
    }

    @Test
    fun onAWideScreenARowIsSelectedForTheDetailPane() {
        setContent(widthClass = MonAIWidthClass.Expanded)

        // Two panes are wider than a phone, so the detail pane is laid out off screen.
        compose.onNodeWithText("Pick a transaction").assertExists()
        compose.onNodeWithText("Makan siang").performClick()

        assertEquals(listOf<TransactionsIntent>(TransactionsIntent.Select("lunch")), intents)
    }

    @Test
    fun anEmptyCurrentMonthInvitesTheFirstTransaction() {
        setContent(rows = emptyList())

        compose.onNodeWithText("No transactions yet").assertIsDisplayed()
        compose.onNodeWithText("Add transaction").performClick()

        assertEquals(listOf<TransactionsIntent>(TransactionsIntent.Open(TransactionsDestination.Add)), intents)
    }

    @Test
    fun aFilteredEmptyMonthOffersToClearTheFilters() {
        state = baseState.copy(filter = TransactionFilter(walletId = "bca"))
        setContent(rows = emptyList())

        compose.onNodeWithText("No matches").assertIsDisplayed()
        compose.onNodeWithText("Clear filters").performClick()

        assertEquals(listOf<TransactionsIntent>(TransactionsIntent.Filter(FilterIntent.RemoveAll)), intents)
    }

    @Test
    fun anActiveFilterShowsItsValueAndCanBeRemoved() {
        state = baseState.copy(filter = TransactionFilter(walletId = "bca"))
        setContent()

        compose.onNodeWithText("BCA Tabungan").assertIsDisplayed()
        compose.onNodeWithContentDescription("Clear filter Wallet").performClick()

        assertEquals(
            listOf<TransactionsIntent>(TransactionsIntent.Filter(FilterIntent.Remove(FilterSheetKind.WALLET))),
            intents,
        )
    }

    @Test
    fun theWalletSheetPicksOneWalletAndApplies() {
        setContent()
        compose.onNodeWithText("Wallet").performClick()
        assertEquals(
            TransactionsIntent.Filter(FilterIntent.Open(FilterSheetKind.WALLET)),
            intents.last(),
        )

        state = baseState.copy(sheet = FilterSheet.Wallet(selectedId = null))
        compose.onNodeWithText("Show all").assertIsDisplayed()
        compose.onNodeWithText("GoPay").performClick()
        state = baseState.copy(sheet = FilterSheet.Wallet(selectedId = "gopay"))
        compose.onNodeWithText("Apply").performClick()

        assertTrue(intents.contains(TransactionsIntent.Filter(FilterIntent.PickWallet("gopay"))))
        assertEquals(TransactionsIntent.Filter(FilterIntent.Apply), intents.last())
    }
}
