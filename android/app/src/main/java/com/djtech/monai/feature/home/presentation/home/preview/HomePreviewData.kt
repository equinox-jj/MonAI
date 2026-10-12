package com.djtech.monai.feature.home.presentation.home.preview

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.home.presentation.home.HomeState
import com.djtech.monai.feature.home.presentation.home.model.BudgetCard
import com.djtech.monai.feature.home.presentation.home.model.Greeting
import com.djtech.monai.feature.home.presentation.home.model.MonthSummary
import com.djtech.monai.feature.home.presentation.home.model.RecentTransaction
import com.djtech.monai.feature.home.presentation.home.model.SpendingSlice
import com.djtech.monai.feature.home.presentation.home.model.TransactionDay
import java.time.Instant
import java.time.LocalTime
import java.time.YearMonth

/** Sample states for the Home previews, matching the design canvas. */
internal object HomePreviewData {
    private val october = YearMonth.of(2026, 10)
    private val created = Instant.parse("2026-01-01T00:00:00Z")

    private fun wallet(
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
        createdAt = created,
        updatedAt = created,
    )

    private fun expense(
        id: String,
        title: String,
        amount: Long,
        category: String,
        icon: String,
        color: String,
        wallet: String,
        day: TransactionDay,
    ) = RecentTransaction(
        id = id,
        type = TransactionType.EXPENSE,
        amount = amount,
        title = UiText.Dynamic(title),
        categoryName = category,
        icon = icon,
        color = color,
        walletName = wallet,
        toWalletName = null,
        day = day,
    )

    val dashboard = HomeState(
        month = october,
        isLoading = false,
        greeting = Greeting.EVENING,
        userName = "Joshua",
        initials = "JP",
        totalBalance = 12_450_000,
        wallets = listOf(
            wallet("bca", "BCA Tabungan", 8_250_000, WalletType.BANK, isDefault = true),
            wallet("gopay", "GoPay", 1_185_000, WalletType.E_WALLET),
            wallet("cash", "Cash", 3_015_000, WalletType.CASH),
        ),
        summary = MonthSummary(
            incomeTotal = 8_500_000,
            expenseTotal = 2_415_000,
            expenseChangePercent = -10.0,
            previousMonth = october.minusMonths(1),
        ),
        budget = BudgetCard.Set(
            Budget(
                month = october,
                limitAmount = 3_000_000,
                spent = 2_415_000,
                remaining = 585_000,
                progressPercent = 80.5,
                status = BudgetStatus.WARNING,
            ),
            daysLeft = 21,
        ),
        spending = listOf(
            SpendingSlice("food", UiText.Dynamic("Food"), "#F97316", 869_400, 36.0),
            SpendingSlice("bills", UiText.Dynamic("Bills"), "#8B5CF6", 603_750, 25.0),
            SpendingSlice("transport", UiText.Dynamic("Transport"), "#0EA5E9", 410_550, 17.0),
            SpendingSlice("shopping", UiText.Dynamic("Shopping"), "#EC4899", 313_950, 13.0),
            SpendingSlice(null, UiText.Resource(R.string.home_spending_others), null, 217_350, 9.0),
        ),
        recent = listOf(
            expense(
                "t1",
                "Makan siang",
                35_000,
                "Food",
                "restaurant",
                "#F97316",
                "GoPay",
                TransactionDay.Today(LocalTime.of(12, 40)),
            ),
            expense(
                "t2",
                "Parkir",
                5_000,
                "Transport",
                "directions_car",
                "#0EA5E9",
                "Cash",
                TransactionDay.Today(LocalTime.of(8, 50)),
            ),
            expense(
                "t3",
                "Belanja bulanan",
                187_500,
                "Shopping",
                "shopping_bag",
                "#EC4899",
                "BCA",
                TransactionDay.Yesterday,
            ),
            RecentTransaction(
                id = "t4",
                type = TransactionType.TRANSFER,
                amount = 500_000,
                title = UiText.Dynamic("Top up GoPay"),
                categoryName = null,
                icon = null,
                color = null,
                walletName = "BCA",
                toWalletName = "GoPay",
                day = TransactionDay.Yesterday,
            ),
        ),
    )

    val firstRun = HomeState(
        month = october,
        isLoading = false,
        greeting = Greeting.WELCOME,
        userName = "Joshua",
        initials = "JP",
        wallets = listOf(wallet("cash", "Cash", 0, WalletType.CASH, isDefault = true)),
        budget = BudgetCard.NotSet,
    )
}
