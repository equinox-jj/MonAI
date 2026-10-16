package com.djtech.monai.feature.receipt.presentation.receiptreview

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.model.ReceiptItem
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.categoryType
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.quickadd.domain.usecase.SuggestCategoryUseCase
import com.djtech.monai.feature.receipt.presentation.receiptreview.model.ReceiptSheet
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.usecase.CreateTransactionWithReceiptUseCase
import com.djtech.monai.feature.transactions.domain.validation.MAX_NOTE_LENGTH
import com.djtech.monai.feature.transactions.presentation.common.mapper.toFieldMessages
import com.djtech.monai.feature.transactions.presentation.common.mapper.toHighlights
import com.djtech.monai.feature.transactions.presentation.common.mapper.toMessage
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.drop
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.YearMonth

/**
 * Checks a scanned receipt's draft and saves it with the photo (uploaded on save). AI-filled
 * fields are marked; editing the merchant suggests a category until the user picks one.
 */
@OptIn(FlowPreview::class)
@HiltViewModel(assistedFactory = ReceiptReviewViewModel.Factory::class)
class ReceiptReviewViewModel @AssistedInject constructor(
    @Assisted private val photoUri: String,
    @Assisted receipt: ReceiptDraft,
    @Assisted private val aiFailed: Boolean,
    private val createTransactionWithReceipt: CreateTransactionWithReceiptUseCase,
    private val suggestCategory: SuggestCategoryUseCase,
    observeWallets: ObserveWalletsUseCase,
    observeCategories: ObserveCategoriesUseCase,
    private val clock: AppClock,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(photoUri: String, receipt: ReceiptDraft, aiFailed: Boolean): ReceiptReviewViewModel
    }

    private val editor = MutableStateFlow(Editor.from(receipt, aiFailed, clock.today()))

    val state: StateFlow<ReceiptReviewState> = combine(
        editor,
        observeWallets(),
        observeCategories(),
    ) { editor, wallets, categories ->
        val walletId = editor.walletId ?: wallets.defaultWallet()?.id
        val categoryType = editor.type.categoryType()
        ReceiptReviewState(
            today = clock.today(),
            photoUri = photoUri,
            aiFailed = aiFailed,
            type = editor.type,
            amount = editor.amount,
            merchant = editor.merchant,
            merchantFromAi = editor.merchantFromAi,
            note = editor.note,
            category = categories.find { it.id == editor.categoryId },
            walletId = walletId,
            walletName = wallets.find { it.id == walletId }?.name,
            date = editor.date,
            items = editor.items,
            highlights = editor.highlights,
            categories = categories.filter { it.type == categoryType && !it.isHidden },
            wallets = wallets,
            errors = editor.errors,
            sheet = editor.sheet,
            isSaving = editor.isSaving,
            uploadProgress = editor.uploadProgress,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, ReceiptReviewState(today = clock.today(), photoUri = photoUri))

    private val effectQueue = EffectQueue<ReceiptReviewEffect>()
    val effects: Flow<ReceiptReviewEffect> = effectQueue.flow

    init {
        suggestCategoriesFromMerchant()
    }

    fun onIntent(intent: ReceiptReviewIntent) {
        when (intent) {
            is ReceiptReviewIntent.SelectType -> selectType(intent.type)
            ReceiptReviewIntent.OpenAmount -> openSheet(ReceiptSheet.Amount(editor.value.amount ?: 0))
            ReceiptReviewIntent.OpenCategory -> openSheet(ReceiptSheet.Category(editor.value.categoryId))
            ReceiptReviewIntent.OpenWallet -> openSheet(ReceiptSheet.Wallet(state.value.walletId))
            ReceiptReviewIntent.OpenDate -> editor.value.date.let {
                openSheet(ReceiptSheet.Date(it, YearMonth.from(it)))
            }

            is ReceiptReviewIntent.SheetAmount -> updateSheet<ReceiptSheet.Amount> { it.copy(amount = intent.amount) }
            is ReceiptReviewIntent.SheetPickCategory -> updateSheet<ReceiptSheet.Category> {
                it.copy(selectedId = intent.id)
            }

            is ReceiptReviewIntent.SheetPickWallet -> updateSheet<ReceiptSheet.Wallet> {
                it.copy(selectedId = intent.id)
            }

            is ReceiptReviewIntent.SheetPickDate -> updateSheet<ReceiptSheet.Date> {
                if (intent.date.isAfter(clock.today())) it else it.copy(selected = intent.date)
            }

            is ReceiptReviewIntent.SheetShowMonth -> updateSheet<ReceiptSheet.Date> {
                it.copy(shownMonth = minOf(intent.month, clock.currentMonth()))
            }

            ReceiptReviewIntent.ConfirmSheet -> confirmSheet()
            ReceiptReviewIntent.DismissSheet -> editor.update { it.copy(sheet = null) }
            is ReceiptReviewIntent.MerchantChanged -> editor.update {
                it.copy(merchant = intent.merchant.take(MAX_MERCHANT_LENGTH), merchantFromAi = false)
            }

            is ReceiptReviewIntent.NoteChanged -> edit(TransactionField.NOTE) {
                it.copy(note = intent.note.take(MAX_NOTE_LENGTH))
            }

            ReceiptReviewIntent.Save -> save()
            ReceiptReviewIntent.Retake -> effectQueue.send(ReceiptReviewEffect.Retake)
            ReceiptReviewIntent.Back -> effectQueue.send(ReceiptReviewEffect.Back)
        }
    }

    private fun selectType(type: TransactionType) {
        if (type == TransactionType.TRANSFER || type == editor.value.type) return
        // The category list follows the type, so a category of the old type can't stay.
        editor.update {
            it.copy(
                type = type,
                categoryId = null,
                categoryChosen = false,
                highlights = it.highlights - TransactionField.CATEGORY,
                errors = it.errors - TransactionField.CATEGORY,
            )
        }
    }

    private fun openSheet(sheet: ReceiptSheet) = editor.update { it.copy(sheet = sheet) }

    private inline fun <reified T : ReceiptSheet> updateSheet(crossinline update: (T) -> ReceiptSheet) {
        editor.update { editor -> (editor.sheet as? T)?.let { editor.copy(sheet = update(it)) } ?: editor }
    }

    /** A changed field loses its error and its AI mark. */
    private fun edit(field: TransactionField, change: (Editor) -> Editor) {
        editor.update { change(it).copy(errors = it.errors - field, highlights = it.highlights - field) }
    }

    private fun confirmSheet() {
        when (val sheet = editor.value.sheet) {
            is ReceiptSheet.Amount -> edit(TransactionField.AMOUNT) { it.copy(amount = sheet.amount) }
            is ReceiptSheet.Category -> sheet.selectedId?.let { id ->
                edit(TransactionField.CATEGORY) { it.copy(categoryId = id, categoryChosen = true) }
            }

            is ReceiptSheet.Wallet -> sheet.selectedId?.let { id ->
                edit(TransactionField.WALLET) { it.copy(walletId = id) }
            }

            is ReceiptSheet.Date -> edit(TransactionField.DATE) { it.copy(date = sheet.selected) }
            null -> Unit
        }
        editor.update { it.copy(sheet = null) }
    }

    private fun save() {
        val current = editor.value
        if (current.isSaving) return
        val input = TransactionInput(
            type = current.type,
            amount = current.amount ?: 0,
            walletId = state.value.walletId,
            toWalletId = null,
            categoryId = current.categoryId,
            date = current.date,
            note = current.note,
            merchant = current.merchant,
            source = TransactionSource.RECEIPT,
        )
        editor.update { it.copy(isSaving = true) }
        viewModelScope.launch {
            createTransactionWithReceipt(input, photoUri).collect { step ->
                when (step) {
                    is ReceiptUpload.Progress -> editor.update { it.copy(uploadProgress = step.fraction) }
                    is ReceiptUpload.Done -> {
                        editor.update { it.copy(isSaving = false, uploadProgress = null) }
                        when (val result = step.result) {
                            is Outcome.Success -> effectQueue.send(ReceiptReviewEffect.Saved(result.data.id))
                            is Outcome.Failure -> when (val error = result.error) {
                                is TransactionError.InvalidFields -> editor.update {
                                    it.copy(errors = error.errors.toFieldMessages())
                                }

                                else -> effectQueue.send(ReceiptReviewEffect.ShowMessage(error.toMessage()))
                            }
                        }
                    }
                }
            }
        }
    }

    /** Auto-categorization from the merchant, after typing pauses, until a category is picked. */
    private fun suggestCategoriesFromMerchant() {
        viewModelScope.launch {
            editor
                .map { it.merchant.trim() }
                .distinctUntilChanged()
                .drop(1)
                .debounce(SUGGEST_DELAY_MS)
                .collectLatest { merchant ->
                    val current = editor.value
                    if (merchant.isEmpty() || current.categoryChosen) return@collectLatest
                    val type = current.type
                    val id = suggestCategory(merchant, type, state.value.categories) ?: return@collectLatest
                    editor.update {
                        if (it.categoryChosen || it.type != type) return@update it
                        it.copy(
                            categoryId = id,
                            errors = it.errors - TransactionField.CATEGORY,
                            highlights = it.highlights + (TransactionField.CATEGORY to FieldHighlight.Ai),
                        )
                    }
                }
        }
    }

    private companion object {
        const val SUGGEST_DELAY_MS = 600L

        /** The API's limit. */
        const val MAX_MERCHANT_LENGTH = 100
    }
}

private data class Editor(
    val type: TransactionType,
    val amount: Long?,
    val merchant: String,
    val merchantFromAi: Boolean,
    val note: String,
    val categoryId: String?,
    /** The user or a sure AI picked the category, so merchant suggestions stop. */
    val categoryChosen: Boolean,
    val walletId: String?,
    val date: LocalDate,
    val items: List<ReceiptItem>,
    val highlights: Map<TransactionField, FieldHighlight>,
    val errors: Map<TransactionField, UiText> = emptyMap(),
    val sheet: ReceiptSheet? = null,
    val isSaving: Boolean = false,
    val uploadProgress: Float? = null,
) {
    companion object {
        fun from(receipt: ReceiptDraft, aiFailed: Boolean, today: LocalDate): Editor {
            val draft = receipt.draft
            // A receipt rarely names the wallet; the default one is used without a warning then.
            val highlights = if (aiFailed) {
                emptyMap()
            } else {
                draft.toHighlights().let { if (draft.walletId == null) it - TransactionField.WALLET else it }
            }
            return Editor(
                type = if (draft.type == TransactionType.INCOME) TransactionType.INCOME else TransactionType.EXPENSE,
                amount = draft.amount,
                merchant = draft.merchant.orEmpty(),
                merchantFromAi = draft.merchant != null,
                note = draft.note.orEmpty(),
                categoryId = draft.categoryId,
                categoryChosen = highlights[TransactionField.CATEGORY] == FieldHighlight.Ai,
                walletId = draft.walletId,
                date = draft.date?.takeIf { !it.isAfter(today) } ?: today,
                items = receipt.items,
                highlights = highlights,
            )
        }
    }
}

private fun List<Wallet>.defaultWallet(): Wallet? = firstOrNull(Wallet::isDefault) ?: firstOrNull()
