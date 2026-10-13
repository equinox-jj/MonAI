package com.djtech.monai.feature.quickadd.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.feature.quickadd.domain.model.QuickAddResult
import kotlinx.coroutines.CompletableDeferred
import java.time.LocalDate
import java.time.ZoneId

/** Answers every parse with [result], recording the texts asked about. */
class FakeQuickAddRepository(
    var result: QuickAddResult<List<TransactionDraft>> = Outcome.Success(emptyList()),
) : QuickAddRepository {
    val texts = mutableListOf<String>()

    /** When set, parse suspends until it completes, to observe the in-flight state or a timeout. */
    var gate: CompletableDeferred<Unit>? = null

    override suspend fun parse(text: String, today: LocalDate, zone: ZoneId): QuickAddResult<List<TransactionDraft>> {
        texts += text
        gate?.await()
        return result
    }
}
