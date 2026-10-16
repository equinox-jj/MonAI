package com.djtech.monai.feature.wallets.presentation.wallets

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.common.ui.RefreshStatus
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.balanceSharesByType
import com.djtech.monai.feature.wallets.domain.model.totalBalance
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletsUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Shows the cached wallets at once and refreshes them in the background. A failed refresh keeps
 * what is cached; only a first load with nothing cached replaces the list with an error.
 */
@HiltViewModel
class WalletsViewModel @Inject constructor(
    private val observeAllWallets: ObserveAllWalletsUseCase,
    private val refreshWallets: RefreshWalletsUseCase,
) : ViewModel() {

    private val load = MutableStateFlow(RefreshStatus<WalletError>())
    private val selectedId = MutableStateFlow<String?>(null)

    val state: StateFlow<WalletsState> = combine(observeAllWallets(), load, selectedId, ::toState)
        .stateIn(viewModelScope, WhileUiSubscribed, WalletsState())

    private val effectQueue = EffectQueue<WalletsEffect>()
    val effects: Flow<WalletsEffect> = effectQueue.flow

    init {
        refresh(userInitiated = false)
    }

    fun onIntent(intent: WalletsIntent) {
        when (intent) {
            WalletsIntent.Refresh -> refresh(userInitiated = true)
            is WalletsIntent.Select -> selectedId.value = intent.id
            is WalletsIntent.Open -> effectQueue.send(WalletsEffect.Navigate(intent.destination))
        }
    }

    private fun refresh(userInitiated: Boolean) {
        if (load.value.isRunning) return
        load.update { it.started(userInitiated) }
        viewModelScope.launch {
            val failure = (refreshWallets() as? Outcome.Failure)?.error
            load.update { it.finished(failure) }
            // With nothing cached the state shows the error itself, so there's no message too.
            if (failure != null && observeAllWallets().first().isNotEmpty()) {
                effectQueue.send(
                    WalletsEffect.ShowMessage(failure.refreshMessage(), isOffline = failure == WalletError.Network),
                )
            }
        }
    }

    private fun toState(all: List<Wallet>, load: RefreshStatus<WalletError>, selected: String?): WalletsState {
        val active = all.filterNot(Wallet::isArchived)
        val hasCache = all.isNotEmpty()
        return WalletsState(
            isLoading = load.isLoading(hasCache),
            loadError = load.loadFailure(hasCache)?.loadMessage(),
            isRefreshing = load.isRefreshing(hasCache),
            wallets = active,
            totalBalance = active.totalBalance(),
            shares = active.balanceSharesByType(),
            archivedCount = all.size - active.size,
            // A wallet archived or deleted from the pane drops out, so the pane falls back to the first.
            selectedId = selected?.takeIf { id -> active.any { it.id == id } } ?: active.firstOrNull()?.id,
        )
    }
}

private fun WalletError.refreshMessage(): UiText = UiText.Resource(
    when (this) {
        WalletError.Network -> R.string.wallets_refresh_failed_network
        else -> R.string.wallets_refresh_failed_unexpected
    },
)

private fun WalletError.loadMessage(): UiText = UiText.Resource(
    when (this) {
        WalletError.Network -> R.string.wallets_load_failed_network
        else -> R.string.wallets_load_failed_unexpected
    },
)
