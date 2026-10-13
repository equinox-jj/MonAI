package com.djtech.monai.feature.wallets.presentation.walletform

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.WalletColor
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.presentation.walletform.model.BalanceShift
import com.djtech.monai.feature.wallets.presentation.walletform.model.WalletFormDialog
import com.djtech.monai.feature.wallets.presentation.walletform.model.WalletFormMode

/**
 * The add and edit wallet form.
 *
 * @param isLoading editing, and the wallet isn't loaded yet.
 * @param loadError editing, and the wallet couldn't be loaded.
 * @param providers the catalog for the add form's grid; the bundled seed until refreshed.
 * @param providerSlug the provider picked on the add form; null for a custom wallet.
 * @param isTypeLocked the type comes from the provider and can't be changed.
 * @param initialBalance rupiah: "Current balance" when adding, "Starting balance" when editing.
 * @param color the picked card color (edit only); null keeps the type's.
 * @param wallet the wallet being edited, as saved.
 * @param defaultWalletName the current default wallet, for the default switch's note.
 * @param errors one message per invalid field, from the device's checks or the server's.
 */
@Immutable
data class WalletFormState(
    val mode: WalletFormMode,
    val isLoading: Boolean = false,
    val loadError: UiText? = null,
    val providers: List<PaymentProvider> = emptyList(),
    val providerSlug: String? = null,
    val name: String = "",
    val type: WalletType? = null,
    val isTypeLocked: Boolean = false,
    val initialBalance: Long = 0,
    val color: WalletColor? = null,
    val isDefault: Boolean = false,
    val wallet: Wallet? = null,
    val defaultWalletName: String? = null,
    val errors: Map<WalletField, UiText> = emptyMap(),
    val isSaving: Boolean = false,
    val dialog: WalletFormDialog? = null,
) {
    val isEdit: Boolean get() = mode is WalletFormMode.Edit

    /** The note under "Starting balance" once it differs from the saved one. */
    val balanceShift: BalanceShift?
        get() = wallet?.takeIf { it.initialBalance != initialBalance }?.let {
            BalanceShift(it.currentBalance, it.currentBalance + initialBalance - it.initialBalance)
        }

    /** The API only takes "make default"; another wallet has to become the default to unset this one. */
    val canChangeDefault: Boolean get() = wallet?.isDefault != true
    val canArchive: Boolean get() = wallet?.isDefault == false && !wallet.isArchived
    val canDelete: Boolean get() = wallet?.isDefault == false
}

sealed interface WalletFormIntent {
    data class PickProvider(val slug: String) : WalletFormIntent

    data object PickCustom : WalletFormIntent

    data class NameChanged(val name: String) : WalletFormIntent

    data class SelectType(val type: WalletType) : WalletFormIntent

    /** Raw field text; only its digits count. */
    data class BalanceChanged(val text: String) : WalletFormIntent

    data class PickColor(val color: WalletColor) : WalletFormIntent

    data class DefaultChanged(val isDefault: Boolean) : WalletFormIntent

    data object Save : WalletFormIntent

    /** Back or the close button: asks first when something changed. */
    data object Close : WalletFormIntent

    data object ConfirmDiscard : WalletFormIntent

    data object KeepEditing : WalletFormIntent

    data object Archive : WalletFormIntent

    /** Asks to confirm first. */
    data object Delete : WalletFormIntent

    data object ConfirmDelete : WalletFormIntent

    /** Archives from the dialog shown when delete was refused. */
    data object ConfirmArchive : WalletFormIntent

    data object DismissDialog : WalletFormIntent

    data object Retry : WalletFormIntent
}

sealed interface WalletFormEffect {
    data object Close : WalletFormEffect

    /** The wallet is gone: close the form and the wallet's detail. */
    data class Deleted(val id: String) : WalletFormEffect

    data class ShowMessage(val message: UiText) : WalletFormEffect
}
