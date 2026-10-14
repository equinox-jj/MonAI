package com.djtech.monai.feature.export.domain.model

import java.time.YearMonth
import java.time.temporal.ChronoUnit

/** The longest range one export may cover; each month is at least one API call. */
const val MAX_EXPORT_MONTHS = 12

/** The months [from] to [to], both included. */
data class ExportRange(val from: YearMonth, val to: YearMonth) {
    /** 1 for a single month; 0 or less when [to] is before [from]. */
    val monthCount: Int get() = ChronoUnit.MONTHS.between(from, to).toInt() + 1

    /** Each month of the range, oldest first. */
    val months: List<YearMonth> get() = (0 until monthCount).map { from.plusMonths(it.toLong()) }
}
