package com.djtech.monai.feature.home.presentation.home

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.home.presentation.home.model.BudgetCard
import com.djtech.monai.feature.home.presentation.home.model.Greeting
import com.djtech.monai.feature.home.presentation.home.model.MonthSummary
import com.djtech.monai.feature.home.presentation.home.model.RecentTransaction
import com.djtech.monai.feature.home.presentation.home.model.SpendingSlice
import java.time.YearMonth

/**
 * The section types it's built from are in HomeUiModels.kt.
 *
 * @param isLoading nothing is cached yet and the first load is running: show the skeleton.
 * @param loadError nothing is cached and the load failed: show the error with a retry instead of the dashboard.
 * @param isRefreshing a pull-to-refresh is running.
 * @param month the month the summary, budget, spending and recent sections cover.
 * @param budget null hides the card (not loaded yet, or the load failed with nothing cached).
 * @param spending at most [MAX_SPENDING_SLICES] slices, largest first; the last may be "Others".
 */
@Immutable
data class HomeState(
    val month: YearMonth,
    val isLoading: Boolean = true,
    val loadError: UiText? = null,
    val isRefreshing: Boolean = false,
    val greeting: Greeting = Greeting.MORNING,
    val userName: String = "",
    val initials: String = "",
    val avatarUrl: String? = null,
    val isBalanceHidden: Boolean = false,
    /** Rupiah across wallets that are not archived. */
    val totalBalance: Long = 0,
    /** Not archived, default first. */
    val wallets: List<Wallet> = emptyList(),
    val summary: MonthSummary? = null,
    val budget: BudgetCard? = null,
    val spending: List<SpendingSlice> = emptyList(),
    val recent: List<RecentTransaction> = emptyList(),
)

sealed interface HomeIntent {
    /** Pull-to-refresh and the error's retry. */
    data object Refresh : HomeIntent

    data object ToggleBalanceVisibility : HomeIntent

    data class Open(val destination: HomeDestination) : HomeIntent
}

sealed interface HomeEffect {
    data class Navigate(val destination: HomeDestination) : HomeEffect

    /** A refresh failed while cached data is on screen; [isOffline] gets the offline icon. */
    data class ShowMessage(val message: UiText, val isOffline: Boolean) : HomeEffect
}

/** Shared by [HomeIntent.Open] and [HomeEffect.Navigate]. */
sealed interface HomeDestination {
    data object Search : HomeDestination
    data object Settings : HomeDestination
    data object QuickAdd : HomeDestination
    data object ScanReceipt : HomeDestination
    data object Wallets : HomeDestination
    data class WalletDetail(val walletId: String) : HomeDestination
    data object AddWallet : HomeDestination
    data object Budget : HomeDestination
    data object Report : HomeDestination
    data object Transactions : HomeDestination
    data class TransactionDetail(val transactionId: String) : HomeDestination
    data object AddTransaction : HomeDestination
}
