package com.djtech.monai.feature.home.presentation.home.model

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.model.TransactionType
import java.time.LocalDate
import java.time.LocalTime
import java.time.YearMonth

enum class Greeting {
    MORNING,
    AFTERNOON,
    EVENING,

    /** Nothing recorded this month yet. */
    WELCOME,
}

/** The month's totals. Amounts are rupiah. */
@Immutable
data class MonthSummary(
    val incomeTotal: Long,
    val expenseTotal: Long,
    /** Against [previousMonth]; negative means less was spent. Null when that month had no expenses. */
    val expenseChangePercent: Double?,
    val previousMonth: YearMonth,
)

@Immutable
sealed interface BudgetCard {
    data class Set(val budget: Budget, val daysLeft: Int) : BudgetCard

    /** The month has no budget: prompt to set one. */
    data object NotSet : BudgetCard
}

/**
 * @param categoryId null for the "Others" slice.
 * @param color `#RRGGBB`; null uses the neutral color.
 */
@Immutable
data class SpendingSlice(
    val categoryId: String?,
    val name: UiText,
    val color: String?,
    val amount: Long,
    val sharePercent: Double,
)

/**
 * A row of the recent list, already joined with its category and wallets. Names are null when
 * they aren't cached.
 */
@Immutable
data class RecentTransaction(
    val id: String,
    val type: TransactionType,
    /** Rupiah, positive; [type] gives the sign. */
    val amount: Long,
    /** The note, else the merchant, else the category name. */
    val title: UiText,
    val categoryName: String?,
    val icon: String?,
    /** `#RRGGBB`. */
    val color: String?,
    val walletName: String?,
    val toWalletName: String?,
    val day: TransactionDay,
)

@Immutable
sealed interface TransactionDay {
    /** [time] is when it was recorded, the closest thing to a time the API has. */
    data class Today(val time: LocalTime) : TransactionDay

    data object Yesterday : TransactionDay

    data class Earlier(val date: LocalDate) : TransactionDay
}
