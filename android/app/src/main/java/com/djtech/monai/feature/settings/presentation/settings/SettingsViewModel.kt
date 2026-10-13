package com.djtech.monai.feature.settings.presentation.settings

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.BuildConfig
import com.djtech.monai.R
import com.djtech.monai.core.common.flow.WhileUiSubscribed
import com.djtech.monai.core.common.locale.AppLocaleManager
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.datastore.ThemePreferenceStore
import com.djtech.monai.core.model.AppLanguage
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.usecase.LogoutAllDevicesUseCase
import com.djtech.monai.feature.auth.domain.usecase.LogoutUseCase
import com.djtech.monai.feature.budgets.domain.usecase.ObserveBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.RefreshBudgetUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.RefreshCategoriesUseCase
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.profile.domain.usecase.RefreshUserUseCase
import com.djtech.monai.feature.settings.presentation.settings.mapper.canManageProviders
import com.djtech.monai.feature.settings.presentation.settings.mapper.toSettingsProfile
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsDialog
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsPane
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsSheet
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
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
import javax.inject.Inject

/**
 * The Settings hub: the profile card, this month's budget, counts of categories and wallets, the
 * theme and language, the admin section for provider managers, and signing out.
 */
@HiltViewModel
class SettingsViewModel @Inject constructor(
    observeUser: ObserveUserUseCase,
    private val refreshUser: RefreshUserUseCase,
    observeBudget: ObserveBudgetUseCase,
    private val refreshBudget: RefreshBudgetUseCase,
    observeCategories: ObserveCategoriesUseCase,
    private val refreshCategories: RefreshCategoriesUseCase,
    observeWallets: ObserveWalletsUseCase,
    private val logout: LogoutUseCase,
    private val logoutAllDevices: LogoutAllDevicesUseCase,
    private val themePreferenceStore: ThemePreferenceStore,
    private val localeManager: AppLocaleManager,
    clock: AppClock,
) : ViewModel() {

    private val month = clock.currentMonth()
    private val ui = MutableStateFlow(Ui(language = localeManager.currentLanguage()))

    private val content = combine(
        observeUser(),
        observeBudget(month),
        observeCategories(),
        observeWallets(),
        themePreferenceStore.themeMode,
    ) { user, budget, categories, wallets, themeMode ->
        SettingsState(
            month = month,
            profile = user?.toSettingsProfile(),
            budgetLimit = budget?.limitAmount,
            categoryCount = categories.size,
            walletCount = wallets.size,
            themeMode = themeMode,
            showAdmin = user.canManageProviders(),
            appVersion = BuildConfig.VERSION_NAME,
        )
    }

    val state: StateFlow<SettingsState> = combine(content, ui) { content, ui ->
        content.copy(
            language = ui.language,
            sheet = ui.sheet,
            dialog = ui.dialog,
            // A pane the user may no longer open falls back to the profile.
            pane = if (ui.pane == SettingsPane.Providers && !content.showAdmin) SettingsPane.Profile else ui.pane,
            isSigningOut = ui.isSigningOut,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, SettingsState(month = month))

    private val effectChannel = Channel<SettingsEffect>(Channel.BUFFERED)
    val effects: Flow<SettingsEffect> = effectChannel.receiveAsFlow()

    init {
        // Failures keep what is cached; every row has a sensible empty value.
        viewModelScope.launch { refreshUser() }
        viewModelScope.launch { refreshBudget(month) }
        viewModelScope.launch { refreshCategories() }
    }

    fun onIntent(intent: SettingsIntent) {
        when (intent) {
            is SettingsIntent.Open -> send(SettingsEffect.Navigate(intent.destination))
            is SettingsIntent.SelectPane -> ui.update { it.copy(pane = intent.pane) }
            is SettingsIntent.ShowSheet -> ui.update { it.copy(sheet = intent.sheet) }
            SettingsIntent.DismissSheet -> ui.update { it.copy(sheet = null) }
            is SettingsIntent.PickTheme -> {
                ui.update { it.copy(sheet = null) }
                viewModelScope.launch { themePreferenceStore.setThemeMode(intent.mode) }
            }

            is SettingsIntent.PickLanguage -> pickLanguage(intent.language)
            SettingsIntent.SignOut -> ui.update { it.copy(dialog = SettingsDialog.SignOut) }
            SettingsIntent.SignOutAllDevices -> ui.update { it.copy(dialog = SettingsDialog.SignOutAllDevices) }
            SettingsIntent.ConfirmDialog -> confirm()
            SettingsIntent.DismissDialog -> ui.update { it.copy(dialog = null) }
        }
    }

    private fun pickLanguage(language: AppLanguage) {
        ui.update { it.copy(sheet = null, language = language) }
        // Recreates the activity in the new language; this ViewModel survives it.
        if (language != localeManager.currentLanguage()) localeManager.setLanguage(language)
    }

    private fun confirm() {
        val dialog = ui.value.dialog ?: return
        if (ui.value.isSigningOut) return
        ui.update { it.copy(dialog = null, isSigningOut = true) }
        viewModelScope.launch {
            val result = when (dialog) {
                SettingsDialog.SignOut -> logout()
                SettingsDialog.SignOutAllDevices -> logoutAllDevices()
            }
            // On success the session ends and the app leaves for Sign in.
            ui.update { it.copy(isSigningOut = false) }
            if (result is Outcome.Failure) {
                send(
                    SettingsEffect.ShowMessage(
                        UiText.Resource(
                            if (result.error == AuthError.Network) {
                                R.string.settings_error_network
                            } else {
                                R.string.settings_error_sign_out
                            },
                        ),
                        isOffline = result.error == AuthError.Network,
                    ),
                )
            }
        }
    }

    private fun send(effect: SettingsEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

/** Screen-local state; the rest comes from the caches and stores. */
private data class Ui(
    val language: AppLanguage,
    val sheet: SettingsSheet? = null,
    val dialog: SettingsDialog? = null,
    val pane: SettingsPane = SettingsPane.Profile,
    val isSigningOut: Boolean = false,
)
