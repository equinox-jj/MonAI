package com.djtech.monai.feature.quickadd.domain.usecase

import com.djtech.monai.core.common.coroutines.Dispatcher
import com.djtech.monai.core.common.coroutines.MonAIDispatcher
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.quickadd.domain.parser.ParseContext
import com.djtech.monai.feature.quickadd.domain.parser.QuickAddParser
import com.djtech.monai.feature.transactions.domain.usecase.FindCategoryForNoteUseCase
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.withContext
import javax.inject.Inject

/**
 * Layer 1 of quick add, on the phone: parses [text] and, for each draft whose note the user has
 * used before, takes the category they gave it then over the keyword guess.
 */
class ParseQuickAddUseCase @Inject constructor(
    private val findCategoryForNote: FindCategoryForNoteUseCase,
    @Dispatcher(MonAIDispatcher.Default) private val dispatcher: CoroutineDispatcher,
) {
    suspend operator fun invoke(text: String, context: ParseContext): List<TransactionDraft> {
        val drafts = withContext(dispatcher) { QuickAddParser.parse(text, context) }
        val visible = context.categories.map { it.id }.toSet()
        return drafts.map { draft ->
            val note = draft.note
            val type = draft.type
            if (note == null || type == null || type == TransactionType.TRANSFER) return@map draft
            val remembered = findCategoryForNote(note, type)?.takeIf { it in visible } ?: return@map draft
            draft.copy(categoryId = remembered, confidence = draft.confidence.copy(category = HISTORY))
        }
    }

    private companion object {
        const val HISTORY = 0.9
    }
}
