package com.djtech.monai.feature.export.domain.model

/**
 * A written export. [uri] is a content URI other apps may read once granted.
 * [isComplete] is false when the app was offline and only cached transactions went in.
 */
data class ExportedCsv(
    val uri: String,
    val rowCount: Int,
    val isComplete: Boolean,
)
