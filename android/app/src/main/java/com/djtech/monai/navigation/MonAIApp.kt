package com.djtech.monai.navigation

import androidx.compose.animation.Crossfade
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.navigation3.runtime.entryProvider
import androidx.navigation3.runtime.rememberNavBackStack
import androidx.navigation3.ui.NavDisplay
import com.djtech.monai.R
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.designsystem.theme.MonAITheme

/**
 * App root. The session decides the graph, so signing in, signing out and an expired
 * token (SessionStore clears it) all switch graphs here. Leaving a graph drops its
 * back stacks, so the next sign-in starts fresh on Home.
 */
@Composable
fun MonAIApp(sessionState: SessionState, modifier: Modifier = Modifier) {
    Crossfade(
        targetState = sessionState,
        modifier = modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
        label = "session",
    ) { state ->
        when (state) {
            // MainActivity keeps the system splash on screen until the session is read.
            SessionState.Loading -> Unit
            SessionState.SignedOut -> AuthNavDisplay()
            SessionState.SignedIn -> MainShell()
        }
    }
}

@Composable
private fun AuthNavDisplay() {
    val backStack = rememberNavBackStack(WelcomeRoute)
    NavDisplay(
        backStack = backStack,
        onBack = { backStack.removeLastOrNull() },
        entryProvider = entryProvider {
            entry<WelcomeRoute> { PlaceholderScreen(stringResource(R.string.placeholder_welcome)) }
        },
    )
}
