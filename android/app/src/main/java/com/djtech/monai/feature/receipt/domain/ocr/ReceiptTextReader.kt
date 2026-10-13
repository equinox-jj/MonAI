package com.djtech.monai.feature.receipt.domain.ocr

/** On-device text recognition, so the photo itself never goes to the AI. */
interface ReceiptTextReader {

    /** The text in the image at [uri] (a content or file URI), or null when none could be read. */
    suspend fun read(uri: String): String?
}
