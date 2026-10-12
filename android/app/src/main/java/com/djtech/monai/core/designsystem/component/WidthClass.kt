package com.djtech.monai.core.designsystem.component

import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalWindowInfo
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/** Material window-size breakpoints: phone, tablet portrait, tablet landscape. */
enum class MonAIWidthClass { Compact, Medium, Expanded }

fun widthClassOf(width: Dp): MonAIWidthClass = when {
    width >= 840.dp -> MonAIWidthClass.Expanded
    width >= 600.dp -> MonAIWidthClass.Medium
    else -> MonAIWidthClass.Compact
}

/** The window's width class, which picks the navigation layout and one or two panes. */
@Composable
fun currentWidthClass(): MonAIWidthClass {
    val width = with(LocalDensity.current) { LocalWindowInfo.current.containerSize.width.toDp() }
    return widthClassOf(width)
}
