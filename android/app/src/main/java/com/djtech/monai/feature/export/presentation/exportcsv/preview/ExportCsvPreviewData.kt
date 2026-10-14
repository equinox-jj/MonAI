package com.djtech.monai.feature.export.presentation.exportcsv.preview

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.export.domain.model.CsvDelimiter
import com.djtech.monai.feature.export.domain.model.ExportRange
import com.djtech.monai.feature.export.presentation.exportcsv.ExportCsvState
import java.time.YearMonth

internal object ExportCsvPreviewData {
    private val october = YearMonth.of(2026, 10)

    val thisMonth = ExportCsvState(range = ExportRange(october, october), currentMonth = october)

    val quarter = ExportCsvState(
        range = ExportRange(october.minusMonths(2), october),
        currentMonth = october,
        delimiter = CsvDelimiter.SEMICOLON,
    )

    val failed = thisMonth.copy(error = UiText.Resource(R.string.export_error_empty))
}
