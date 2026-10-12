package com.djtech.monai.navigation

import androidx.compose.animation.Crossfade
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.navigation3.rememberViewModelStoreNavEntryDecorator
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import androidx.navigation3.runtime.entryProvider
import androidx.navigation3.runtime.rememberNavBackStack
import androidx.navigation3.runtime.rememberSaveableStateHolderNavEntryDecorator
import androidx.navigation3.ui.NavDisplay
import com.djtech.monai.MainState
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.auth.presentation.onboarding.OnboardingRoute
import com.djtech.monai.feature.auth.presentation.register.RegisterRoute
import com.djtech.monai.feature.auth.presentation.sessionexpired.SessionExpiredDialog
import com.djtech.monai.feature.auth.presentation.signin.SignInRoute

private enum class Graph { None, Auth, Main }

/**
 * App root. The session decides the graph, so signing in, signing out and an expired
 * token (SessionStore clears it) all switch graphs here. Leaving a graph drops its
 * back stacks, so the next sign-in starts fresh on Home.
 *
 * An expired session keeps the main graph on screen under [SessionExpiredDialog]; confirming it
 * calls [onSessionExpiredAcknowledged], and the auth graph then opens on Sign in.
 */
@Composable
fun MonAIApp(
    state: MainState,
    onSessionExpiredAcknowledged: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val graph = when (state.sessionState) {
        // MainActivity keeps the system splash on screen until the session is read.
        SessionState.Loading -> Graph.None
        SessionState.SignedOut -> Graph.Auth
        SessionState.SignedIn, SessionState.Expired -> Graph.Main
    }
    Crossfade(
        targetState = graph,
        modifier = modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
        label = "session",
    ) { target ->
        when (target) {
            Graph.None -> Unit
            Graph.Auth -> AuthNavDisplay(showOnboarding = !state.onboardingCompleted)
            Graph.Main -> MainShell()
        }
    }
    if (state.sessionState == SessionState.Expired) {
        SessionExpiredDialog(onSignInAgain = onSessionExpiredAcknowledged)
    }
}

/**
 * Onboarding only opens the graph on the first launch. Leaving it replaces it, so Sign in and
 * Register are always the root and back exits the app instead of returning to onboarding.
 */
@Composable
private fun AuthNavDisplay(showOnboarding: Boolean) {
    // The start key is only read when the stack is first created, so marking onboarding
    // completed while it is on screen doesn't reset the stack.
    val backStack = rememberNavBackStack(if (showOnboarding) WelcomeRoute else SignInRoute())
    NavDisplay(
        backStack = backStack,
        onBack = { backStack.removeLastOrNull() },
        // Scopes each entry's ViewModel to the entry, so it is cleared when the entry is popped.
        entryDecorators = listOf(
            rememberSaveableStateHolderNavEntryDecorator(),
            rememberViewModelStoreNavEntryDecorator(),
        ),
        entryProvider = entryProvider {
            entry<WelcomeRoute> {
                OnboardingRoute(
                    onNavigateToRegister = { backStack.switchTo(RegisterRoute()) },
                    onNavigateToSignIn = { backStack.switchTo(SignInRoute()) },
                )
            }
            // Switching between Register and Sign in hands over the typed email.
            entry<RegisterRoute> { key ->
                RegisterRoute(
                    initialEmail = key.email,
                    onNavigateToSignIn = { email -> backStack.switchTo(SignInRoute(email)) },
                )
            }
            entry<SignInRoute> { key ->
                SignInRoute(
                    initialEmail = key.email,
                    onNavigateToRegister = { email -> backStack.switchTo(RegisterRoute(email)) },
                )
            }
        },
    )
}

/** Replaces the top, so the auth graph never stacks screens the user could go back to. */
private fun NavBackStack<NavKey>.switchTo(key: NavKey) {
    removeLastOrNull()
    add(key)
}
