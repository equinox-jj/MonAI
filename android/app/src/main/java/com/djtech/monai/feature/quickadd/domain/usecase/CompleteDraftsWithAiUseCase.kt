package com.djtech.monai.feature.quickadd.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.model.DraftConfidence
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.feature.quickadd.domain.model.DraftEngine
import com.djtech.monai.feature.quickadd.domain.model.QuickAddDrafts
import com.djtech.monai.feature.quickadd.domain.model.needsAi
import com.djtech.monai.feature.quickadd.domain.parser.ParseContext
import com.djtech.monai.feature.quickadd.domain.repository.QuickAddRepository
import kotlinx.coroutines.withTimeoutOrNull
import javax.inject.Inject
import kotlin.time.Duration.Companion.seconds

/**
 * Layer 2 of quick add. Keeps the phone's [local] drafts when they already have a sure amount and
 * category (an unnamed wallet falls back to the default one, highlighted); otherwise asks the AI,
 * giving up after 3 seconds. Any AI failure (offline, 429, 503, timeout) falls back to [local],
 * whose unsure fields stay highlighted.
 */
class CompleteDraftsWithAiUseCase @Inject constructor(
    private val quickAddRepository: QuickAddRepository,
    private val clock: AppClock,
) {
    suspend operator fun invoke(
        text: String,
        local: List<TransactionDraft>,
        context: ParseContext,
    ): QuickAddDrafts {
        if (!local.needsAi()) return QuickAddDrafts(local, DraftEngine.LOCAL)
        val result = withTimeoutOrNull(AI_TIMEOUT) {
            quickAddRepository.parse(text.trim().take(MAX_TEXT), clock.today(), clock.zone())
        }
        val drafts = (result as? Outcome.Success)?.data?.takeIf { it.isNotEmpty() }
            ?: return QuickAddDrafts(local, DraftEngine.FALLBACK)
        val merged = drafts.mapIndexed { index, ai ->
            ai.fillFrom(local.getOrNull(index).takeIf { drafts.size == local.size }, context)
        }
        return QuickAddDrafts(merged, DraftEngine.AI)
    }

    /** Fields the AI left null come from the phone's draft at the same place, else the defaults. */
    private fun TransactionDraft.fillFrom(local: TransactionDraft?, context: ParseContext): TransactionDraft {
        val walletId = walletId ?: local?.walletId ?: context.defaultWalletId
        return copy(
            type = type ?: local?.type,
            amount = amount ?: local?.amount,
            walletId = walletId,
            categoryId = categoryId ?: local?.categoryId,
            date = date ?: local?.date ?: context.today,
            note = note ?: local?.note,
            confidence = DraftConfidence(
                type = if (type != null) confidence.type else local?.confidence?.type ?: 0.0,
                amount = if (amount != null) confidence.amount else local?.confidence?.amount ?: 0.0,
                wallet = when {
                    this.walletId != null -> confidence.wallet
                    local?.walletId != null -> local.confidence.wallet
                    walletId != null -> DEFAULT_WALLET
                    else -> 0.0
                },
                category = if (categoryId != null) confidence.category else local?.confidence?.category ?: 0.0,
                date = if (date != null) confidence.date else local?.confidence?.date ?: 0.0,
            ),
        )
    }

    private companion object {
        val AI_TIMEOUT = 3.seconds
        const val MAX_TEXT = 300
        const val DEFAULT_WALLET = 0.5
    }
}
