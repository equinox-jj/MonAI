package com.djtech.monai.core.model

import java.time.YearMonth

enum class BudgetStatus {
    OK,

    /** At 80% or more of the limit. */
    WARNING,

    /** Above 100% of the limit. */
    EXCEEDED,
}

/** A month's spending limit and its progress, calculated by the server. */
data class Budget(
    val month: YearMonth,
    /** Rupiah. */
    val limitAmount: Long,
    /** Rupiah, the month's expenses. */
    val spent: Long,
    /** Rupiah; negative when over budget. */
    val remaining: Long,
    val progressPercent: Double,
    val status: BudgetStatus,
)
