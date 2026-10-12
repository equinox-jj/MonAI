package com.djtech.monai.feature.auth.presentation.onboarding

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class OnboardingViewModel @Inject constructor(
    private val savedState: SavedStateHandle,
) : ViewModel() {

    // Mirrored into SavedStateHandle so the page survives process death.
    private val mutableState = MutableStateFlow(OnboardingState(savedState[KEY_PAGE] ?: 0))
    val state: StateFlow<OnboardingState> = mutableState.asStateFlow()

    private val effectChannel = Channel<OnboardingEffect>(Channel.BUFFERED)
    val effects: Flow<OnboardingEffect> = effectChannel.receiveAsFlow()

    fun onIntent(intent: OnboardingIntent) {
        when (intent) {
            OnboardingIntent.Next -> goTo(mutableState.value.page + 1)
            OnboardingIntent.Back -> goTo(mutableState.value.page - 1)
            is OnboardingIntent.PageSettled -> goTo(intent.page)
            OnboardingIntent.Skip,
            OnboardingIntent.CreateAccount -> send(OnboardingEffect.NavigateToRegister)

            OnboardingIntent.SignIn -> send(OnboardingEffect.NavigateToSignIn)
        }
    }

    private fun goTo(target: Int) {
        val page = target.coerceIn(0, OnboardingPage.entries.lastIndex)
        savedState[KEY_PAGE] = page
        mutableState.update { it.copy(page = page) }
    }

    private fun send(effect: OnboardingEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }

    private companion object {
        const val KEY_PAGE = "page"
    }
}
