package com.djtech.monai.feature.wallets.presentation.archivedwallets

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Wallet

/** @param restoringId the wallet being unarchived; its button shows progress. */
@Immutable
data class ArchivedWalletsState(
    val wallets: List<Wallet> = emptyList(),
    val restoringId: String? = null,
)

sealed interface ArchivedWalletsIntent {
    data object Back : ArchivedWalletsIntent

    data class Unarchive(val id: String) : ArchivedWalletsIntent

    /** The "View" action of the message after unarchiving. */
    data class View(val id: String) : ArchivedWalletsIntent
}

sealed interface ArchivedWalletsEffect {
    data object NavigateBack : ArchivedWalletsEffect

    data class OpenWallet(val id: String) : ArchivedWalletsEffect

    /** "<name> is back in your wallets", with a View action that opens wallet [id]. */
    data class Restored(val id: String, val message: UiText) : ArchivedWalletsEffect

    data class ShowMessage(val message: UiText) : ArchivedWalletsEffect
}
