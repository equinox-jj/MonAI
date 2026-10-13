package com.djtech.monai.feature.receipt.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.model.receiptDraft
import com.djtech.monai.feature.receipt.domain.model.ReceiptResult
import kotlinx.coroutines.CompletableDeferred
import java.time.LocalDate
import java.time.ZoneId

/** Answers every parse with [result], recording the OCR texts sent. */
class FakeReceiptRepository(
    var result: ReceiptResult<ReceiptDraft> = Outcome.Success(receiptDraft()),
) : ReceiptRepository {
    val texts = mutableListOf<String>()

    /** When set, parse suspends until it completes, to observe the in-flight state. */
    var gate: CompletableDeferred<Unit>? = null

    override suspend fun parse(ocrText: String, today: LocalDate, zone: ZoneId): ReceiptResult<ReceiptDraft> {
        texts += ocrText
        gate?.await()
        return result
    }
}
