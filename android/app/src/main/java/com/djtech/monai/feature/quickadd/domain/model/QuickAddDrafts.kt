package com.djtech.monai.feature.quickadd.domain.model

import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.isLowConfidence

/** Who read the phrase: the phone alone, the AI, or the phone because the AI couldn't. */
enum class DraftEngine { LOCAL, AI, FALLBACK }

data class QuickAddDrafts(val drafts: List<TransactionDraft>, val engine: DraftEngine)

/**
 * Whether the phone's drafts are too unsure to use without the AI: none at all, or one without a
 * sure amount or category. An unnamed wallet doesn't count; the default one is used, highlighted.
 */
fun List<TransactionDraft>.needsAi(): Boolean =
    isEmpty() || any { it.confidence.amount.isLowConfidence() || it.confidence.category.isLowConfidence() }
