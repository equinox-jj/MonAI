package com.djtech.monai.feature.transactions.presentation.undodelete

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionDeletionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RestoreTransactionUseCase
import com.djtech.monai.feature.transactions.presentation.common.mapper.toMessage
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/** How long a delete can be undone. */
internal const val UNDO_WINDOW_MS = 5_000L

/**
 * Offers undo for every transaction deleted anywhere in the signed-in app, for [UNDO_WINDOW_MS].
 * A new delete replaces the offer for the previous one.
 */
@HiltViewModel
class UndoDeleteViewModel @Inject constructor(
    observeTransactionDeletions: ObserveTransactionDeletionsUseCase,
    private val restoreTransaction: RestoreTransactionUseCase,
    observeCategories: ObserveCategoriesUseCase,
    observeAllWallets: ObserveAllWalletsUseCase,
) : ViewModel() {

    private val offer = MutableStateFlow(Offer())
    private var timeout: Job? = null

    val state: StateFlow<UndoDeleteState> = combine(
        offer,
        combine(observeCategories(), observeAllWallets(), TransactionLookups::of),
    ) { offer, lookups -> UndoDeleteState(offer.deleted, lookups, offer.isRestoring) }
        .stateIn(viewModelScope, WhileUiSubscribed, UndoDeleteState())

    private val effectQueue = EffectQueue<UndoDeleteEffect>()
    val effects: Flow<UndoDeleteEffect> = effectQueue.flow

    init {
        viewModelScope.launch { observeTransactionDeletions().collect(::offerUndo) }
    }

    fun onIntent(intent: UndoDeleteIntent) {
        when (intent) {
            UndoDeleteIntent.Undo -> undo()
            UndoDeleteIntent.Dismiss -> clear()
        }
    }

    private fun offerUndo(deleted: Transaction) {
        timeout?.cancel()
        offer.value = Offer(deleted)
        timeout = viewModelScope.launch {
            delay(UNDO_WINDOW_MS)
            offer.update { if (it.deleted?.id == deleted.id && !it.isRestoring) Offer() else it }
        }
    }

    private fun undo() {
        val deleted = offer.value.deleted ?: return
        if (offer.value.isRestoring) return
        timeout?.cancel()
        offer.update { it.copy(isRestoring = true) }
        viewModelScope.launch {
            val result = restoreTransaction(deleted.id)
            clear()
            if (result is Outcome.Failure) effectQueue.send(UndoDeleteEffect.ShowMessage(result.error.toMessage()))
        }
    }

    private fun clear() {
        timeout?.cancel()
        offer.value = Offer()
    }

    private data class Offer(val deleted: Transaction? = null, val isRestoring: Boolean = false)
}
