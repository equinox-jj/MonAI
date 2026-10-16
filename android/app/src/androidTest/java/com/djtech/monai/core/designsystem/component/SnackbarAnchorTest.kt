package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.SemanticsActions
import androidx.compose.ui.test.SemanticsMatcher
import androidx.compose.ui.test.getBoundsInRoot
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.theme.MonAITheme
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class SnackbarAnchorTest {

    @get:Rule
    val compose = createComposeRule()

    private var showControls by mutableStateOf(true)
    private var navigationBar = 0.dp

    private fun setContent() {
        compose.setContent {
            MonAITheme(darkTheme = false) {
                navigationBar = WindowInsets.navigationBars.asPaddingValues().calculateBottomPadding()
                val hostState = remember { SnackbarHostState() }
                val anchor = rememberSnackbarAnchor()
                LaunchedEffect(Unit) { hostState.showSnackbar("Saved", duration = SnackbarDuration.Indefinite) }
                Box(Modifier.fillMaxSize()) {
                    Column(Modifier.fillMaxSize()) {
                        Spacer(Modifier.weight(1f))
                        if (showControls) {
                            Box(
                                Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 16.dp)
                                    .height(48.dp)
                                    .snackbarAnchor(anchor)
                                    .testTag(CONTROLS),
                            )
                        }
                    }
                    MonAISnackbarHost(
                        hostState,
                        Modifier
                            .align(Alignment.BottomCenter)
                            .testTag(HOST),
                        anchor,
                    )
                }
            }
        }
    }

    private fun snackbarBottom(): Dp = compose.onNode(SemanticsMatcher.keyIsDefined(SemanticsActions.Dismiss))
        .getBoundsInRoot()
        .bottom

    @Test
    fun sitsTwentyDpAbovePinnedControls() {
        setContent()

        val controlsTop = compose.onNodeWithTag(CONTROLS).getBoundsInRoot().top
        assertEquals(20f, (controlsTop - snackbarBottom()).value, TOLERANCE)
    }

    @Test
    fun goesBackAboveTheNavigationBarOnceTheControlsLeave() {
        setContent()
        showControls = false
        compose.waitForIdle()

        val hostBottom = compose.onNodeWithTag(HOST).getBoundsInRoot().bottom
        assertEquals((navigationBar + 20.dp).value, (hostBottom - snackbarBottom()).value, TOLERANCE)
    }

    private companion object {
        const val CONTROLS = "controls"
        const val HOST = "host"
        const val TOLERANCE = 0.5f
    }
}
