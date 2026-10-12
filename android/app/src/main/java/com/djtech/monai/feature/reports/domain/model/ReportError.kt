package com.djtech.monai.feature.reports.domain.model

/** Why loading a report failed, in terms the report screens can show. */
sealed interface ReportError {
    data object Network : ReportError

    data object Unexpected : ReportError
}
