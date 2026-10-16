package com.djtech.monai.feature.transactions.presentation.transactiondetail

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.media.ImageProcessor
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.usecase.AttachReceiptUseCase
import com.djtech.monai.feature.transactions.domain.usecase.DeleteTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionUseCase
import com.djtech.monai.feature.transactions.presentation.common.mapper.loadMessage
import com.djtech.monai.feature.transactions.presentation.common.mapper.toMessage
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

/**
 * One transaction. The cached copy shows at once; it is always refetched because the receipt
 * link the API returns expires after 15 minutes.
 */
@HiltViewModel(assistedFactory = TransactionDetailViewModel.Factory::class)
class TransactionDetailViewModel @AssistedInject constructor(
    @Assisted private val transactionId: String,
    observeTransaction: ObserveTransactionUseCase,
    private val refreshTransaction: RefreshTransactionUseCase,
    private val deleteTransaction: DeleteTransactionUseCase,
    private val attachReceipt: AttachReceiptUseCase,
    private val imageProcessor: ImageProcessor,
    observeCategories: ObserveCategoriesUseCase,
    observeAllWallets: ObserveAllWalletsUseCase,
    private val clock: AppClock,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(transactionId: String): TransactionDetailViewModel
    }

    private val ui = MutableStateFlow(Ui())

    val state: StateFlow<TransactionDetailState> = combine(
        observeTransaction(transactionId),
        combine(observeCategories(), observeAllWallets(), TransactionLookups::of),
        ui,
    ) { transaction, lookups, ui ->
        TransactionDetailState(
            today = clock.today(),
            transaction = transaction,
            lookups = lookups,
            isLoading = transaction == null && ui.isFetching,
            loadError = if (transaction == null) ui.fetchError else null,
            isDeleting = ui.isDeleting,
            isReceiptOpen = ui.isReceiptOpen && transaction?.receiptUrl != null,
            isPhotoSourceOpen = ui.isPhotoSourceOpen,
            receiptUpload = ui.receiptUpload,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, TransactionDetailState(today = clock.today()))

    private val effectQueue = EffectQueue<TransactionDetailEffect>()
    val effects: Flow<TransactionDetailEffect> = effectQueue.flow

    init {
        fetch()
    }

    fun onIntent(intent: TransactionDetailIntent) {
        when (intent) {
            TransactionDetailIntent.Back -> effectQueue.send(TransactionDetailEffect.NavigateBack)
            TransactionDetailIntent.Edit -> effectQueue.send(TransactionDetailEffect.OpenEdit(transactionId))
            TransactionDetailIntent.Delete -> delete()
            TransactionDetailIntent.Retry -> fetch()
            TransactionDetailIntent.OpenReceipt -> ui.update { it.copy(isReceiptOpen = true) }
            TransactionDetailIntent.CloseReceipt -> ui.update { it.copy(isReceiptOpen = false) }
            TransactionDetailIntent.AddReceipt -> if (ui.value.receiptUpload == null) {
                ui.update { it.copy(isPhotoSourceOpen = true) }
            }

            TransactionDetailIntent.TakeReceiptPhoto -> {
                ui.update { it.copy(isPhotoSourceOpen = false) }
                effectQueue.send(TransactionDetailEffect.LaunchCamera(imageProcessor.newCameraUri()))
            }

            TransactionDetailIntent.ChooseReceiptPhoto -> {
                ui.update { it.copy(isPhotoSourceOpen = false) }
                effectQueue.send(TransactionDetailEffect.LaunchGallery)
            }

            TransactionDetailIntent.DismissPhotoSource -> ui.update { it.copy(isPhotoSourceOpen = false) }
            is TransactionDetailIntent.ReceiptPhotoPicked -> intent.uri?.let(::uploadReceipt)
        }
    }

    private fun fetch() {
        if (ui.value.isFetching) return
        ui.update { it.copy(isFetching = true, fetchError = null) }
        viewModelScope.launch {
            val result = refreshTransaction(transactionId)
            val error = (result as? Outcome.Failure)?.error
            ui.update { it.copy(isFetching = false, fetchError = error?.loadMessage()) }
        }
    }

    private fun delete() {
        if (ui.value.isDeleting) return
        ui.update { it.copy(isDeleting = true) }
        viewModelScope.launch {
            val result = deleteTransaction(transactionId)
            ui.update { it.copy(isDeleting = false) }
            when (result) {
                is Outcome.Success -> effectQueue.send(TransactionDetailEffect.NavigateBack)
                is Outcome.Failure -> effectQueue.send(TransactionDetailEffect.ShowMessage(result.error.toMessage()))
            }
        }
    }

    /** Uploads the photo and links it, adding the receipt or replacing the old one. */
    private fun uploadReceipt(uri: String) {
        if (ui.value.receiptUpload != null) return
        ui.update { it.copy(receiptUpload = 0f) }
        viewModelScope.launch {
            attachReceipt(transactionId, uri).collect { step ->
                when (step) {
                    is ReceiptUpload.Progress -> ui.update { it.copy(receiptUpload = step.fraction) }
                    is ReceiptUpload.Done -> {
                        ui.update { it.copy(receiptUpload = null) }
                        val message = when (val result = step.result) {
                            is Outcome.Success -> UiText.Resource(R.string.transaction_detail_receipt_added)
                            is Outcome.Failure -> result.error.toMessage()
                        }
                        effectQueue.send(TransactionDetailEffect.ShowMessage(message))
                    }
                }
            }
        }
    }

    private data class Ui(
        val isFetching: Boolean = false,
        val fetchError: UiText? = null,
        val isDeleting: Boolean = false,
        val isReceiptOpen: Boolean = false,
        val isPhotoSourceOpen: Boolean = false,
        val receiptUpload: Float? = null,
    )
}
