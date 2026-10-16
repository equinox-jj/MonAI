package com.djtech.monai.navigation

import androidx.navigation3.runtime.EntryProviderScope
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.common.time.toYearMonthOrNull
import com.djtech.monai.feature.budgets.presentation.budget.BudgetRoute
import com.djtech.monai.feature.home.presentation.home.HomeDestination
import com.djtech.monai.feature.home.presentation.home.HomeRoute
import com.djtech.monai.feature.reports.presentation.report.ReportRoute
import java.time.YearMonth

/**
 * Where Home's links lead. "See all" and the avatar switch tabs; search, transactions, the budget
 * the report, quick add and receipt scanning open on top of Home.
 */
internal fun MainNavigator.openFromHome(destination: HomeDestination) {
    when (destination) {
        HomeDestination.Transactions -> selectTab(TopLevelDestination.Transactions)
        HomeDestination.Search -> navigate(TransactionSearchRoute())
        is HomeDestination.TransactionDetail -> navigate(TransactionDetailRoute(destination.transactionId))
        HomeDestination.AddTransaction -> navigate(TransactionFormRoute())

        is HomeDestination.WalletDetail -> navigate(WalletDetailRoute(destination.walletId))
        HomeDestination.AddWallet -> navigate(WalletFormRoute())

        HomeDestination.Wallets -> selectTab(TopLevelDestination.Wallets)
        HomeDestination.Settings -> selectTab(TopLevelDestination.Settings)

        is HomeDestination.Budget -> navigate(BudgetRoute(destination.month.toApiString()))
        is HomeDestination.Report -> navigate(ReportRoute(destination.month.toApiString()))

        HomeDestination.QuickAdd -> navigate(QuickAddRoute)
        HomeDestination.ScanReceipt -> navigate(ScanReceiptRoute)
    }
}

/** Home, and the month's report and budget it links to (Settings opens the budget too). */
internal fun EntryProviderScope<NavKey>.homeEntries(navigator: MainNavigator) {
    entry<HomeRoute> { HomeRoute(onNavigate = navigator::openFromHome) }
    entry<ReportRoute> { key ->
        ReportRoute(
            initialMonth = key.month?.toYearMonthOrNull(),
            onOpenBudget = { month -> navigator.navigate(BudgetRoute(month.toApiString())) },
            onBack = navigator::goBack,
        )
    }
    entry<BudgetRoute> { key ->
        // Keys are only built with toApiString, so the month always parses.
        BudgetRoute(month = YearMonth.parse(key.month), onClose = navigator::goBack)
    }
}
