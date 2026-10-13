package com.djtech.monai.feature.wallets.presentation.walletform

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.format.parseAmount
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.WalletColor
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.usecase.ArchiveWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.CreateWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.DeleteWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObservePaymentProvidersUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshPaymentProvidersUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.UpdateWalletUseCase
import com.djtech.monai.feature.wallets.domain.validation.MAX_WALLET_NAME_LENGTH
import com.djtech.monai.feature.wallets.presentation.common.message
import com.djtech.monai.feature.wallets.presentation.walletform.mapper.toFieldMessages
import com.djtech.monai.feature.wallets.presentation.walletform.model.WalletFormDialog
import com.djtech.monai.feature.wallets.presentation.walletform.model.WalletFormMode
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
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

/**
 * Adds a wallet ([walletId] null), from a provider or as a custom one, or edits one. Saving
 * validates in the use case and maps any field errors back onto the form.
 */
@HiltViewModel(assistedFactory = WalletFormViewModel.Factory::class)
class WalletFormViewModel @AssistedInject constructor(
    @Assisted private val walletId: String?,
    observeProviders: ObservePaymentProvidersUseCase,
    private val refreshProviders: RefreshPaymentProvidersUseCase,
    private val observeWallet: ObserveWalletUseCase,
    private val refreshWallet: RefreshWalletUseCase,
    observeWallets: ObserveWalletsUseCase,
    private val createWallet: CreateWalletUseCase,
    private val updateWallet: UpdateWalletUseCase,
    private val archiveWallet: ArchiveWalletUseCase,
    private val deleteWallet: DeleteWalletUseCase,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(walletId: String?): WalletFormViewModel
    }

    private val mode: WalletFormMode = walletId?.let(WalletFormMode::Edit) ?: WalletFormMode.Add
    private val editor = MutableStateFlow(Editor(draft = Draft(), pristine = Draft(), isLoading = walletId != null))

    val state: StateFlow<WalletFormState> = combine(
        editor,
        observeProviders(),
        observeWallets(),
    ) { editor, providers, wallets ->
        val draft = editor.draft
        WalletFormState(
            mode = mode,
            isLoading = editor.isLoading,
            loadError = editor.loadError,
            providers = providers,
            providerSlug = draft.provider?.slug,
            name = draft.name,
            type = draft.type,
            isTypeLocked = draft.provider != null || editor.original?.providerId != null,
            initialBalance = draft.initialBalance,
            color = draft.color,
            isDefault = draft.isDefault,
            wallet = editor.original,
            defaultWalletName = wallets.firstOrNull(Wallet::isDefault)?.name,
            errors = editor.errors,
            isSaving = editor.isSaving,
            dialog = editor.dialog,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, WalletFormState(mode = mode, isLoading = walletId != null))

    private val effectChannel = Channel<WalletFormEffect>(Channel.BUFFERED)
    val effects: Flow<WalletFormEffect> = effectChannel.receiveAsFlow()

    init {
        if (walletId == null) {
            // Best effort: the grid shows the cached catalog, or the bundled seed, meanwhile.
            viewModelScope.launch { refreshProviders() }
        } else {
            load(walletId)
        }
    }

    fun onIntent(intent: WalletFormIntent) {
        when (intent) {
            is WalletFormIntent.PickProvider -> pickProvider(intent.slug)
            WalletFormIntent.PickCustom -> editDraft(WalletField.TYPE) { draft ->
                // A name that only came from the provider would be wrong for a custom wallet.
                draft.copy(provider = null, name = draft.name.takeUnless { it == draft.provider?.name }.orEmpty())
            }

            is WalletFormIntent.NameChanged -> editDraft(WalletField.NAME) {
                it.copy(name = intent.name.take(MAX_WALLET_NAME_LENGTH))
            }

            is WalletFormIntent.SelectType -> editDraft(WalletField.TYPE) { it.copy(type = intent.type) }
            is WalletFormIntent.BalanceChanged -> editDraft(WalletField.INITIAL_BALANCE) { draft ->
                val digits = intent.text.filter(Char::isDigit)
                if (digits.isEmpty()) draft.copy(initialBalance = 0) else draft.copy(
                    initialBalance = parseAmount(digits) ?: draft.initialBalance,
                )
            }

            is WalletFormIntent.PickColor -> editDraft(WalletField.COLOR) { it.copy(color = intent.color) }
            is WalletFormIntent.DefaultChanged -> editDraft { it.copy(isDefault = intent.isDefault) }
            WalletFormIntent.Save -> save()
            WalletFormIntent.Close -> close()
            WalletFormIntent.ConfirmDiscard -> {
                editor.update { it.copy(dialog = null) }
                send(WalletFormEffect.Close)
            }

            WalletFormIntent.KeepEditing, WalletFormIntent.DismissDialog -> editor.update { it.copy(dialog = null) }
            WalletFormIntent.Archive, WalletFormIntent.ConfirmArchive -> archive()
            WalletFormIntent.Delete -> editor.update { it.copy(dialog = WalletFormDialog.ConfirmDelete) }
            WalletFormIntent.ConfirmDelete -> delete()
            WalletFormIntent.Retry -> walletId?.let(::load)
        }
    }

    private fun load(id: String) {
        editor.update { it.copy(isLoading = true, loadError = null) }
        viewModelScope.launch {
            val wallet = observeWallet(id).first() ?: run {
                val result = refreshWallet(id)
                if (result is Outcome.Failure) {
                    editor.update { it.copy(isLoading = false, loadError = result.error.loadMessage()) }
                    return@launch
                }
                observeWallet(id).first()
            }
            if (wallet == null) {
                editor.update { it.copy(isLoading = false, loadError = WalletError.NotFound.loadMessage()) }
                return@launch
            }
            val draft = wallet.toDraft()
            editor.update { Editor(draft = draft, pristine = draft, original = wallet) }
        }
    }

    // The provider sets the type, and the name unless the user already typed their own.
    private fun pickProvider(slug: String) {
        val provider = state.value.providers.firstOrNull { it.slug == slug } ?: return
        editDraft(WalletField.TYPE) { draft ->
            val keepsName = draft.name.isNotBlank() && draft.name != draft.provider?.name
            draft.copy(
                provider = provider,
                name = if (keepsName) draft.name else provider.name,
                type = provider.type,
            )
        }
        editor.update { it.copy(errors = it.errors - WalletField.NAME) }
    }

    private fun save() {
        val current = editor.value
        if (current.isSaving || current.isLoading) return
        editor.update { it.copy(isSaving = true, errors = emptyMap()) }
        viewModelScope.launch {
            val draft = current.draft
            val original = current.original
            val result: WalletResult<Wallet> = if (original == null) {
                createWallet(draft.toCreateInput())
            } else {
                updateWallet(original, draft.toUpdateInput(original))
            }
            editor.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> send(WalletFormEffect.Close)
                is Outcome.Failure -> when (val error = result.error) {
                    is WalletError.InvalidFields -> editor.update { it.copy(errors = error.errors.toFieldMessages()) }
                    else -> send(WalletFormEffect.ShowMessage(error.message()))
                }
            }
        }
    }

    private fun close() {
        val editor = editor.value
        if (editor.draft != editor.pristine && !editor.isLoading) {
            this.editor.update { it.copy(dialog = WalletFormDialog.Discard) }
        } else {
            send(WalletFormEffect.Close)
        }
    }

    private fun archive() {
        val id = walletId ?: return
        if (editor.value.isSaving) return
        editor.update { it.copy(isSaving = true, dialog = null) }
        viewModelScope.launch {
            val result = archiveWallet(id)
            editor.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> send(WalletFormEffect.Close)
                is Outcome.Failure -> send(WalletFormEffect.ShowMessage(result.error.message()))
            }
        }
    }

    private fun delete() {
        val id = walletId ?: return
        if (editor.value.isSaving) return
        editor.update { it.copy(isSaving = true, dialog = null) }
        viewModelScope.launch {
            val result = deleteWallet(id)
            editor.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> send(WalletFormEffect.Deleted(id))
                // Wallets with history can only be archived; offer that instead.
                is Outcome.Failure -> if (result.error == WalletError.HasTransactions) {
                    editor.update { it.copy(dialog = WalletFormDialog.ArchiveInstead) }
                } else {
                    send(WalletFormEffect.ShowMessage(result.error.message()))
                }
            }
        }
    }

    /** Applies [change] and clears the error of the field it touched. */
    private fun editDraft(field: WalletField? = null, change: (Draft) -> Draft) {
        editor.update { editor ->
            editor.copy(draft = change(editor.draft), errors = field?.let { editor.errors - it } ?: editor.errors)
        }
    }

    private fun send(effect: WalletFormEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

/** What the form edits; [provider] is set only on the add form. */
private data class Draft(
    val provider: PaymentProvider? = null,
    val name: String = "",
    val type: WalletType? = null,
    val initialBalance: Long = 0,
    val color: WalletColor? = null,
    val isDefault: Boolean = false,
) {
    // A seed provider has no server id yet: send its slug for the use case to resolve.
    fun toCreateInput(): WalletInput {
        val providerId = provider?.id?.takeIf(String::isNotEmpty)
        return WalletInput(
            providerId = providerId,
            providerSlug = provider?.slug?.takeIf { providerId == null },
            name = name,
            type = type,
            initialBalance = initialBalance,
            isDefault = isDefault,
        )
    }

    fun toUpdateInput(original: Wallet) = WalletInput(
        providerId = original.providerId,
        name = name,
        type = type,
        initialBalance = initialBalance,
        color = color?.hex,
        isDefault = isDefault,
    )
}

/**
 * [original] is the wallet being edited and [pristine] the draft the form started from, to tell
 * whether anything changed.
 */
private data class Editor(
    val draft: Draft,
    val pristine: Draft,
    val original: Wallet? = null,
    val isLoading: Boolean = false,
    val loadError: UiText? = null,
    val errors: Map<WalletField, UiText> = emptyMap(),
    val isSaving: Boolean = false,
    val dialog: WalletFormDialog? = null,
)

private fun Wallet.toDraft() = Draft(
    name = name,
    type = type,
    initialBalance = initialBalance,
    color = WalletColor.fromHex(color),
    isDefault = isDefault,
)

private fun WalletError.loadMessage(): UiText = when (this) {
    WalletError.NotFound -> UiText.Resource(R.string.wallets_error_not_found)
    WalletError.Network -> UiText.Resource(R.string.wallets_load_failed_network)
    else -> UiText.Resource(R.string.wallets_load_failed_unexpected)
}
