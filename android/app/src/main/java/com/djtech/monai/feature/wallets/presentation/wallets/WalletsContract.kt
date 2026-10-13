package com.djtech.monai.feature.wallets.presentation.wallets

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletTypeShare

/**
 * @param isLoading nothing is cached yet and the first load is running: show the skeleton.
 * @param loadError nothing is cached and the load failed: show the error with a retry.
 * @param isRefreshing a pull-to-refresh is running.
 * @param wallets not archived, default first, then by name.
 * @param shares how [totalBalance] splits by wallet type, largest first, for the stacked bar.
 * @param selectedId the wallet in the detail pane on a wide screen: the picked one, else the first.
 */
@Immutable
data class WalletsState(
    val isLoading: Boolean = true,
    val loadError: UiText? = null,
    val isRefreshing: Boolean = false,
    val wallets: List<Wallet> = emptyList(),
    /** Rupiah across [wallets]. */
    val totalBalance: Long = 0,
    val shares: List<WalletTypeShare> = emptyList(),
    val archivedCount: Int = 0,
    val selectedId: String? = null,
)

sealed interface WalletsIntent {
    /** Pull-to-refresh and the error's retry. */
    data object Refresh : WalletsIntent

    /** Shows a wallet in the detail pane on a wide screen. */
    data class Select(val id: String) : WalletsIntent

    data class Open(val destination: WalletsDestination) : WalletsIntent
}

sealed interface WalletsEffect {
    data class Navigate(val destination: WalletsDestination) : WalletsEffect

    /** A refresh failed while cached wallets are on screen; [isOffline] gets the offline icon. */
    data class ShowMessage(val message: UiText, val isOffline: Boolean) : WalletsEffect
}

/** Shared by [WalletsIntent.Open] and [WalletsEffect.Navigate]. */
sealed interface WalletsDestination {
    data class Detail(val id: String) : WalletsDestination
    data object Add : WalletsDestination
    data object Archived : WalletsDestination
}
