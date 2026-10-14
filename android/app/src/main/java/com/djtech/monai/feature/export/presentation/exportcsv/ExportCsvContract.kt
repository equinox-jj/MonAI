package com.djtech.monai.feature.export.presentation.exportcsv

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.export.domain.model.CsvDelimiter
import com.djtech.monai.feature.export.domain.model.ExportRange
import java.time.YearMonth

/**
 * @param currentMonth the latest month either end of [range] may reach.
 * @param error why the last export failed; cleared by any change.
 */
@Immutable
data class ExportCsvState(
    val range: ExportRange,
    val currentMonth: YearMonth,
    val delimiter: CsvDelimiter = CsvDelimiter.COMMA,
    val isExporting: Boolean = false,
    val error: UiText? = null,
) {
    val canMoveFromForward: Boolean get() = range.from < currentMonth
    val canMoveToForward: Boolean get() = range.to < currentMonth
}

sealed interface ExportCsvIntent {
    /** Moves the first month by [months]; the last one follows when needed. */
    data class MoveFrom(val months: Int) : ExportCsvIntent

    /** Moves the last month by [months]; the first one follows when needed. */
    data class MoveTo(val months: Int) : ExportCsvIntent

    data class PickDelimiter(val delimiter: CsvDelimiter) : ExportCsvIntent

    data object Export : ExportCsvIntent

    /** Stops a running export; the sheet closes. */
    data object Cancel : ExportCsvIntent
}

sealed interface ExportCsvEffect {
    /** Hands [uri] to the share sheet. [isComplete] is false when only cached transactions went in. */
    data class Share(val uri: String, val isComplete: Boolean) : ExportCsvEffect
}
