package com.djtech.monai.feature.wallets.presentation.walletdetail

import androidx.annotation.StringRes
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.paging.PagingData
import androidx.paging.cachedIn
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.common.ui.RefreshStatus
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveWalletDailyOutflowsUseCase
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.usecase.ArchiveWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.DeleteWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.SetDefaultWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.UnarchiveWalletUseCase
import com.djtech.monai.feature.wallets.presentation.common.loadMessage
import com.djtech.monai.feature.wallets.presentation.common.message
import com.djtech.monai.feature.wallets.presentation.walletdetail.mapper.toOutflowDays
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletDetailDialog
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletRowLookups
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
 * One wallet: its balance, this month's money out and transactions, and the actions on it. Shows
 * the cache at once and refetches the wallet, so the balance is current.
 */
@HiltViewModel(assistedFactory = WalletDetailViewModel.Factory::class)
class WalletDetailViewModel @AssistedInject constructor(
    @Assisted private val walletId: String,
    observeWallet: ObserveWalletUseCase,
    private val refreshWallet: RefreshWalletUseCase,
    observeAllWallets: ObserveAllWalletsUseCase,
    observeCategories: ObserveCategoriesUseCase,
    observeTransactions: ObserveTransactionsUseCase,
    observeDailyOutflows: ObserveWalletDailyOutflowsUseCase,
    private val setDefaultWallet: SetDefaultWalletUseCase,
    private val archiveWallet: ArchiveWalletUseCase,
    private val unarchiveWallet: UnarchiveWalletUseCase,
    private val deleteWallet: DeleteWalletUseCase,
    clock: AppClock,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(walletId: String): WalletDetailViewModel
    }

    private val month = clock.currentMonth()
    private val today = clock.today()
    private val ui = MutableStateFlow(Ui())

    /** This month's transactions in or out of the wallet, newest first, paged as the API fills the cache. */
    val transactions: Flow<PagingData<Transaction>> =
        observeTransactions(month, TransactionFilter(walletId = walletId)).cachedIn(viewModelScope)

    private val lookups: Flow<WalletRowLookups> =
        combine(observeCategories(), observeAllWallets()) { categories, wallets ->
            WalletRowLookups(categories.associateBy { it.id }, wallets.associate { it.id to it.name })
        }

    val state: StateFlow<WalletDetailState> = combine(
        observeWallet(walletId),
        observeDailyOutflows(month, walletId),
        lookups,
        ui,
    ) { wallet, outflows, lookups, ui ->
        WalletDetailState(
            month = month,
            today = today,
            wallet = wallet,
            isLoading = ui.fetch.isLoading(hasCache = wallet != null),
            loadError = ui.fetch.loadFailure(hasCache = wallet != null)?.loadMessage(),
            outflows = outflows.toOutflowDays(month, today),
            outflowTotal = outflows.values.sum(),
            lookups = lookups,
            isWorking = ui.isWorking,
            dialog = ui.dialog,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, WalletDetailState(month = month, today = today))

    private val effectQueue = EffectQueue<WalletDetailEffect>()
    val effects: Flow<WalletDetailEffect> = effectQueue.flow

    init {
        fetch()
    }

    fun onIntent(intent: WalletDetailIntent) {
        when (intent) {
            WalletDetailIntent.Back -> effectQueue.send(WalletDetailEffect.NavigateBack)
            WalletDetailIntent.Edit -> navigate(WalletDetailDestination.Edit(walletId))
            WalletDetailIntent.Transfer -> navigate(WalletDetailDestination.Transfer(walletId))
            is WalletDetailIntent.OpenTransaction -> navigate(WalletDetailDestination.Transaction(intent.id))
            WalletDetailIntent.SetDefault -> run(R.string.wallet_detail_now_default) { setDefaultWallet(walletId) }
            WalletDetailIntent.Archive, WalletDetailIntent.ConfirmArchive -> {
                ui.update { it.copy(dialog = null) }
                run(R.string.wallet_detail_archived) { archiveWallet(walletId) }
            }

            WalletDetailIntent.Unarchive -> run(R.string.wallet_detail_unarchived) { unarchiveWallet(walletId) }
            WalletDetailIntent.Delete -> ui.update { it.copy(dialog = WalletDetailDialog.ConfirmDelete) }
            WalletDetailIntent.ConfirmDelete -> delete()
            WalletDetailIntent.DismissDialog -> ui.update { it.copy(dialog = null) }
            WalletDetailIntent.Retry -> fetch()
        }
    }

    private fun fetch() {
        ui.update { it.copy(fetch = it.fetch.started()) }
        viewModelScope.launch {
            val error = (refreshWallet(walletId) as? Outcome.Failure)?.error
            // With the wallet cached a failed refetch keeps it on screen; only an empty screen shows the error.
            ui.update { it.copy(fetch = it.fetch.finished(error)) }
        }
    }

    /** Runs a wallet action once at a time and says how it went, naming the wallet on success. */
    private fun run(@StringRes success: Int, action: suspend () -> WalletResult<Wallet>) {
        if (ui.value.isWorking) return
        ui.update { it.copy(isWorking = true) }
        viewModelScope.launch {
            val result = action()
            ui.update { it.copy(isWorking = false) }
            effectQueue.send(
                WalletDetailEffect.ShowMessage(
                    when (result) {
                        is Outcome.Success -> UiText.Resource(success, result.data.name)
                        is Outcome.Failure -> result.error.message()
                    },
                ),
            )
        }
    }

    private fun delete() {
        if (ui.value.isWorking) return
        ui.update { it.copy(isWorking = true, dialog = null) }
        viewModelScope.launch {
            val result = deleteWallet(walletId)
            ui.update { it.copy(isWorking = false) }
            when (result) {
                is Outcome.Success -> effectQueue.send(WalletDetailEffect.Deleted(walletId))
                // Wallets with history can only be archived; offer that instead.
                is Outcome.Failure -> if (result.error == WalletError.HasTransactions) {
                    ui.update { it.copy(dialog = WalletDetailDialog.ArchiveInstead) }
                } else {
                    effectQueue.send(WalletDetailEffect.ShowMessage(result.error.message()))
                }
            }
        }
    }

    private fun navigate(destination: WalletDetailDestination) =
        effectQueue.send(WalletDetailEffect.Navigate(destination))
}

/** Screen-local state; the wallet itself comes from the cache. */
private data class Ui(
    val fetch: RefreshStatus<WalletError> = RefreshStatus(),
    val isWorking: Boolean = false,
    val dialog: WalletDetailDialog? = null,
)
