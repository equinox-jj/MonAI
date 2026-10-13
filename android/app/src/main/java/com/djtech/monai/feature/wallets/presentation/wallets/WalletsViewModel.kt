package com.djtech.monai.feature.wallets.presentation.wallets

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.balanceSharesByType
import com.djtech.monai.feature.wallets.domain.model.totalBalance
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletsUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.receiveAsFlow
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

    private val load = MutableStateFlow(LoadStatus())
    private val selectedId = MutableStateFlow<String?>(null)

    val state: StateFlow<WalletsState> = combine(observeAllWallets(), load, selectedId, ::toState)
        .stateIn(viewModelScope, WhileUiSubscribed, WalletsState())

    private val effectChannel = Channel<WalletsEffect>(Channel.BUFFERED)
    val effects: Flow<WalletsEffect> = effectChannel.receiveAsFlow()

    init {
        refresh(userInitiated = false)
    }

    fun onIntent(intent: WalletsIntent) {
        when (intent) {
            WalletsIntent.Refresh -> refresh(userInitiated = true)
            is WalletsIntent.Select -> selectedId.value = intent.id
            is WalletsIntent.Open -> send(WalletsEffect.Navigate(intent.destination))
        }
    }

    private fun refresh(userInitiated: Boolean) {
        if (load.value.isRunning) return
        load.update { it.copy(isRunning = true, isUserInitiated = userInitiated, failure = null) }
        viewModelScope.launch {
            val failure = (refreshWallets() as? Outcome.Failure)?.error
            load.update { LoadStatus(hasFinishedOnce = true, failure = failure) }
            // With nothing cached the state shows the error itself, so there's no message too.
            if (failure != null && observeAllWallets().first().isNotEmpty()) {
                send(WalletsEffect.ShowMessage(failure.refreshMessage(), isOffline = failure == WalletError.Network))
            }
        }
    }

    private fun toState(all: List<Wallet>, load: LoadStatus, selected: String?): WalletsState {
        val active = all.filterNot(Wallet::isArchived)
        val hasCache = all.isNotEmpty()
        return WalletsState(
            isLoading = !hasCache && (load.isRunning || !load.hasFinishedOnce),
            loadError = if (!hasCache && !load.isRunning) load.failure?.loadMessage() else null,
            isRefreshing = hasCache && load.isRunning && load.isUserInitiated,
            wallets = active,
            totalBalance = active.totalBalance(),
            shares = active.balanceSharesByType(),
            archivedCount = all.size - active.size,
            // A wallet archived or deleted from the pane drops out, so the pane falls back to the first.
            selectedId = selected?.takeIf { id -> active.any { it.id == id } } ?: active.firstOrNull()?.id,
        )
    }

    private fun send(effect: WalletsEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

/** @param failure how the last finished refresh failed; null when it succeeded or one is running. */
private data class LoadStatus(
    val isRunning: Boolean = false,
    val isUserInitiated: Boolean = false,
    val hasFinishedOnce: Boolean = false,
    val failure: WalletError? = null,
)

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
