package com.djtech.monai.feature.settings.presentation.settings

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.AppLanguage
import com.djtech.monai.core.model.ThemeMode
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsDialog
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsPane
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsProfile
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsSheet
import java.time.YearMonth

/**
 * @param profile null until the user has been cached since sign-in.
 * @param budgetLimit this month's limit in rupiah; null when none is set.
 * @param showAdmin the user may add, edit or remove payment providers.
 * @param pane what the detail pane shows on a wide screen.
 * @param isSigningOut a sign-out is running; its row shows progress and taps are ignored.
 */
@Immutable
data class SettingsState(
    val month: YearMonth,
    val profile: SettingsProfile? = null,
    val budgetLimit: Long? = null,
    val categoryCount: Int = 0,
    val walletCount: Int = 0,
    val themeMode: ThemeMode = ThemeMode.SYSTEM,
    val language: AppLanguage = AppLanguage.SYSTEM,
    val showAdmin: Boolean = false,
    val appVersion: String = "",
    val sheet: SettingsSheet? = null,
    val dialog: SettingsDialog? = null,
    val pane: SettingsPane = SettingsPane.Profile,
    val isSigningOut: Boolean = false,
)

sealed interface SettingsIntent {
    data class Open(val destination: SettingsDestination) : SettingsIntent

    /** Shows a section in the detail pane on a wide screen. */
    data class SelectPane(val pane: SettingsPane) : SettingsIntent

    data class ShowSheet(val sheet: SettingsSheet) : SettingsIntent

    data object DismissSheet : SettingsIntent

    data class PickTheme(val mode: ThemeMode) : SettingsIntent

    data class PickLanguage(val language: AppLanguage) : SettingsIntent

    /** A CSV export reached the share sheet; [isComplete] is false when it held only cached transactions. */
    data class ExportFinished(val isComplete: Boolean) : SettingsIntent

    /** Asks to confirm first. */
    data object SignOut : SettingsIntent

    /** Asks to confirm first. */
    data object SignOutAllDevices : SettingsIntent

    data object ConfirmDialog : SettingsIntent

    data object DismissDialog : SettingsIntent
}

sealed interface SettingsEffect {
    data class Navigate(val destination: SettingsDestination) : SettingsEffect

    data class ShowMessage(val message: UiText, val isOffline: Boolean = false) : SettingsEffect
}

/** Shared by [SettingsIntent.Open] and [SettingsEffect.Navigate]. */
sealed interface SettingsDestination {
    /** [focusDelete] scrolls to the delete-account card. */
    data class EditProfile(val focusDelete: Boolean = false) : SettingsDestination

    data class Budget(val month: YearMonth) : SettingsDestination

    data object Categories : SettingsDestination

    data object Wallets : SettingsDestination

    data object ManageProviders : SettingsDestination

    data object ChangePassword : SettingsDestination
}
