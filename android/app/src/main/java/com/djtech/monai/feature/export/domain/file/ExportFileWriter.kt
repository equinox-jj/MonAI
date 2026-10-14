package com.djtech.monai.feature.export.domain.file

/** Saves an export where the share sheet can hand it to another app. */
interface ExportFileWriter {
    /**
     * Writes [content] as UTF-8 to a file named [fileName], replacing earlier exports.
     * Returns its content URI, or null when it couldn't be written.
     */
    suspend fun write(fileName: String, content: String): String?
}
