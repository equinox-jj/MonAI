package com.djtech.monai.core.model

import java.time.YearMonth

/** A month's totals and expense breakdown compared with the month before. Amounts are rupiah. */
data class MonthlyReport(
    val month: YearMonth,
    val incomeTotal: Long,
    val expenseTotal: Long,
    val net: Long,
    val previous: PreviousMonthTotals,
    /** Null when the previous month had no expenses. */
    val expenseChangePercent: Double?,
    /** Sorted by amount, largest first. */
    val categories: List<CategoryBreakdown>,
)

data class PreviousMonthTotals(
    val month: YearMonth,
    val incomeTotal: Long,
    val expenseTotal: Long,
)

data class CategoryBreakdown(
    val categoryId: String,
    val name: String,
    val icon: String?,
    val color: String?,
    val amount: Long,
    val sharePercent: Double,
    val previousAmount: Long,
    /** Null when [previousAmount] is 0. */
    val changePercent: Double?,
)
