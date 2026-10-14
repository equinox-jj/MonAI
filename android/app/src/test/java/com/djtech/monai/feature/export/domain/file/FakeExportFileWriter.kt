package com.djtech.monai.feature.export.domain.file

/** Records what it was asked to write and answers with a URI named after the file, or null when [fails]. */
class FakeExportFileWriter : ExportFileWriter {
    var fails = false
    val written = mutableListOf<Pair<String, String>>()

    override suspend fun write(fileName: String, content: String): String? {
        written += fileName to content
        return if (fails) null else "content://com.djtech.monai.fileprovider/exports/$fileName"
    }
}
