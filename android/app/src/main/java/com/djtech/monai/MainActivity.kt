package com.djtech.monai

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.navigation.MonAIApp
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    private val viewModel: MainViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        // Must run before super.onCreate. The splash stays until the stored session is read,
        // so the first frame is already the right graph.
        installSplashScreen().setKeepOnScreenCondition {
            viewModel.state.value.isLoading
        }

        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            val systemDark = isSystemInDarkTheme()
            var darkTheme by rememberSaveable { mutableStateOf(systemDark) }
            val state by viewModel.state.collectAsStateWithLifecycle()

            MonAITheme(darkTheme = darkTheme) {
                MonAIApp(state, viewModel::onSessionExpiredAcknowledged)
            }
        }
    }

    // Launch and every return to the foreground: the token may have expired while the app was away.
    override fun onStart() {
        super.onStart()
        viewModel.onAppForegrounded()
    }
}
