package com.djtech.monai.feature.home.presentation.home

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.SemanticsNodeInteraction
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollToNode
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.home.presentation.home.model.BudgetCard
import com.djtech.monai.feature.home.presentation.home.model.Greeting
import com.djtech.monai.feature.home.presentation.home.model.MonthSummary
import com.djtech.monai.feature.home.presentation.home.model.RecentTransaction
import com.djtech.monai.feature.home.presentation.home.model.SpendingSlice
import com.djtech.monai.feature.home.presentation.home.model.TransactionDay
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import java.time.Instant
import java.time.LocalDate
import java.time.LocalTime
import java.time.YearMonth

@RunWith(AndroidJUnit4::class)
class HomeScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private var state by mutableStateOf(HomeState(month = OCTOBER))
    private val intents = mutableListOf<HomeIntent>()

    private fun setContent(initial: HomeState = dashboard()) {
        state = initial
        compose.setContent {
            MonAITheme(darkTheme = false) { HomeScreen(state, onIntent = { intents += it }) }
        }
    }

    // Lazy sections below the fold (and wallet cards off to the side) aren't composed until scrolled to.
    private fun scrollTo(text: String, list: String = HomeTestTags.LIST): SemanticsNodeInteraction {
        compose.onNodeWithTag(list).performScrollToNode(hasText(text))
        return compose.onNodeWithText(text)
    }

    @Test
    fun showsTheGreetingAndName() {
        setContent()

        compose.onNodeWithText("Good evening,").assertIsDisplayed()
        compose.onNodeWithText("Joshua Putra").assertIsDisplayed()
        compose.onNodeWithText("JP").assertIsDisplayed()
    }

    @Test
    fun showsTheTotalBalanceAndTheMonthsTotals() {
        setContent()

        compose.onNodeWithText("Total balance · 2 wallets").assertIsDisplayed()
        compose.onNodeWithText("Rp 9.435.000").assertIsDisplayed()
        compose.onNodeWithText("Income · Oct").assertIsDisplayed()
        compose.onNodeWithText("+Rp 8,5 jt").assertIsDisplayed()
        compose.onNodeWithText("−Rp 2,4 jt").assertIsDisplayed()
        compose.onNodeWithText("10% less spent than September").assertIsDisplayed()
    }

    @Test
    fun hidingTheBalanceMasksEveryAmountOnTheCards() {
        setContent()

        compose.onNodeWithContentDescription("Hide balance").performClick()
        assertEquals(listOf(HomeIntent.ToggleBalanceVisibility), intents)

        state = state.copy(isBalanceHidden = true)
        compose.onNodeWithText("Rp 9.435.000").assertDoesNotExist()
        compose.onNodeWithContentDescription("Balance hidden, show balance").assertIsDisplayed()
        scrollTo("BCA Tabungan")
        compose.onNodeWithText("Rp 8.250.000").assertDoesNotExist()
    }

    @Test
    fun headerButtonsOpenSearchAndSettings() {
        setContent()

        compose.onNodeWithContentDescription("Search transactions").performClick()
        compose.onNodeWithContentDescription("Profile and settings").performClick()

        assertEquals(
            listOf(HomeIntent.Open(HomeDestination.Search), HomeIntent.Open(HomeDestination.Settings)),
            intents,
        )
    }

    @Test
    fun quickAddAndScanOpenTheirScreens() {
        setContent()

        compose.onNodeWithText("makan siang 35rb pakai gopay").performClick()
        compose.onNodeWithContentDescription("Scan receipt").performClick()

        assertEquals(
            listOf(HomeIntent.Open(HomeDestination.QuickAdd), HomeIntent.Open(HomeDestination.ScanReceipt)),
            intents,
        )
    }

    @Test
    fun walletCardsOpenTheWallet() {
        setContent()

        scrollTo("BCA Tabungan")
        compose.onNodeWithText("Default").assertIsDisplayed()
        scrollTo("GoPay", list = HomeTestTags.WALLETS).performClick()
        compose.onNodeWithText("E-wallet · balance").assertIsDisplayed()

        assertEquals(listOf(HomeIntent.Open(HomeDestination.WalletDetail("gopay"))), intents)
    }

    @Test
    fun showsTheBudgetProgress() {
        setContent()

        scrollTo("October budget").assertIsDisplayed()
        compose.onNodeWithText("21 days left").assertIsDisplayed()
        compose.onNodeWithText("80%").assertIsDisplayed()
        compose.onNodeWithText("Rp 2.415.000 of Rp 3.000.000").assertIsDisplayed()
        compose.onNodeWithText("Rp 585.000 left").assertIsDisplayed()

        compose.onNodeWithText("October budget").performClick()
        assertEquals(listOf(HomeIntent.Open(HomeDestination.Budget(OCTOBER))), intents)
    }

    @Test
    fun anOverspentBudgetSaysByHowMuch() {
        val over = budget(spent = 3_200_000, status = BudgetStatus.EXCEEDED)
        setContent(dashboard().copy(budget = BudgetCard.Set(over, daysLeft = 0)))

        scrollTo("Rp 200.000 over").assertIsDisplayed()
        compose.onNodeWithText("Last day").assertIsDisplayed()
    }

    @Test
    fun aMonthWithoutBudgetPromptsToSetOne() {
        setContent(dashboard().copy(budget = BudgetCard.NotSet))

        scrollTo("No budget for October").performClick()

        assertEquals(listOf(HomeIntent.Open(HomeDestination.Budget(OCTOBER))), intents)
    }

    @Test
    fun showsWhereTheMoneyWent() {
        setContent()

        scrollTo("Others").assertIsDisplayed()
        compose.onNodeWithText("Where it went").assertIsDisplayed()
        compose.onNodeWithText("Food").assertIsDisplayed()
        compose.onNodeWithText("60%").assertIsDisplayed()
        compose.onNodeWithText("Others").assertIsDisplayed()
        compose.onNodeWithContentDescription(
            "October spending: Food 60 percent, Others 40 percent",
        ).assertIsDisplayed()

        compose.onNodeWithText("Full report").performClick()
        assertEquals(listOf(HomeIntent.Open(HomeDestination.Report(OCTOBER))), intents)
    }

    @Test
    fun hidesTheSpendingCardWithNoExpenses() {
        setContent(dashboard().copy(spending = emptyList()))

        scrollTo("Recent")
        compose.onNodeWithText("Where it went").assertDoesNotExist()
    }

    @Test
    fun listsRecentTransactionsWithTheirLabels() {
        setContent()

        scrollTo("Makan siang").assertIsDisplayed()
        compose.onNodeWithText("Food · GoPay · 12:40").assertIsDisplayed()
        compose.onNodeWithText("−Rp 35.000").assertIsDisplayed()
        scrollTo("Top up GoPay").assertIsDisplayed()
        compose.onNodeWithText("Transfer · BCA Tabungan → GoPay · Yesterday").assertIsDisplayed()
        compose.onNodeWithText("Rp 500.000").assertIsDisplayed()
        scrollTo("Gaji").assertIsDisplayed()
        compose.onNodeWithText("Salary · BCA Tabungan · 7 Oct").assertIsDisplayed()
        compose.onNodeWithText("+Rp 8.500.000").assertIsDisplayed()

        compose.onNodeWithText("Makan siang").performClick()
        assertEquals(listOf(HomeIntent.Open(HomeDestination.TransactionDetail("t1"))), intents)
    }

    @Test
    fun aFirstRunShowsTheEmptyStates() {
        setContent(
            dashboard().copy(
                greeting = Greeting.WELCOME,
                wallets = listOf(wallet("cash", "Cash", 0, WalletType.CASH, isDefault = true)),
                totalBalance = 0,
                summary = null,
                spending = emptyList(),
                recent = emptyList(),
                budget = BudgetCard.NotSet,
            ),
        )

        compose.onNodeWithText("Welcome,").assertIsDisplayed()
        compose.onNodeWithText("Total balance · 1 wallet").assertIsDisplayed()
        compose.onNodeWithText("Add BCA, GoPay and more").performClick()
        scrollTo("No transactions yet").assertIsDisplayed()
        compose.onNodeWithText("Add transaction").performClick()
        compose.onNodeWithText("or try “kopi 25rb pakai cash”").performClick()

        assertEquals(
            listOf(
                HomeIntent.Open(HomeDestination.AddWallet),
                HomeIntent.Open(HomeDestination.AddTransaction),
                HomeIntent.Open(HomeDestination.QuickAdd),
            ),
            intents,
        )
    }

    @Test
    fun showsTheSkeletonWhileLoading() {
        setContent(HomeState(month = OCTOBER, isLoading = true))

        compose.onNodeWithContentDescription("Loading your dashboard").assertIsDisplayed()
        compose.onNodeWithText("Wallets").assertDoesNotExist()
    }

    @Test
    fun aFailedFirstLoadOffersARetry() {
        setContent(
            HomeState(
                month = OCTOBER,
                isLoading = false,
                loadError = UiText.Resource(R.string.home_load_failed_network),
            ),
        )

        compose.onNodeWithText("Couldn't load your dashboard").assertIsDisplayed()
        compose.onNodeWithText("You're offline. Connect to the internet to load your dashboard.").assertIsDisplayed()
        compose.onNodeWithText("Try again").performClick()

        assertTrue(intents.contains(HomeIntent.Refresh))
    }

    private companion object {
        val OCTOBER: YearMonth = YearMonth.of(2026, 10)
        val CREATED: Instant = Instant.parse("2026-01-01T00:00:00Z")

        fun wallet(
            id: String,
            name: String,
            balance: Long,
            type: WalletType,
            isDefault: Boolean = false,
        ) = Wallet(
            id = id,
            providerId = null,
            name = name,
            type = type,
            logoUrl = null,
            initialBalance = 0,
            currentBalance = balance,
            icon = null,
            color = null,
            isDefault = isDefault,
            isArchived = false,
            createdAt = CREATED,
            updatedAt = CREATED,
        )

        fun budget(spent: Long = 2_415_000, status: BudgetStatus = BudgetStatus.WARNING) = Budget(
            month = OCTOBER,
            limitAmount = 3_000_000,
            spent = spent,
            remaining = 3_000_000 - spent,
            progressPercent = spent * 100.0 / 3_000_000,
            status = status,
        )

        fun dashboard() = HomeState(
            month = OCTOBER,
            isLoading = false,
            greeting = Greeting.EVENING,
            userName = "Joshua Putra",
            initials = "JP",
            totalBalance = 9_435_000,
            wallets = listOf(
                wallet("bca", "BCA Tabungan", 8_250_000, WalletType.BANK, isDefault = true),
                wallet("gopay", "GoPay", 1_185_000, WalletType.E_WALLET),
            ),
            summary = MonthSummary(
                incomeTotal = 8_500_000,
                expenseTotal = 2_415_000,
                expenseChangePercent = -10.4,
                previousMonth = YearMonth.of(2026, 9),
            ),
            budget = BudgetCard.Set(budget(), daysLeft = 21),
            spending = listOf(
                SpendingSlice("food", UiText.Dynamic("Food"), "#F97316", 1_449_000, 60.0),
                SpendingSlice(null, UiText.Resource(R.string.home_spending_others), null, 966_000, 40.0),
            ),
            recent = listOf(
                RecentTransaction(
                    id = "t1",
                    type = TransactionType.EXPENSE,
                    amount = 35_000,
                    title = UiText.Dynamic("Makan siang"),
                    categoryName = "Food",
                    icon = "restaurant",
                    color = "#F97316",
                    walletName = "GoPay",
                    toWalletName = null,
                    day = TransactionDay.Today(LocalTime.of(12, 40)),
                ),
                RecentTransaction(
                    id = "t2",
                    type = TransactionType.TRANSFER,
                    amount = 500_000,
                    title = UiText.Dynamic("Top up GoPay"),
                    categoryName = null,
                    icon = null,
                    color = null,
                    walletName = "BCA Tabungan",
                    toWalletName = "GoPay",
                    day = TransactionDay.Yesterday,
                ),
                RecentTransaction(
                    id = "t3",
                    type = TransactionType.INCOME,
                    amount = 8_500_000,
                    title = UiText.Dynamic("Gaji"),
                    categoryName = "Salary",
                    icon = "payments",
                    color = "#14B8A6",
                    walletName = "BCA Tabungan",
                    toWalletName = null,
                    day = TransactionDay.Earlier(LocalDate.of(2026, 10, 7)),
                ),
            ),
        )
    }
}
