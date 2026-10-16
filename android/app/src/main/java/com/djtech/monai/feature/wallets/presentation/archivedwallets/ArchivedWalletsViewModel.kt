package com.djtech.monai.feature.wallets.presentation.archivedwallets

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.wallets.domain.usecase.ObserveArchivedWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.UnarchiveWalletUseCase
import com.djtech.monai.feature.wallets.presentation.common.message
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

/** Archived wallets from the cache, each with a way back to the pickers. */
@HiltViewModel
class ArchivedWalletsViewModel @Inject constructor(
    observeArchivedWallets: ObserveArchivedWalletsUseCase,
    private val unarchiveWallet: UnarchiveWalletUseCase,
) : ViewModel() {

    private val restoringId = MutableStateFlow<String?>(null)

    val state: StateFlow<ArchivedWalletsState> =
        combine(observeArchivedWallets(), restoringId, ::ArchivedWalletsState)
            .stateIn(viewModelScope, WhileUiSubscribed, ArchivedWalletsState())

    private val effectQueue = EffectQueue<ArchivedWalletsEffect>()
    val effects: Flow<ArchivedWalletsEffect> = effectQueue.flow

    fun onIntent(intent: ArchivedWalletsIntent) {
        when (intent) {
            ArchivedWalletsIntent.Back -> effectQueue.send(ArchivedWalletsEffect.NavigateBack)
            is ArchivedWalletsIntent.Unarchive -> unarchive(intent.id)
            is ArchivedWalletsIntent.View -> effectQueue.send(ArchivedWalletsEffect.OpenWallet(intent.id))
        }
    }

    private fun unarchive(id: String) {
        if (restoringId.value != null) return
        restoringId.value = id
        viewModelScope.launch {
            val result = unarchiveWallet(id)
            restoringId.value = null
            effectQueue.send(
                when (result) {
                    is Outcome.Success -> ArchivedWalletsEffect.Restored(
                        id,
                        UiText.Resource(R.string.archived_wallets_restored, result.data.name),
                    )

                    is Outcome.Failure -> ArchivedWalletsEffect.ShowMessage(result.error.message())
                },
            )
        }
    }
}
