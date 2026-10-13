package com.djtech.monai

import android.graphics.Color
import android.os.Bundle
import androidx.activity.SystemBarStyle
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.ThemeMode
import com.djtech.monai.navigation.MonAIApp
import dagger.hilt.android.AndroidEntryPoint

// AppCompatActivity so a language picked in Settings applies on every API level.
@AndroidEntryPoint
class MainActivity : AppCompatActivity() {
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
            val state by viewModel.state.collectAsStateWithLifecycle()
            val darkTheme = when (state.themeMode) {
                ThemeMode.SYSTEM -> isSystemInDarkTheme()
                ThemeMode.LIGHT -> false
                ThemeMode.DARK -> true
            }
            // Status and navigation bar icons follow the app's theme, not the phone's.
            DisposableEffect(darkTheme) {
                enableEdgeToEdge(
                    statusBarStyle = SystemBarStyle.auto(Color.TRANSPARENT, Color.TRANSPARENT) { darkTheme },
                    navigationBarStyle = SystemBarStyle.auto(LightScrim, DarkScrim) { darkTheme },
                )
                onDispose {}
            }

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

// The default scrims enableEdgeToEdge uses for 3-button navigation.
private val LightScrim = Color.argb(
    0xe6,
    0xFF,
    0xFF,
    0xFF,
)
private val DarkScrim = Color.argb(
    0x80,
    0x1b,
    0x1b,
    0x1b,
)
