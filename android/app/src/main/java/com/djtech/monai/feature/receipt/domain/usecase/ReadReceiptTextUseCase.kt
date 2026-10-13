package com.djtech.monai.feature.receipt.domain.usecase

import com.djtech.monai.feature.receipt.domain.ocr.ReceiptTextReader
import javax.inject.Inject

/** The text on the receipt photo at [uri], read on the phone; null when the photo has none. */
class ReadReceiptTextUseCase @Inject constructor(private val receiptTextReader: ReceiptTextReader) {
    suspend operator fun invoke(uri: String): String? = receiptTextReader.read(uri)?.trim()?.ifEmpty { null }
}
