package com.djtech.monai.feature.settings.presentation.providerform

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.format.walletMonogram
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Permissions
import com.djtech.monai.core.model.User
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.usecase.CreateProviderUseCase
import com.djtech.monai.feature.settings.domain.usecase.DeleteProviderUseCase
import com.djtech.monai.feature.settings.domain.usecase.GetAdminProviderUseCase
import com.djtech.monai.feature.settings.domain.usecase.SetProviderActiveUseCase
import com.djtech.monai.feature.settings.domain.usecase.UpdateProviderUseCase
import com.djtech.monai.feature.settings.domain.validation.MAX_PROVIDER_NAME_LENGTH
import com.djtech.monai.feature.settings.domain.validation.normalizedAlias
import com.djtech.monai.feature.settings.domain.validation.slugOf
import com.djtech.monai.feature.settings.presentation.manageproviders.mapper.message
import com.djtech.monai.feature.settings.presentation.providerform.model.ProviderFormDialog
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
 * Adds a provider, or edits the one with [providerId]: name, type, aliases, sort order, status
 * and logo. On an existing provider, the status switch and Delete apply at once, after a
 * confirmation; everything else waits for Save.
 */
@HiltViewModel(assistedFactory = ProviderFormViewModel.Factory::class)
class ProviderFormViewModel @AssistedInject constructor(
    @Assisted private val providerId: String?,
    observeUser: ObserveUserUseCase,
    private val getAdminProvider: GetAdminProviderUseCase,
    private val createProvider: CreateProviderUseCase,
    private val updateProvider: UpdateProviderUseCase,
    private val setProviderActive: SetProviderActiveUseCase,
    private val deleteProvider: DeleteProviderUseCase,
    private val clock: AppClock,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(providerId: String?): ProviderFormViewModel
    }

    private val form = MutableStateFlow(Form(isLoading = providerId != null))

    val state: StateFlow<ProviderFormState> = combine(observeUser(), form) { user, form -> toState(user, form) }
        .stateIn(viewModelScope, WhileUiSubscribed, toState(null, form.value))

    private val effectChannel = Channel<ProviderFormEffect>(Channel.BUFFERED)
    val effects: Flow<ProviderFormEffect> = effectChannel.receiveAsFlow()

    init {
        load()
    }

    fun onIntent(intent: ProviderFormIntent) {
        when (intent) {
            is ProviderFormIntent.NameChanged -> form.update {
                it.copy(name = intent.name.take(MAX_PROVIDER_NAME_LENGTH), nameError = null)
            }

            is ProviderFormIntent.PickType -> form.update { it.copy(type = intent.type) }
            is ProviderFormIntent.AliasInputChanged -> {
                // Typing a comma adds what came before it, like Enter.
                if (',' in intent.text) {
                    form.update { it.withAliases(intent.text) }
                } else {
                    form.update { it.copy(aliasInput = intent.text, aliasError = null) }
                }
            }

            ProviderFormIntent.AddAlias -> form.update { it.withAliases(it.aliasInput) }
            is ProviderFormIntent.RemoveAlias -> form.update {
                it.copy(aliases = it.aliases - intent.alias, aliasError = null)
            }

            is ProviderFormIntent.SortOrderChanged -> if (SORT_ORDER_INPUT.matches(intent.text)) {
                form.update { it.copy(sortOrder = intent.text) }
            }

            is ProviderFormIntent.SetActive -> setActive(intent.active)
            ProviderFormIntent.PickLogo -> send(ProviderFormEffect.LaunchLogoPicker)
            is ProviderFormIntent.LogoPicked -> intent.uri?.let { uri ->
                form.update { it.copy(newLogoUri = uri) }
            }

            ProviderFormIntent.Delete -> form.update { it.copy(dialog = ProviderFormDialog.Delete) }
            ProviderFormIntent.ConfirmDialog -> when (form.value.dialog) {
                ProviderFormDialog.Deactivate -> changeStatus(active = false)
                ProviderFormDialog.Delete -> delete()
                null -> Unit
            }

            ProviderFormIntent.DismissDialog -> form.update { it.copy(dialog = null) }
            ProviderFormIntent.Save -> save()
            ProviderFormIntent.Retry -> load()
            ProviderFormIntent.Close -> send(ProviderFormEffect.Close)
        }
    }

    private fun toState(user: User?, form: Form): ProviderFormState {
        val original = form.original
        val canSave = if (original == null) {
            user.can(Permissions.PAYMENT_PROVIDER_CREATE)
        } else {
            user.can(Permissions.PAYMENT_PROVIDER_UPDATE)
        }
        return ProviderFormState(
            isEditing = providerId != null,
            isLoading = form.isLoading,
            loadError = form.loadError,
            name = form.name,
            slug = original?.slug ?: slugOf(form.name),
            monogram = walletMonogram(form.name),
            type = form.type,
            aliases = form.aliases,
            aliasInput = form.aliasInput,
            sortOrder = form.sortOrder,
            isActive = form.isActive,
            isSystem = original?.isSystem == true,
            logoUrl = original?.logoUrl,
            newLogoUri = form.newLogoUri,
            nameError = form.nameError,
            aliasError = form.aliasError,
            isSaving = form.isSaving,
            isDeleting = form.isDeleting,
            isChangingStatus = form.isChangingStatus,
            dialog = form.dialog,
            canSave = canSave,
            canDelete = original != null && !original.isSystem && user.can(Permissions.PAYMENT_PROVIDER_DELETE),
            lastEdited = original?.updatedAt?.atZone(clock.zone())?.toLocalDate(),
        )
    }

    private fun load() {
        val id = providerId ?: return
        form.update { it.copy(isLoading = true, loadError = null) }
        viewModelScope.launch {
            when (val result = getAdminProvider(id)) {
                is Outcome.Success -> form.update { it.filledFrom(result.data) }
                is Outcome.Failure -> form.update {
                    it.copy(isLoading = false, loadError = result.error.message())
                }
            }
        }
    }

    private fun setActive(active: Boolean) {
        val current = form.value
        val original = current.original
        when {
            // A new provider's status is part of the form.
            original == null -> form.update { it.copy(isActive = active) }
            original.isSystem || current.isWorking -> Unit
            active -> changeStatus(active = true)
            else -> form.update { it.copy(dialog = ProviderFormDialog.Deactivate) }
        }
    }

    private fun changeStatus(active: Boolean) {
        val original = form.value.original ?: return
        form.update { it.copy(dialog = null, isChangingStatus = true) }
        viewModelScope.launch {
            val result = setProviderActive(original.id, active)
            form.update { it.copy(isChangingStatus = false) }
            when (result) {
                is Outcome.Success -> form.update {
                    it.copy(isActive = result.data.isActive, original = result.data)
                }

                is Outcome.Failure -> send(ProviderFormEffect.ShowMessage(result.error.message()))
            }
        }
    }

    private fun delete() {
        val original = form.value.original ?: return
        form.update { it.copy(dialog = null, isDeleting = true) }
        viewModelScope.launch {
            val result = deleteProvider(original.id)
            form.update { it.copy(isDeleting = false) }
            when (result) {
                // The list reloads through the change events and no longer shows it.
                is Outcome.Success -> send(ProviderFormEffect.Close)

                is Outcome.Failure -> send(ProviderFormEffect.ShowMessage(result.error.message()))
            }
        }
    }

    private fun save() {
        // A typed alias not yet added with Enter is still meant to be saved.
        form.update { it.withAliases(it.aliasInput) }
        val current = form.value
        if (!state.value.canSave || current.isLoading || current.isWorking || current.aliasError != null) return
        val type = current.type ?: return
        val sortOrder = current.sortOrder.toIntOrNull() ?: return
        val input = ProviderInput(
            name = current.name,
            type = type,
            aliases = current.aliases,
            sortOrder = sortOrder,
            isActive = current.isActive,
        )
        form.update { it.copy(isSaving = true, nameError = null, aliasError = null) }
        viewModelScope.launch {
            val original = current.original
            val result = if (original == null) {
                createProvider(input, current.newLogoUri)
            } else {
                updateProvider(original, input, current.newLogoUri)
            }
            form.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> {
                    val logoError = result.data.logoError
                    if (logoError == null) {
                        send(ProviderFormEffect.Close)
                    } else {
                        // Saved, but the logo wasn't: stay, now editing the saved provider, so it can be retried.
                        form.update { it.filledFrom(result.data.provider).copy(newLogoUri = current.newLogoUri) }
                        val message = UiText.Resource(R.string.provider_form_saved_logo_failed)
                        send(ProviderFormEffect.ShowMessage(message))
                    }
                }

                is Outcome.Failure -> when (val error = result.error) {
                    is AdminProviderError.InvalidName -> form.update { it.copy(nameError = error.message()) }
                    is AdminProviderError.InvalidAliases -> form.update { it.copy(aliasError = error.message()) }
                    else -> send(ProviderFormEffect.ShowMessage(error.message()))
                }
            }
        }
    }

    private fun send(effect: ProviderFormEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }

    private companion object {
        val SORT_ORDER_INPUT = Regex("-?\\d{0,9}")
    }
}

private fun User?.can(permission: String): Boolean = this?.hasPermission(permission) == true

/** The form's own state; [original] is the provider as last loaded or saved. */
private data class Form(
    val isLoading: Boolean = false,
    val loadError: UiText? = null,
    val original: AdminPaymentProvider? = null,
    val name: String = "",
    val type: WalletType? = null,
    val aliases: List<String> = emptyList(),
    val aliasInput: String = "",
    val sortOrder: String = "100",
    val isActive: Boolean = true,
    val newLogoUri: String? = null,
    val nameError: UiText? = null,
    val aliasError: UiText? = null,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val isChangingStatus: Boolean = false,
    val dialog: ProviderFormDialog? = null,
) {
    val isWorking: Boolean get() = isSaving || isDeleting || isChangingStatus

    fun filledFrom(provider: AdminPaymentProvider) = copy(
        isLoading = false,
        loadError = null,
        original = provider,
        name = provider.name,
        type = provider.type,
        aliases = provider.aliases,
        sortOrder = provider.sortOrder.toString(),
        isActive = provider.isActive,
        newLogoUri = null,
    )

    /** [text]'s comma-separated aliases added, normalized and without repeats; the input cleared. */
    fun withAliases(text: String): Form {
        val added = text.split(',').map(::normalizedAlias).filter(String::isNotEmpty)
        return copy(aliases = (aliases + added).distinct(), aliasInput = "", aliasError = null)
    }
}
