package com.djtech.monai.feature.export.domain.model

/** Why an export produced no file. */
sealed interface ExportError {
    /** The range ends before it starts, reaches past this month, or is over [MAX_EXPORT_MONTHS]. */
    data object InvalidRange : ExportError

    /** The server has no transactions in the range. */
    data object NoTransactions : ExportError

    /** Offline, and nothing in the range is cached either. */
    data object Network : ExportError

    data object Unexpected : ExportError
}
