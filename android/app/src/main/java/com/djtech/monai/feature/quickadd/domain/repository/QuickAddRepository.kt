package com.djtech.monai.feature.quickadd.domain.repository

import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.feature.quickadd.domain.model.QuickAddResult
import java.time.LocalDate
import java.time.ZoneId

/** The AI layer of quick add. The server knows the user's wallets and categories; nothing is saved. */
interface QuickAddRepository {

    /** Drafts for [text] (1–300 characters), reading relative dates from [today] in [zone]. */
    suspend fun parse(text: String, today: LocalDate, zone: ZoneId): QuickAddResult<List<TransactionDraft>>
}
