package com.djtech.monai.feature.quickadd.presentation.quickadd

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.EngineNote
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddChip
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddDraftRow
import java.time.LocalDate

/**
 * Quick add: a phrase, what the phone understood of it as chips, and the drafts it makes.
 *
 * @param engineNote null while the input is empty.
 * @param isAsking the AI is reading the phrase.
 * @param showFallback the AI couldn't help, so the phone's drafts are shown with their gaps highlighted.
 * @param amountMissing a draft has no amount; it gets typed on the next step.
 */
@Immutable
data class QuickAddState(
    val today: LocalDate = LocalDate.MIN,
    val text: String = "",
    val chips: List<QuickAddChip> = emptyList(),
    val drafts: List<QuickAddDraftRow> = emptyList(),
    val engineNote: EngineNote? = null,
    val isAsking: Boolean = false,
    val showFallback: Boolean = false,
    val amountMissing: Boolean = false,
)

sealed interface QuickAddIntent {
    data class TextChanged(val text: String) : QuickAddIntent

    /** An example under "Try an example" fills the input. */
    data class PickExample(val text: String) : QuickAddIntent

    /** The Review button or the keyboard's Done. */
    data object Submit : QuickAddIntent

    data object Close : QuickAddIntent
}

sealed interface QuickAddEffect {
    /** One draft: the add form, prefilled. */
    data class OpenForm(val draft: TransactionDraft) : QuickAddEffect

    /** Several drafts: review them one by one. */
    data class OpenReview(val phrase: String, val drafts: List<TransactionDraft>) : QuickAddEffect

    data object Close : QuickAddEffect
}
