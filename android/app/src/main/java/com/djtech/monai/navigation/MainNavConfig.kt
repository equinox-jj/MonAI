package com.djtech.monai.navigation

import androidx.compose.animation.ContentTransform
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.ui.window.DialogProperties
import androidx.navigation3.scene.DialogSceneStrategy
import androidx.navigation3.ui.NavDisplay
import com.djtech.monai.core.designsystem.component.ScreenPlacement

/** How the signed-in app's entries are laid out at the current width; [isExpanded] is a wide screen. */
internal class MainNavConfig(val isExpanded: Boolean) {
    // On a wide screen the form opens as a side sheet over what is behind it.
    val formMetadata = if (isExpanded) {
        DialogSceneStrategy.dialog(DialogProperties(usePlatformDefaultWidth = false))
    } else {
        emptyMap()
    }

    val formPlacement = if (isExpanded) ScreenPlacement.SideSheet else ScreenPlacement.FullScreen

    // Back from a tab's root returns to Home: cross-fade like a tab switch instead of shrinking the screen away.
    val tabRootMetadata = NavDisplay.predictivePopTransitionSpec { ContentTransform(fadeIn(), fadeOut()) }
}
