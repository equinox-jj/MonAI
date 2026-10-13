package com.djtech.monai.feature.quickadd.presentation.quickaddreview

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.categoryType
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.mapper.toReviewDraft
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.mapper.toSummaryRow
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewDraft
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewOutcome
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSheet
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewWalletTarget
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.usecase.CreateTransactionUseCase
import com.djtech.monai.feature.transactions.domain.validation.MAX_NOTE_LENGTH
import com.djtech.monai.feature.transactions.presentation.common.mapper.toFieldMessages
import com.djtech.monai.feature.transactions.presentation.common.mapper.toMessage
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.time.YearMonth

/**
 * Steps through the drafts of one quick-add phrase. Each is saved as a quick add (validated like
 * the add form) or skipped; after the last one the screen sums up what was saved.
 */
@HiltViewModel(assistedFactory = QuickAddReviewViewModel.Factory::class)
class QuickAddReviewViewModel @AssistedInject constructor(
    @Assisted private val phrase: String,
    @Assisted drafts: List<TransactionDraft>,
    private val createTransaction: CreateTransactionUseCase,
    observeWallets: ObserveWalletsUseCase,
    observeCategories: ObserveCategoriesUseCase,
    private val clock: AppClock,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(phrase: String, drafts: List<TransactionDraft>): QuickAddReviewViewModel
    }

    private val editor = MutableStateFlow(Editor(drafts.map { it.toReviewDraft(clock.today()) }))

    val state: StateFlow<QuickAddReviewState> = combine(
        editor,
        observeWallets(),
        observeCategories(),
    ) { editor, wallets, categories ->
        val draft = editor.drafts.getOrNull(editor.index)
        val sourceId = draft?.walletId ?: wallets.defaultWallet()?.id
        QuickAddReviewState(
            today = clock.today(),
            phrase = phrase,
            total = editor.drafts.size,
            index = editor.index,
            draft = draft?.copy(walletId = sourceId),
            category = categories.find { it.id == draft?.categoryId },
            walletName = wallets.find { it.id == sourceId }?.name,
            toWalletName = wallets.find { it.id == draft?.toWalletId }?.name,
            categories = draft?.type?.categoryType()
                ?.let { type -> categories.filter { it.type == type && !it.isHidden } }
                .orEmpty(),
            wallets = wallets,
            errors = editor.errors,
            sheet = editor.sheet,
            isSaving = editor.isSaving,
            summary = editor.outcomes.mapIndexed { index, outcome ->
                editor.drafts[index].toSummaryRow(outcome, categories, wallets)
            },
        )
    }.stateIn(
        viewModelScope,
        WhileUiSubscribed,
        QuickAddReviewState(today = clock.today(), phrase = phrase, total = drafts.size),
    )

    private val effectChannel = Channel<QuickAddReviewEffect>(Channel.BUFFERED)
    val effects: Flow<QuickAddReviewEffect> = effectChannel.receiveAsFlow()

    fun onIntent(intent: QuickAddReviewIntent) {
        when (intent) {
            QuickAddReviewIntent.OpenAmount -> current()?.let { openSheet(ReviewSheet.Amount(it.amount ?: 0)) }
            QuickAddReviewIntent.OpenCategory -> current()?.let { openSheet(ReviewSheet.Category(it.categoryId)) }
            is QuickAddReviewIntent.OpenWallet -> current()?.let {
                val selected = when (intent.target) {
                    ReviewWalletTarget.SOURCE -> state.value.draft?.walletId
                    ReviewWalletTarget.DESTINATION -> it.toWalletId
                }
                openSheet(ReviewSheet.Wallet(intent.target, selected))
            }

            QuickAddReviewIntent.OpenDate -> current()?.let {
                openSheet(ReviewSheet.Date(it.date, YearMonth.from(it.date)))
            }

            is QuickAddReviewIntent.SheetAmount -> updateSheet<ReviewSheet.Amount> { it.copy(amount = intent.amount) }
            is QuickAddReviewIntent.SheetPickCategory -> updateSheet<ReviewSheet.Category> {
                it.copy(selectedId = intent.id)
            }

            is QuickAddReviewIntent.SheetPickWallet -> updateSheet<ReviewSheet.Wallet> {
                it.copy(selectedId = intent.id)
            }

            is QuickAddReviewIntent.SheetPickDate -> updateSheet<ReviewSheet.Date> {
                if (intent.date.isAfter(clock.today())) it else it.copy(selected = intent.date)
            }

            is QuickAddReviewIntent.SheetShowMonth -> updateSheet<ReviewSheet.Date> {
                it.copy(shownMonth = minOf(intent.month, clock.currentMonth()))
            }

            QuickAddReviewIntent.ConfirmSheet -> confirmSheet()
            QuickAddReviewIntent.DismissSheet -> editor.update { it.copy(sheet = null) }
            is QuickAddReviewIntent.NoteChanged -> editDraft(TransactionField.NOTE) {
                it.copy(note = intent.note.take(MAX_NOTE_LENGTH))
            }

            QuickAddReviewIntent.Save -> save()
            QuickAddReviewIntent.Skip -> pass(ReviewOutcome.SKIPPED)
            QuickAddReviewIntent.Back -> send(QuickAddReviewEffect.Back)
            QuickAddReviewIntent.Finish -> send(QuickAddReviewEffect.Finish)
        }
    }

    private fun current(): ReviewDraft? = editor.value.let { it.drafts.getOrNull(it.index) }

    private fun openSheet(sheet: ReviewSheet) = editor.update { it.copy(sheet = sheet) }

    private inline fun <reified T : ReviewSheet> updateSheet(crossinline update: (T) -> ReviewSheet) {
        editor.update { editor -> (editor.sheet as? T)?.let { editor.copy(sheet = update(it)) } ?: editor }
    }

    /** Edits the draft on screen; a changed field loses its error and its highlight. */
    private fun editDraft(field: TransactionField, edit: (ReviewDraft) -> ReviewDraft) {
        editor.update { editor ->
            val draft = editor.drafts.getOrNull(editor.index) ?: return@update editor
            val edited = edit(draft).let { it.copy(highlights = it.highlights - field) }
            editor.copy(
                drafts = editor.drafts.toMutableList().apply { set(editor.index, edited) },
                errors = editor.errors - field,
            )
        }
    }

    private fun confirmSheet() {
        when (val sheet = editor.value.sheet) {
            is ReviewSheet.Amount -> editDraft(TransactionField.AMOUNT) { it.copy(amount = sheet.amount) }
            is ReviewSheet.Category -> sheet.selectedId?.let { id ->
                editDraft(TransactionField.CATEGORY) { it.copy(categoryId = id) }
            }

            is ReviewSheet.Wallet -> sheet.selectedId?.let { id ->
                when (sheet.target) {
                    ReviewWalletTarget.SOURCE -> editDraft(TransactionField.WALLET) { it.copy(walletId = id) }
                    ReviewWalletTarget.DESTINATION -> editDraft(TransactionField.TO_WALLET) {
                        it.copy(toWalletId = id)
                    }
                }
            }

            is ReviewSheet.Date -> editDraft(TransactionField.DATE) { it.copy(date = sheet.selected) }
            null -> Unit
        }
        editor.update { it.copy(sheet = null) }
    }

    private fun save() {
        val current = editor.value
        val draft = current.drafts.getOrNull(current.index) ?: return
        if (current.isSaving) return
        val input = TransactionInput(
            type = draft.type,
            amount = draft.amount ?: 0,
            walletId = state.value.draft?.walletId ?: draft.walletId,
            toWalletId = draft.toWalletId,
            categoryId = draft.categoryId,
            date = draft.date,
            note = draft.note,
            source = TransactionSource.QUICK_ADD,
        )
        editor.update { it.copy(isSaving = true) }
        viewModelScope.launch {
            val result = createTransaction(input)
            editor.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> pass(ReviewOutcome.SAVED, savedWalletId = input.walletId)
                is Outcome.Failure -> when (val error = result.error) {
                    is TransactionError.InvalidFields -> editor.update {
                        it.copy(errors = error.errors.toFieldMessages())
                    }

                    else -> send(QuickAddReviewEffect.ShowMessage(error.toMessage()))
                }
            }
        }
    }

    /** Records [outcome] for the draft on screen and moves to the next one, or the summary. */
    private fun pass(outcome: ReviewOutcome, savedWalletId: String? = null) {
        editor.update { editor ->
            if (editor.index >= editor.drafts.size) return@update editor
            // The summary names the wallet it was saved to, the default one included.
            val drafts = if (savedWalletId == null) {
                editor.drafts
            } else {
                editor.drafts.toMutableList().apply {
                    set(editor.index, this[editor.index].copy(walletId = savedWalletId))
                }
            }
            editor.copy(
                drafts = drafts,
                index = editor.index + 1,
                outcomes = editor.outcomes + outcome,
                errors = emptyMap(),
                sheet = null,
            )
        }
    }

    private fun send(effect: QuickAddReviewEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

private data class Editor(
    val drafts: List<ReviewDraft>,
    val index: Int = 0,
    val outcomes: List<ReviewOutcome> = emptyList(),
    val errors: Map<TransactionField, UiText> = emptyMap(),
    val sheet: ReviewSheet? = null,
    val isSaving: Boolean = false,
)

private fun List<Wallet>.defaultWallet(): Wallet? = firstOrNull(Wallet::isDefault) ?: firstOrNull()
