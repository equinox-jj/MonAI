package com.djtech.monai.feature.budgets.domain.model

import com.djtech.monai.core.model.BudgetStatus

/**
 * How [spent] compares with a [limit] the user hasn't saved yet, by the server's rules, so the
 * budget screen can show progress while the limit is typed. Amounts are rupiah.
 */
data class BudgetPreview(
    val spent: Long,
    val limit: Long,
    /** Negative when over budget. */
    val remaining: Long,
    /** Rounded down. */
    val percent: Int,
    val status: BudgetStatus,
) {
    companion object {
        /** Null without a positive [limit]. */
        fun of(spent: Long, limit: Long): BudgetPreview? {
            if (limit <= 0) return null
            // Amounts stay below 10^15, so * 100 can't overflow.
            val status = when {
                spent > limit -> BudgetStatus.EXCEEDED
                spent * 100 >= limit * 80 -> BudgetStatus.WARNING
                else -> BudgetStatus.OK
            }
            return BudgetPreview(
                spent = spent,
                limit = limit,
                remaining = limit - spent,
                percent = (spent * 100 / limit).toInt(),
                status = status,
            )
        }
    }
}
