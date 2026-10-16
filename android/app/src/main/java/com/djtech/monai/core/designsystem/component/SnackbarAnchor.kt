package com.djtech.monai.core.designsystem.component

import androidx.compose.runtime.Composable
import androidx.compose.runtime.Stable
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.LayoutCoordinates
import androidx.compose.ui.layout.layout
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.layout.positionInRoot
import androidx.compose.ui.node.GlobalPositionAwareModifierNode
import androidx.compose.ui.node.ModifierNodeElement
import androidx.compose.ui.unit.offset
import kotlin.math.roundToInt

/**
 * Lifts a screen's snackbar above controls pinned to its bottom (a Save button, a keypad). Mark the
 * controls with [snackbarAnchor] and pass the anchor to [MonAISnackbarHost]: the snackbar sits 20dp
 * above them, and back at [snackbarPlacement] while the screen shows no marked controls.
 */
@Stable
class SnackbarAnchor internal constructor() {
    // Root coordinates, updated as the host and the controls are placed.
    internal var hostBottom by mutableFloatStateOf(0f)
    internal var controlsTop by mutableStateOf<Float?>(null)

    internal val hasControls by derivedStateOf { controlsTop != null }

    /** How far the controls reach up from the bottom of the host, in px. */
    internal val lift: Int
        get() = controlsTop?.let { (hostBottom - it).roundToInt().coerceAtLeast(0) } ?: 0
}

@Composable
fun rememberSnackbarAnchor(): SnackbarAnchor = remember { SnackbarAnchor() }

/** Marks controls pinned to the bottom of the screen, so [anchor]'s snackbar sits above them. */
fun Modifier.snackbarAnchor(anchor: SnackbarAnchor): Modifier = this then SnackbarAnchorElement(anchor)

/** The host's side: tracks where it ends and, while controls are marked, rises above them. */
internal fun Modifier.trackSnackbarAnchor(anchor: SnackbarAnchor): Modifier =
    onGloballyPositioned { anchor.hostBottom = it.positionInRoot().y + it.size.height }

internal fun Modifier.liftAboveSnackbarAnchor(anchor: SnackbarAnchor): Modifier = layout { measurable, constraints ->
    // Read while laying out, so following the controls (up with the keyboard) doesn't recompose.
    val lift = anchor.lift
    val placeable = measurable.measure(constraints.offset(vertical = -lift))
    layout(placeable.width, placeable.height + lift) { placeable.place(0, 0) }
}

private data class SnackbarAnchorElement(val anchor: SnackbarAnchor) : ModifierNodeElement<SnackbarAnchorNode>() {
    override fun create() = SnackbarAnchorNode(anchor)

    override fun update(node: SnackbarAnchorNode) {
        node.anchor = anchor
    }
}

private class SnackbarAnchorNode(var anchor: SnackbarAnchor) : Modifier.Node(), GlobalPositionAwareModifierNode {
    override fun onGloballyPositioned(coordinates: LayoutCoordinates) {
        anchor.controlsTop = coordinates.positionInRoot().y
    }

    // The controls left with a change of screen state, so the snackbar settles back at the bottom.
    override fun onDetach() {
        anchor.controlsTop = null
    }
}
