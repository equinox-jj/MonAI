package com.djtech.monai.feature.home.presentation.home.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryBreakdown
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.home.presentation.home.model.Greeting
import com.djtech.monai.feature.home.presentation.home.model.MonthSummary
import com.djtech.monai.feature.home.presentation.home.model.RecentTransaction
import com.djtech.monai.feature.home.presentation.home.model.SpendingSlice
import com.djtech.monai.feature.home.presentation.home.model.TransactionDay
import java.time.LocalDate
import java.time.LocalTime
import java.time.ZoneId
import java.time.temporal.ChronoUnit

internal fun greetingFor(time: LocalTime): Greeting = when (time.hour) {
    in 5..11 -> Greeting.MORNING
    in 12..17 -> Greeting.AFTERNOON
    else -> Greeting.EVENING
}

/** `JP` for "Joshua Putra Jeremia": the first letters of the first two words. */
internal fun initialsOf(name: String): String =
    name.trim().split(WHITESPACE).filter(String::isNotEmpty).take(2)
        .joinToString("") { it.first().uppercase() }

/**
 * The wallet card's logo stand-in: `BCA` for "BCA Tabungan", `GP` for "GoPay", `BJ` for "Bank Jago".
 * Provider logos replace it once images load.
 */
internal fun walletMonogram(name: String): String {
    val words = name.trim().split(WHITESPACE).filter(String::isNotEmpty)
    val first = words.firstOrNull() ?: return ""
    if (first.length <= 3) return first.uppercase()
    if (words.size > 1) return initialsOf(name)
    val capitals = first.filter(Char::isUpperCase)
    return if (capitals.length >= 2) capitals.take(2) else first.take(2).uppercase()
}

private val WHITESPACE = Regex("\\s+")

/** Slices the spending card shows, "Others" included. */
internal const val MAX_SPENDING_SLICES = 5

/** Days after [today] until the month ends; 0 on its last day. */
internal fun daysLeftInMonth(today: LocalDate): Int = today.lengthOfMonth() - today.dayOfMonth

internal fun MonthlyReport.toSummary(): MonthSummary = MonthSummary(
    incomeTotal = incomeTotal,
    expenseTotal = expenseTotal,
    expenseChangePercent = expenseChangePercent,
    previousMonth = previous.month,
)

/** The largest categories, with the rest folded into one "Others" slice once there are too many. */
internal fun List<CategoryBreakdown>.toSpendingSlices(): List<SpendingSlice> {
    val spent = filter { it.amount > 0 }
    if (spent.size <= MAX_SPENDING_SLICES) return spent.map(CategoryBreakdown::toSlice)

    val rest = spent.drop(MAX_SPENDING_SLICES - 1)
    val others = SpendingSlice(
        categoryId = null,
        name = UiText.Resource(R.string.home_spending_others),
        color = null,
        amount = rest.sumOf(CategoryBreakdown::amount),
        sharePercent = rest.sumOf(CategoryBreakdown::sharePercent),
    )
    return spent.take(MAX_SPENDING_SLICES - 1).map(CategoryBreakdown::toSlice) + others
}

private fun CategoryBreakdown.toSlice() = SpendingSlice(
    categoryId = categoryId,
    name = UiText.Dynamic(name),
    color = color,
    amount = amount,
    sharePercent = sharePercent,
)

internal fun Transaction.toRecent(
    categoriesById: Map<String, Category>,
    walletsById: Map<String, Wallet>,
    today: LocalDate,
    zone: ZoneId,
): RecentTransaction {
    val category = categoryId?.let(categoriesById::get)
    val text = note?.takeIf(String::isNotBlank) ?: merchant?.takeIf(String::isNotBlank) ?: category?.name
    val title = when {
        text != null -> UiText.Dynamic(text)
        type == TransactionType.TRANSFER -> UiText.Resource(R.string.home_transaction_transfer)
        else -> UiText.Resource(R.string.home_transaction_untitled)
    }
    return RecentTransaction(
        id = id,
        type = type,
        amount = amount,
        title = title,
        categoryName = category?.name,
        icon = category?.icon,
        color = category?.color,
        walletName = walletsById[walletId]?.name,
        toWalletName = toWalletId?.let(walletsById::get)?.name,
        day = dayOf(today, zone),
    )
}

private fun Transaction.dayOf(today: LocalDate, zone: ZoneId): TransactionDay = when (date) {
    today -> TransactionDay.Today(createdAt.atZone(zone).toLocalTime().truncatedTo(ChronoUnit.MINUTES))
    today.minusDays(1) -> TransactionDay.Yesterday
    else -> TransactionDay.Earlier(date)
}
