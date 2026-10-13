package com.djtech.monai.feature.transactions.presentation.transactionform

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.flow.WhileUiSubscribed
import com.djtech.monai.core.common.format.appendDigit
import com.djtech.monai.core.common.format.deleteDigit
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.categoryType
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveCreatedCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveVisibleCategoriesUseCase
import com.djtech.monai.feature.quickadd.domain.usecase.SuggestCategoryUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.usecase.CreateTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.DeleteTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.UpdateTransactionUseCase
import com.djtech.monai.feature.transactions.domain.validation.MAX_NOTE_LENGTH
import com.djtech.monai.feature.transactions.presentation.common.mapper.toFieldMessages
import com.djtech.monai.feature.transactions.presentation.common.mapper.toHighlights
import com.djtech.monai.feature.transactions.presentation.common.mapper.toMessage
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import com.djtech.monai.feature.transactions.presentation.transactionform.model.FormSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormMode
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormPreset
import com.djtech.monai.feature.transactions.presentation.transactionform.model.WalletTarget
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.drop
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.YearMonth

/**
 * Adds a transaction ([transactionId] null) or edits one. The keypad, type tabs and pickers edit a
 * draft; saving validates it in the use case and maps any field errors back onto the form. A new
 * transaction can start from a quick-add draft, and gets its category suggested from the note
 * until the user picks one.
 */
@OptIn(ExperimentalCoroutinesApi::class, FlowPreview::class)
@HiltViewModel(assistedFactory = TransactionFormViewModel.Factory::class)
class TransactionFormViewModel @AssistedInject constructor(
    @Assisted private val transactionId: String?,
    @Assisted private val preset: TransactionFormPreset,
    private val observeTransaction: ObserveTransactionUseCase,
    private val refreshTransaction: RefreshTransactionUseCase,
    private val createTransaction: CreateTransactionUseCase,
    private val updateTransaction: UpdateTransactionUseCase,
    private val deleteTransaction: DeleteTransactionUseCase,
    observeWallets: ObserveWalletsUseCase,
    observeAllWallets: ObserveAllWalletsUseCase,
    observeCategories: ObserveCategoriesUseCase,
    private val observeVisibleCategories: ObserveVisibleCategoriesUseCase,
    private val observeCreatedCategories: ObserveCreatedCategoriesUseCase,
    private val suggestCategory: SuggestCategoryUseCase,
    private val clock: AppClock,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(transactionId: String?, preset: TransactionFormPreset): TransactionFormViewModel
    }

    private val mode: TransactionFormMode =
        transactionId?.let(TransactionFormMode::Edit) ?: TransactionFormMode.Add
    private val editor = MutableStateFlow(
        newDraft().let { draft ->
            val highlights = preset.draft?.takeIf { transactionId == null }?.toHighlights().orEmpty()
            Editor(
                draft = draft,
                pristine = draft,
                isLoading = transactionId != null,
                highlights = highlights,
                // A sure drafted category counts as chosen, so the note doesn't override it.
                categoryChosen = highlights[TransactionField.CATEGORY] == FieldHighlight.Ai,
            )
        },
    )

    private val categories: Flow<List<Category>> = editor
        .map { it.draft.type }
        .distinctUntilChanged()
        .flatMapLatest { type -> type.categoryType()?.let { observeVisibleCategories(it) } ?: flowOf(emptyList()) }

    private val activeWallets = observeWallets()

    val state: StateFlow<TransactionFormState> = combine(
        editor,
        categories,
        activeWallets,
        combine(observeCategories(), observeAllWallets(), TransactionLookups::of),
    ) { editor, categories, wallets, lookups ->
        val draft = editor.draft
        TransactionFormState(
            mode = mode,
            today = clock.today(),
            date = draft.date,
            isLoading = editor.isLoading,
            loadError = editor.loadError,
            type = draft.type,
            amount = draft.amount,
            originalAmount = editor.original?.amount,
            walletId = draft.walletId ?: wallets.defaultWallet()?.id,
            toWalletId = draft.toWalletId,
            categoryId = draft.categoryId,
            note = draft.note,
            categories = categories,
            wallets = wallets,
            lookups = lookups,
            errors = editor.errors,
            highlights = editor.highlights,
            sheet = editor.sheet,
            isSaving = editor.isSaving,
            isDeleting = editor.isDeleting,
            showDiscardDialog = editor.showDiscardDialog,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, TransactionFormState(mode = mode, today = clock.today()))

    private val effectChannel = Channel<TransactionFormEffect>(Channel.BUFFERED)
    val effects: Flow<TransactionFormEffect> = effectChannel.receiveAsFlow()

    init {
        if (transactionId != null) {
            load(transactionId)
        } else if (preset.type == TransactionType.TRANSFER) {
            prefillDestination()
        }
        selectCreatedCategories()
        if (transactionId == null) suggestCategoriesFromNote()
    }

    fun onIntent(intent: TransactionFormIntent) {
        when (intent) {
            is TransactionFormIntent.SelectType -> selectType(intent.type)
            is TransactionFormIntent.Digit -> editAmount { appendDigit(it, intent.digit) }
            TransactionFormIntent.TripleZero -> editAmount { appendDigit(appendDigit(appendDigit(it, 0), 0), 0) }
            TransactionFormIntent.Backspace -> editAmount(::deleteDigit)
            is TransactionFormIntent.PickCategory -> {
                editDraft(TransactionField.CATEGORY) { it.copy(categoryId = intent.id) }
                editor.update { it.copy(categoryChosen = true) }
            }

            is TransactionFormIntent.NoteChanged -> editDraft(TransactionField.NOTE) {
                it.copy(note = intent.note.take(MAX_NOTE_LENGTH))
            }

            TransactionFormIntent.OpenCategoryPicker -> openSheet(FormSheet.Category(editor.value.draft.categoryId))
            is TransactionFormIntent.OpenWalletPicker -> openSheet(
                FormSheet.Wallet(
                    intent.target,
                    if (intent.target == WalletTarget.SOURCE) sourceWalletId() else editor.value.draft.toWalletId,
                ),
            )

            TransactionFormIntent.OpenDatePicker -> {
                val date = editor.value.draft.date
                openSheet(FormSheet.Date(date, YearMonth.from(date)))
            }

            is TransactionFormIntent.SheetPickCategory -> updateSheet<FormSheet.Category> {
                it.copy(selectedId = intent.id)
            }

            TransactionFormIntent.NewCategory ->
                editor.value.draft.type.categoryType()?.let { send(TransactionFormEffect.OpenNewCategory(it)) }

            is TransactionFormIntent.SheetPickWallet -> updateSheet<FormSheet.Wallet> {
                it.copy(selectedId = intent.id)
            }

            is TransactionFormIntent.SheetPickDate -> updateSheet<FormSheet.Date> {
                if (intent.date.isAfter(clock.today())) it else it.copy(selected = intent.date)
            }

            is TransactionFormIntent.SheetShowMonth -> updateSheet<FormSheet.Date> {
                it.copy(shownMonth = minOf(intent.month, clock.currentMonth()))
            }

            TransactionFormIntent.ConfirmSheet -> confirmSheet()
            TransactionFormIntent.DismissSheet -> editor.update { it.copy(sheet = null) }
            TransactionFormIntent.Save -> save()
            TransactionFormIntent.Close -> close()
            TransactionFormIntent.ConfirmDiscard -> {
                editor.update { it.copy(showDiscardDialog = false) }
                send(TransactionFormEffect.Close)
            }

            TransactionFormIntent.KeepEditing -> editor.update { it.copy(showDiscardDialog = false) }
            TransactionFormIntent.Delete -> delete()
            TransactionFormIntent.Retry -> transactionId?.let(::load)
            TransactionFormIntent.Scan -> send(TransactionFormEffect.OpenScan)
        }
    }

    private fun load(id: String) {
        editor.update { it.copy(isLoading = true, loadError = null) }
        viewModelScope.launch {
            val cached = observeTransaction(id).first()
            val transaction = cached ?: run {
                val result = refreshTransaction(id)
                if (result is Outcome.Failure) {
                    editor.update { it.copy(isLoading = false, loadError = result.error.loadMessage()) }
                    return@launch
                }
                observeTransaction(id).firstOrNull()
            }
            if (transaction == null) {
                editor.update { it.copy(isLoading = false, loadError = TransactionError.NotFound.toMessage()) }
                return@launch
            }
            val draft = transaction.toDraft()
            editor.update { it.copy(draft = draft, original = draft, isLoading = false) }
        }
    }

    private fun selectType(type: TransactionType) {
        val current = state.value
        editor.update { editor ->
            val draft = editor.draft
            if (draft.type == type) return@update editor
            // The category list follows the type, so a category of the old type can't stay.
            val keepsCategory = draft.categoryId?.let { current.lookups.category(it)?.type } == type.categoryType()
            // A transfer starts out to the first other wallet.
            val source = draft.walletId ?: current.wallets.defaultWallet()?.id
            val destination = draft.toWalletId ?: current.wallets
                .firstOrNull { it.id != source }?.id
                .takeIf { type == TransactionType.TRANSFER }
            editor.copy(
                draft = draft.copy(
                    type = type,
                    categoryId = draft.categoryId.takeIf { keepsCategory },
                    toWalletId = destination,
                ),
                errors = editor.errors - TransactionField.CATEGORY - TransactionField.TO_WALLET,
                highlights = editor.highlights - TransactionField.CATEGORY - TransactionField.TO_WALLET,
                categoryChosen = editor.categoryChosen && keepsCategory,
            )
        }
    }

    private fun editAmount(edit: (Long) -> Long) =
        editDraft(TransactionField.AMOUNT) { it.copy(amount = edit(it.amount)) }

    private fun editDraft(field: TransactionField, edit: (Draft) -> Draft) {
        editor.update {
            it.copy(draft = edit(it.draft), errors = it.errors - field, highlights = it.highlights - field)
        }
    }

    private fun openSheet(sheet: FormSheet) = editor.update { it.copy(sheet = sheet) }

    private inline fun <reified T : FormSheet> updateSheet(crossinline update: (T) -> FormSheet) {
        editor.update { editor -> (editor.sheet as? T)?.let { editor.copy(sheet = update(it)) } ?: editor }
    }

    private fun confirmSheet() {
        when (val sheet = editor.value.sheet) {
            is FormSheet.Category -> sheet.selectedId?.let { id ->
                editDraft(TransactionField.CATEGORY) { it.copy(categoryId = id) }
                editor.update { it.copy(categoryChosen = true) }
            }

            is FormSheet.Wallet -> sheet.selectedId?.let { id ->
                when (sheet.target) {
                    WalletTarget.SOURCE -> editDraft(TransactionField.WALLET) { it.copy(walletId = id) }
                    WalletTarget.DESTINATION -> editDraft(TransactionField.TO_WALLET) { it.copy(toWalletId = id) }
                }
            }

            is FormSheet.Date -> editDraft(TransactionField.DATE) { it.copy(date = sheet.selected) }
            null -> Unit
        }
        editor.update { it.copy(sheet = null) }
    }

    private fun save() {
        // Read from the editor, not [state], which can be a tap behind.
        val current = editor.value
        if (current.isSaving || current.isLoading || current.loadError != null) return
        val draft = current.draft
        val input = TransactionInput(
            type = draft.type,
            amount = draft.amount,
            walletId = sourceWalletId(),
            toWalletId = draft.toWalletId,
            categoryId = draft.categoryId,
            date = draft.date,
            note = draft.note,
            merchant = draft.merchant,
            source = if (preset.draft != null) TransactionSource.QUICK_ADD else TransactionSource.MANUAL,
        )
        editor.update { it.copy(isSaving = true) }
        viewModelScope.launch {
            val result = if (transactionId == null) {
                createTransaction(input)
            } else {
                updateTransaction(transactionId, input)
            }
            editor.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> send(TransactionFormEffect.Saved(result.data.id))
                is Outcome.Failure -> when (val error = result.error) {
                    is TransactionError.InvalidFields -> editor.update {
                        it.copy(errors = error.errors.toFieldMessages())
                    }

                    else -> send(TransactionFormEffect.ShowMessage(error.toMessage()))
                }
            }
        }
    }

    /** The preset's quick-add draft, else its type and wallet (null: the default one). */
    private fun newDraft(): Draft {
        val draft = preset.draft ?: return Draft(type = preset.type, walletId = preset.walletId, date = clock.today())
        return Draft(
            type = draft.type ?: TransactionType.EXPENSE,
            amount = draft.amount ?: 0,
            walletId = draft.walletId,
            toWalletId = draft.toWalletId,
            categoryId = draft.categoryId,
            date = draft.date?.takeIf { !it.isAfter(clock.today()) } ?: clock.today(),
            note = draft.note.orEmpty(),
            merchant = draft.merchant,
        )
    }

    /**
     * Auto-categorization: once the note rests for a moment, picks the category the user's history,
     * the keywords or the AI suggest, until the user picks one themselves.
     */
    private fun suggestCategoriesFromNote() {
        viewModelScope.launch {
            editor
                .map { it.draft.note.trim() }
                .distinctUntilChanged()
                .drop(1)
                .debounce(SUGGEST_DELAY_MS)
                .collectLatest { note ->
                    val current = editor.value
                    val type = current.draft.type
                    val skip = note.isEmpty() || current.categoryChosen || type == TransactionType.TRANSFER
                    if (skip) return@collectLatest
                    val categories = state.value.categories
                    val id = suggestCategory(note, type, categories) ?: return@collectLatest
                    editor.update { editor ->
                        if (editor.categoryChosen || editor.draft.type != type) return@update editor
                        editor.copy(
                            draft = editor.draft.copy(categoryId = id),
                            errors = editor.errors - TransactionField.CATEGORY,
                            highlights = editor.highlights + (TransactionField.CATEGORY to FieldHighlight.Ai),
                        )
                    }
                }
        }
    }

    // A preset transfer starts out to the first other wallet, as picking the Transfer tab does. It still
    // counts as untouched, so closing right away doesn't ask to discard.
    private fun prefillDestination() {
        viewModelScope.launch {
            val wallets = activeWallets.first()
            editor.update { editor ->
                val draft = editor.draft
                if (draft.toWalletId != null) return@update editor
                val source = draft.walletId ?: wallets.defaultWallet()?.id
                val prefilled = draft.copy(toWalletId = wallets.firstOrNull { it.id != source }?.id)
                editor.copy(draft = prefilled, pristine = if (draft == editor.pristine) prefilled else editor.pristine)
            }
        }
    }

    private fun sourceWalletId(): String? = editor.value.draft.walletId ?: state.value.wallets.defaultWallet()?.id

    private fun close() {
        val editor = editor.value
        val initial = editor.original ?: editor.pristine
        if (editor.draft != initial && !editor.isLoading) {
            this.editor.update { it.copy(showDiscardDialog = true) }
        } else {
            send(TransactionFormEffect.Close)
        }
    }

    private fun delete() {
        val id = transactionId ?: return
        if (editor.value.isDeleting) return
        editor.update { it.copy(isDeleting = true) }
        viewModelScope.launch {
            val result = deleteTransaction(id)
            editor.update { it.copy(isDeleting = false) }
            when (result) {
                is Outcome.Success -> send(TransactionFormEffect.Deleted(id))
                is Outcome.Failure -> send(TransactionFormEffect.ShowMessage(result.error.toMessage()))
            }
        }
    }

    /** A category made from the picker's "New" tile comes back selected in the still-open picker. */
    private fun selectCreatedCategories() {
        viewModelScope.launch {
            observeCreatedCategories().collect { category ->
                if (category.type == editor.value.draft.type.categoryType()) {
                    updateSheet<FormSheet.Category> { it.copy(selectedId = category.id) }
                }
            }
        }
    }

    private fun send(effect: TransactionFormEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

/** What the user has entered. A null [walletId] means the default wallet. */
private data class Draft(
    val type: TransactionType = TransactionType.EXPENSE,
    val amount: Long = 0,
    val walletId: String? = null,
    val toWalletId: String? = null,
    val categoryId: String? = null,
    val date: LocalDate,
    val note: String = "",
    /** Kept from the edited transaction: the form doesn't edit it, and a save sends every field. */
    val merchant: String? = null,
)

/**
 * [original] is the transaction being edited, and [pristine] the draft a new one started from;
 * both tell whether anything changed.
 */
private data class Editor(
    val draft: Draft,
    val pristine: Draft,
    val original: Draft? = null,
    val isLoading: Boolean = false,
    val loadError: UiText? = null,
    val errors: Map<TransactionField, UiText> = emptyMap(),
    val sheet: FormSheet? = null,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val showDiscardDialog: Boolean = false,
    val highlights: Map<TransactionField, FieldHighlight> = emptyMap(),
    /** The user picked the category, so note suggestions stop. */
    val categoryChosen: Boolean = false,
)

private fun Transaction.toDraft() = Draft(
    type = type,
    amount = amount,
    walletId = walletId,
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = date,
    note = note.orEmpty(),
    merchant = merchant,
)

private const val SUGGEST_DELAY_MS = 600L

private fun List<Wallet>.defaultWallet(): Wallet? = firstOrNull(Wallet::isDefault) ?: firstOrNull()

private fun TransactionError.loadMessage(): UiText = when (this) {
    TransactionError.Network -> UiText.Resource(R.string.transactions_load_failed_network)
    else -> toMessage()
}
