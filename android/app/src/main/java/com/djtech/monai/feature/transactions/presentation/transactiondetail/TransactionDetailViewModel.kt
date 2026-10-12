package com.djtech.monai.feature.transactions.presentation.transactiondetail

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.flow.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.usecase.DeleteTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionUseCase
import com.djtech.monai.feature.transactions.presentation.common.mapper.toMessage
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
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
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, TransactionDetailState(today = clock.today()))

    private val effectChannel = Channel<TransactionDetailEffect>(Channel.BUFFERED)
    val effects: Flow<TransactionDetailEffect> = effectChannel.receiveAsFlow()

    init {
        fetch()
    }

    fun onIntent(intent: TransactionDetailIntent) {
        when (intent) {
            TransactionDetailIntent.Back -> send(TransactionDetailEffect.NavigateBack)
            TransactionDetailIntent.Edit -> send(TransactionDetailEffect.OpenEdit(transactionId))
            TransactionDetailIntent.Delete -> delete()
            TransactionDetailIntent.Retry -> fetch()
            TransactionDetailIntent.OpenReceipt -> ui.update { it.copy(isReceiptOpen = true) }
            TransactionDetailIntent.CloseReceipt -> ui.update { it.copy(isReceiptOpen = false) }
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
                is Outcome.Success -> send(TransactionDetailEffect.NavigateBack)
                is Outcome.Failure -> send(TransactionDetailEffect.ShowMessage(result.error.toMessage()))
            }
        }
    }

    private fun send(effect: TransactionDetailEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }

    private data class Ui(
        val isFetching: Boolean = false,
        val fetchError: UiText? = null,
        val isDeleting: Boolean = false,
        val isReceiptOpen: Boolean = false,
    )
}

private fun TransactionError.loadMessage(): UiText = when (this) {
    TransactionError.Network -> UiText.Resource(R.string.transactions_load_failed_network)
    else -> toMessage()
}
