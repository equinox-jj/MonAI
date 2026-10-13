package com.djtech.monai.feature.receipt.domain.ocr

/** Reads [text] from every photo, recording which ones were read. */
class FakeReceiptTextReader(var text: String? = "TOKO SUMBER REJEKI\nTOTAL 187.500") : ReceiptTextReader {
    val uris = mutableListOf<String>()

    override suspend fun read(uri: String): String? {
        uris += uri
        return text
    }
}
