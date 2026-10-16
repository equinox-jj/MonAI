package com.djtech.monai.navigation

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import androidx.navigation3.runtime.EntryProviderScope
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.designsystem.component.ScreenPlacement
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** The add/edit side sheet's width on a wide screen. */
private val SideSheetWidth = 440.dp

/**
 * An add/edit form's entry: full screen, or a side sheet over what is behind it on a wide screen.
 * [content] gets the modifier that sizes and shapes it, and the placement to hand its top bar.
 */
internal inline fun <reified K : NavKey> EntryProviderScope<NavKey>.formEntry(
    config: MainNavConfig,
    noinline content: @Composable (key: K, modifier: Modifier, placement: ScreenPlacement) -> Unit,
) {
    entry<K>(metadata = config.formMetadata) { key ->
        SideSheetEntry(asSideSheet = config.isExpanded) { modifier -> content(key, modifier, config.formPlacement) }
    }
}

@Composable
internal fun SideSheetEntry(asSideSheet: Boolean, content: @Composable (Modifier) -> Unit) {
    if (!asSideSheet) {
        content(Modifier)
        return
    }
    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.CenterEnd) {
        content(
            Modifier
                .width(SideSheetWidth)
                .fillMaxHeight()
                .clip(RoundedCornerShape(topStart = MonAITheme.radius.xxl, bottomStart = MonAITheme.radius.xxl))
                .background(MonAITheme.colors.surface),
        )
    }
}
