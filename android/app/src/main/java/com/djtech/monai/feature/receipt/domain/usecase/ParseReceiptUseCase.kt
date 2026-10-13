package com.djtech.monai.feature.receipt.domain.usecase

import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.feature.receipt.domain.model.ReceiptResult
import com.djtech.monai.feature.receipt.domain.repository.ReceiptRepository
import javax.inject.Inject

/** Turns a receipt's OCR text into a draft (merchant, total, date, category, items) with the AI. */
class ParseReceiptUseCase @Inject constructor(
    private val receiptRepository: ReceiptRepository,
    private val clock: AppClock,
) {
    suspend operator fun invoke(ocrText: String): ReceiptResult<ReceiptDraft> =
        receiptRepository.parse(ocrText.take(MAX_OCR_TEXT), clock.today(), clock.zone())

    private companion object {
        /** The API's limit; a receipt's total is near the end, but long ones are rare. */
        const val MAX_OCR_TEXT = 5000
    }
}
