package com.djtech.monai.feature.settings.presentation.providerform

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.settings.presentation.providerform.model.ProviderFormDialog
import java.time.LocalDate

/**
 * A new provider, or an existing one being edited.
 *
 * @param slug the provider's ID: its own when editing, else what the server will make from [name].
 * @param aliasInput the alias being typed, added on Enter.
 * @param sortOrder as typed; digits only, with an optional leading minus.
 * @param logoUrl the saved logo; [newLogoUri] a picked one that uploads on save.
 * @param isSystem a system provider: always active, never deleted.
 * @param canSave the user may save this form (create or update permission).
 * @param canDelete the user may delete this provider.
 * @param lastEdited when it was last saved, in the user's zone.
 */
@Immutable
data class ProviderFormState(
    val isEditing: Boolean,
    val isLoading: Boolean = false,
    val loadError: UiText? = null,
    val name: String = "",
    val slug: String = "",
    val monogram: String = "",
    val type: WalletType? = null,
    val aliases: List<String> = emptyList(),
    val aliasInput: String = "",
    val sortOrder: String = "100",
    val isActive: Boolean = true,
    val isSystem: Boolean = false,
    val logoUrl: String? = null,
    val newLogoUri: String? = null,
    val nameError: UiText? = null,
    val aliasError: UiText? = null,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val isChangingStatus: Boolean = false,
    val dialog: ProviderFormDialog? = null,
    val canSave: Boolean = false,
    val canDelete: Boolean = false,
    val lastEdited: LocalDate? = null,
) {
    val isWorking: Boolean get() = isSaving || isDeleting || isChangingStatus

    val isReady: Boolean
        get() = canSave && !isLoading && !isWorking && name.isNotBlank() && type != null &&
            sortOrder.toIntOrNull() != null
}

sealed interface ProviderFormIntent {
    data class NameChanged(val name: String) : ProviderFormIntent

    data class PickType(val type: WalletType) : ProviderFormIntent

    data class AliasInputChanged(val text: String) : ProviderFormIntent

    /** Adds what is typed; commas split several. */
    data object AddAlias : ProviderFormIntent

    data class RemoveAlias(val alias: String) : ProviderFormIntent

    data class SortOrderChanged(val text: String) : ProviderFormIntent

    /** On an existing provider, deactivating asks first and both apply at once. */
    data class SetActive(val active: Boolean) : ProviderFormIntent

    data object PickLogo : ProviderFormIntent

    /** The photo picker returned; null when the user backed out. */
    data class LogoPicked(val uri: String?) : ProviderFormIntent

    /** Asks to confirm first. */
    data object Delete : ProviderFormIntent

    data object ConfirmDialog : ProviderFormIntent

    data object DismissDialog : ProviderFormIntent

    data object Save : ProviderFormIntent

    data object Retry : ProviderFormIntent

    data object Close : ProviderFormIntent
}

sealed interface ProviderFormEffect {
    /** Saved, deleted or left: close the form. */
    data object Close : ProviderFormEffect

    data object LaunchLogoPicker : ProviderFormEffect

    data class ShowMessage(val message: UiText) : ProviderFormEffect
}
