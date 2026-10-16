package com.djtech.monai.core.designsystem.component

import android.content.Context
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SnackbarResult
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Stable
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import com.djtech.monai.core.common.ui.UiText
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

/**
 * A route's snackbars. [show] doesn't suspend, so effect handlers and callbacks can call it; the
 * screen draws [hostState] with [MonAISnackbarHost].
 */
@Stable
class MonAIMessenger internal constructor(
    val hostState: SnackbarHostState,
    private val scope: CoroutineScope,
    private val context: Context,
) {
    /** [onAction] runs if the user taps [actionLabel] before the snackbar times out. */
    fun show(
        message: UiText,
        icon: ImageVector? = null,
        iconTint: Color = Color.Unspecified,
        actionLabel: String? = null,
        onAction: () -> Unit = {},
    ) {
        val visuals = MonAISnackbarVisuals(
            message.asString(context),
            actionLabel = actionLabel,
            icon = icon,
            iconTint = iconTint,
        )
        scope.launch {
            if (hostState.showSnackbar(visuals) == SnackbarResult.ActionPerformed) onAction()
        }
    }
}

@Composable
fun rememberMonAIMessenger(): MonAIMessenger {
    val hostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    return remember(scope, context) { MonAIMessenger(hostState, scope, context) }
}
