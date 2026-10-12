package com.djtech.monai.feature.auth.presentation.onboarding

import androidx.compose.runtime.Immutable

/** The onboarding pages, in order. */
enum class OnboardingPage { Capture, Wallets, Insights }

@Immutable
data class OnboardingState(val page: Int = 0) {
    val pageCount: Int get() = OnboardingPage.entries.size
    val isLastPage: Boolean get() = page == pageCount - 1
}

sealed interface OnboardingIntent {
    data object Next : OnboardingIntent
    data object Back : OnboardingIntent
    data object Skip : OnboardingIntent
    data object CreateAccount : OnboardingIntent
    data object SignIn : OnboardingIntent

    /** The pager came to rest on [page], e.g. after a swipe. */
    data class PageSettled(val page: Int) : OnboardingIntent
}

sealed interface OnboardingEffect {
    data object NavigateToRegister : OnboardingEffect
    data object NavigateToSignIn : OnboardingEffect
}
