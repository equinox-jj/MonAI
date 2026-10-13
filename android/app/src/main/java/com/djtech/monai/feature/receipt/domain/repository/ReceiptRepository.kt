package com.djtech.monai.feature.receipt.domain.repository

import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.feature.receipt.domain.model.ReceiptResult
import java.time.LocalDate
import java.time.ZoneId

interface ReceiptRepository {

    /** Asks the AI for a draft from a receipt's OCR text (1–5000 characters). Nothing is saved. */
    suspend fun parse(ocrText: String, today: LocalDate, zone: ZoneId): ReceiptResult<ReceiptDraft>
}
