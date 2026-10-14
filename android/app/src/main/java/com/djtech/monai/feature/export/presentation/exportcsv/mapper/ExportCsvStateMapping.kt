package com.djtech.monai.feature.export.presentation.exportcsv.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.export.domain.model.ExportError
import com.djtech.monai.feature.export.domain.model.ExportRange
import com.djtech.monai.feature.export.domain.model.MAX_EXPORT_MONTHS
import java.time.YearMonth

private const val MAX_SPAN = MAX_EXPORT_MONTHS - 1L

/** Starts at [month] (never after [latest]), pulling the end along to stay valid. */
internal fun ExportRange.withFrom(month: YearMonth, latest: YearMonth): ExportRange {
    val from = minOf(month, latest)
    val to = to.coerceIn(from, from.plusMonths(MAX_SPAN)).coerceAtMost(latest)
    return ExportRange(from, to)
}

/** Ends at [month] (never after [latest]), pulling the start along to stay valid. */
internal fun ExportRange.withTo(month: YearMonth, latest: YearMonth): ExportRange {
    val to = minOf(month, latest)
    val from = from.coerceIn(to.minusMonths(MAX_SPAN), to)
    return ExportRange(from, to)
}

internal fun ExportError.message(): UiText = UiText.Resource(
    when (this) {
        ExportError.InvalidRange -> R.string.export_error_range
        ExportError.NoTransactions -> R.string.export_error_empty
        ExportError.Network -> R.string.export_error_network
        ExportError.Unexpected -> R.string.export_error_unexpected
    },
)
