package com.djtech.monai.feature.quickadd.presentation.quickadd

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.feature.quickadd.domain.model.DraftEngine
import com.djtech.monai.feature.quickadd.domain.model.needsAi
import com.djtech.monai.feature.quickadd.domain.parser.ParseContext
import com.djtech.monai.feature.quickadd.domain.usecase.CompleteDraftsWithAiUseCase
import com.djtech.monai.feature.quickadd.domain.usecase.ObserveQuickAddContextUseCase
import com.djtech.monai.feature.quickadd.domain.usecase.ParseQuickAddUseCase
import com.djtech.monai.feature.quickadd.presentation.quickadd.mapper.toChips
import com.djtech.monai.feature.quickadd.presentation.quickadd.mapper.toEngineNote
import com.djtech.monai.feature.quickadd.presentation.quickadd.mapper.toRows
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChangedBy
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Reads the phrase on the phone as it is typed (chips and drafts update live). Continuing asks
 * the AI once when the phone was unsure, shows what came back, then opens the form or the review.
 */
@HiltViewModel
class QuickAddViewModel @Inject constructor(
    observeQuickAddContext: ObserveQuickAddContextUseCase,
    private val parseQuickAdd: ParseQuickAddUseCase,
    private val completeDraftsWithAi: CompleteDraftsWithAiUseCase,
) : ViewModel() {

    private val session = MutableStateFlow(Session())

    // Shared eagerly: parsing needs it as soon as the first letter is typed.
    private val context: StateFlow<ParseContext?> =
        observeQuickAddContext().stateIn(viewModelScope, SharingStarted.Eagerly, null)

    val state: StateFlow<QuickAddState> = combine(session, context.filterNotNull()) { session, context ->
        QuickAddState(
            today = context.today,
            text = session.text,
            chips = session.drafts.toChips(context),
            drafts = session.drafts.toRows(context),
            engineNote = session.drafts.toEngineNote(session.engine, session.drafts.needsAi(), context),
            isAsking = session.isAsking,
            showFallback = session.engine == DraftEngine.FALLBACK,
            amountMissing = session.drafts.any { it.amount == null },
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, QuickAddState())

    private val effectQueue = EffectQueue<QuickAddEffect>()
    val effects: Flow<QuickAddEffect> = effectQueue.flow

    private var askJob: Job? = null

    init {
        parseAsTyped()
    }

    fun onIntent(intent: QuickAddIntent) {
        when (intent) {
            is QuickAddIntent.TextChanged -> setText(intent.text)
            is QuickAddIntent.PickExample -> setText(intent.text)
            QuickAddIntent.Submit -> submit()
            QuickAddIntent.Close -> effectQueue.send(QuickAddEffect.Close)
        }
    }

    private fun setText(text: String) {
        val trimmed = text.take(MAX_TEXT)
        if (trimmed == session.value.text) return
        // A new phrase drops the AI's answer to the old one.
        askJob?.cancel()
        session.update { Session(text = trimmed, drafts = it.drafts, parsedText = it.parsedText) }
    }

    private fun parseAsTyped() {
        viewModelScope.launch {
            combine(session.distinctUntilChangedBy { it.text }, context.filterNotNull()) { session, context ->
                session.text to context
            }.collectLatest { (text, context) ->
                keepDrafts(text, parseQuickAdd(text, context))
            }
        }
    }

    private fun submit() {
        val current = session.value
        if (current.isAsking || current.text.isBlank()) return
        askJob = viewModelScope.launch {
            val context = context.filterNotNull().first()
            // Done right after typing can beat the live parse; read the latest text first.
            val local = if (current.parsedText == current.text) {
                current.drafts
            } else {
                parseQuickAdd(current.text, context).also { drafts -> keepDrafts(current.text, drafts) }
            }
            if (current.engine != DraftEngine.LOCAL || !local.needsAi()) {
                open(current.text, local)
                return@launch
            }
            session.update { it.copy(isAsking = true) }
            val result = completeDraftsWithAi(current.text, local, context)
            session.update {
                if (it.text != current.text) return@update it
                it.copy(drafts = result.drafts, engine = result.engine, isAsking = false)
            }
        }
    }

    private fun keepDrafts(text: String, drafts: List<TransactionDraft>) {
        session.update {
            if (it.text == text && it.engine == DraftEngine.LOCAL) it.copy(drafts = drafts, parsedText = text) else it
        }
    }

    private fun open(text: String, drafts: List<TransactionDraft>) {
        when {
            drafts.isEmpty() -> Unit
            drafts.size == 1 -> effectQueue.send(QuickAddEffect.OpenForm(drafts.single()))
            else -> effectQueue.send(QuickAddEffect.OpenReview(text.trim(), drafts))
        }
    }

    private companion object {
        /** The AI's limit on a phrase. */
        const val MAX_TEXT = 300
    }
}

/** The phrase and the drafts read from it, by the phone ([DraftEngine.LOCAL]) or after asking the AI. */
private data class Session(
    val text: String = "",
    val drafts: List<TransactionDraft> = emptyList(),
    /** The text [drafts] were read from; behind [text] until the live parse catches up. */
    val parsedText: String = "",
    val engine: DraftEngine = DraftEngine.LOCAL,
    val isAsking: Boolean = false,
)
