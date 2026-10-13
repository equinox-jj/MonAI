package com.djtech.monai.feature.settings.presentation.manageproviders

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Permissions
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.usecase.GetAdminProvidersUseCase
import com.djtech.monai.feature.settings.domain.usecase.ObserveProviderChangesUseCase
import com.djtech.monai.feature.settings.presentation.manageproviders.mapper.matches
import com.djtech.monai.feature.settings.presentation.manageproviders.mapper.message
import com.djtech.monai.feature.settings.presentation.manageproviders.mapper.toRow
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * The provider catalog for admins, inactive providers included, searchable by name or alias.
 * Reloads whenever a provider is saved or deleted elsewhere.
 */
@HiltViewModel
class ManageProvidersViewModel @Inject constructor(
    observeUser: ObserveUserUseCase,
    private val getAdminProviders: GetAdminProvidersUseCase,
    observeProviderChanges: ObserveProviderChangesUseCase,
) : ViewModel() {

    private val ui = MutableStateFlow(Ui())

    val state: StateFlow<ManageProvidersState> = combine(observeUser(), ui) { user, ui ->
        ManageProvidersState(
            isLoading = ui.providers == null && ui.isLoading,
            loadError = ui.loadError.takeIf { ui.providers == null },
            isRefreshing = ui.providers != null && ui.isLoading && ui.isUserRefresh,
            query = ui.query,
            rows = ui.providers.orEmpty().filter { it.matches(ui.query) }.map(AdminPaymentProvider::toRow),
            totalCount = ui.providers.orEmpty().size,
            canCreate = user?.hasPermission(Permissions.PAYMENT_PROVIDER_CREATE) == true,
            canEdit = user?.hasPermission(Permissions.PAYMENT_PROVIDER_UPDATE) == true ||
                user?.hasPermission(Permissions.PAYMENT_PROVIDER_DELETE) == true,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, ManageProvidersState())

    private val effectChannel = Channel<ManageProvidersEffect>(Channel.BUFFERED)
    val effects: Flow<ManageProvidersEffect> = effectChannel.receiveAsFlow()

    private var loadJob: Job? = null

    init {
        load(userInitiated = false)
        viewModelScope.launch { observeProviderChanges().collect { load(userInitiated = false) } }
    }

    fun onIntent(intent: ManageProvidersIntent) {
        when (intent) {
            is ManageProvidersIntent.QueryChanged -> ui.update { it.copy(query = intent.query) }
            ManageProvidersIntent.Refresh -> load(userInitiated = true)
            ManageProvidersIntent.Back -> send(ManageProvidersEffect.Close)
            ManageProvidersIntent.Add -> if (state.value.canCreate) send(ManageProvidersEffect.OpenForm(null))
            is ManageProvidersIntent.Open -> if (state.value.canEdit) {
                send(ManageProvidersEffect.OpenForm(intent.id))
            }
        }
    }

    private fun load(userInitiated: Boolean) {
        loadJob?.cancel()
        ui.update { it.copy(isLoading = true, isUserRefresh = userInitiated, loadError = null) }
        loadJob = viewModelScope.launch {
            when (val result = getAdminProviders()) {
                is Outcome.Success -> ui.update { it.copy(isLoading = false, providers = result.data) }
                is Outcome.Failure -> {
                    ui.update { it.copy(isLoading = false, loadError = result.error.message()) }
                    // A list already on screen stays; the failure shows as a message instead.
                    if (ui.value.providers != null) send(ManageProvidersEffect.ShowMessage(result.error.message()))
                }
            }
        }
    }

    private fun send(effect: ManageProvidersEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

/** Screen-local state; the providers are network-only, so they live here. */
private data class Ui(
    /** Null until the first load succeeds. */
    val providers: List<AdminPaymentProvider>? = null,
    val isLoading: Boolean = true,
    val isUserRefresh: Boolean = false,
    val loadError: UiText? = null,
    val query: String = "",
)
