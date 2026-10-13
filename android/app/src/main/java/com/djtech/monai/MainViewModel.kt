package com.djtech.monai

import androidx.compose.runtime.Immutable
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.datastore.OnboardingStore
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.datastore.ThemePreferenceStore
import com.djtech.monai.core.model.ThemeMode
import com.djtech.monai.feature.auth.domain.usecase.ExpireSessionIfDueUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * @param onboardingCompleted onboarding was finished once, so the auth graph opens on Sign in.
 * @param themeMode the theme picked in Settings.
 */
@Immutable
data class MainState(
    val sessionState: SessionState = SessionState.Loading,
    val onboardingCompleted: Boolean = false,
    val themeMode: ThemeMode = ThemeMode.SYSTEM,
) {
    val isLoading: Boolean get() = sessionState == SessionState.Loading
}

/** Drives the app root: the splash stays up while Loading, then auth or main is shown. */
@HiltViewModel
class MainViewModel @Inject constructor(
    private val sessionStore: SessionStore,
    onboardingStore: OnboardingStore,
    themePreferenceStore: ThemePreferenceStore,
    private val expireSessionIfDue: ExpireSessionIfDueUseCase,
) : ViewModel() {
    // combine waits for every store, so the splash also covers the onboarding and theme reads.
    val state: StateFlow<MainState> =
        combine(
            sessionStore.sessionState,
            onboardingStore.isCompleted,
            themePreferenceStore.themeMode,
            ::MainState,
        ).stateIn(viewModelScope, WhileUiSubscribed, MainState())

    /** The app came to the foreground: a token past its expiry is expired now, not on the next 401. */
    fun onAppForegrounded() {
        viewModelScope.launch { expireSessionIfDue() }
    }

    /** The user dismissed the session-expired dialog: move on to the signed-out graph. */
    fun onSessionExpiredAcknowledged() {
        viewModelScope.launch { sessionStore.acknowledgeExpiry() }
    }
}
