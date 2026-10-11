package com.djtech.monai.core.designsystem.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.staticCompositionLocalOf

private val LocalMonAIColors = staticCompositionLocalOf { LightMonAIColors }
private val LocalMonAIExtendedTypography = staticCompositionLocalOf { MonAIExtendedTypographyDefaults }
private val LocalMonAISpacing = staticCompositionLocalOf { MonAISpacing() }
private val LocalMonAIRadius = staticCompositionLocalOf { MonAIRadius() }
private val LocalMonAISizes = staticCompositionLocalOf { MonAISizes() }

/**
 * The app theme. No dynamic color: the design is brand-colored in both modes.
 *
 * Inside it, read tokens through the [MonAITheme] object. `MaterialTheme` is also set,
 * so stock M3 components follow the same colors, type and shapes.
 */
@Composable
fun MonAITheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    val colors = if (darkTheme) DarkMonAIColors else LightMonAIColors
    val radius = MonAIRadius()
    CompositionLocalProvider(
        LocalMonAIColors provides colors,
        LocalMonAIExtendedTypography provides MonAIExtendedTypographyDefaults,
        LocalMonAISpacing provides MonAISpacing(),
        LocalMonAIRadius provides radius,
        LocalMonAISizes provides MonAISizes(),
    ) {
        MaterialTheme(
            colorScheme = colors.toColorScheme(),
            typography = MonAITypography,
            shapes = radius.toShapes(),
            content = content,
        )
    }
}

object MonAITheme {
    val colors: MonAIColors
        @Composable @ReadOnlyComposable get() = LocalMonAIColors.current

    val typography: Typography
        @Composable @ReadOnlyComposable get() = MaterialTheme.typography

    val extendedTypography: MonAIExtendedTypography
        @Composable @ReadOnlyComposable get() = LocalMonAIExtendedTypography.current

    val spacing: MonAISpacing
        @Composable @ReadOnlyComposable get() = LocalMonAISpacing.current

    val radius: MonAIRadius
        @Composable @ReadOnlyComposable get() = LocalMonAIRadius.current

    val sizes: MonAISizes
        @Composable @ReadOnlyComposable get() = LocalMonAISizes.current
}

private fun MonAIColors.toColorScheme(): ColorScheme {
    val base = if (isDark) darkColorScheme() else lightColorScheme()
    return base.copy(
        primary = primary,
        onPrimary = onPrimary,
        primaryContainer = primaryContainer,
        onPrimaryContainer = onPrimaryContainer,
        inversePrimary = inverseAccent,
        secondary = accent,
        onSecondary = onPrimary,
        secondaryContainer = primaryContainer,
        onSecondaryContainer = onPrimaryContainer,
        tertiary = highlight,
        onTertiary = onHighlight,
        background = background,
        onBackground = textPrimary,
        surface = surface,
        onSurface = textPrimary,
        surfaceVariant = surfaceSunken,
        onSurfaceVariant = textSecondary,
        surfaceTint = surface,
        surfaceBright = surface,
        surfaceDim = background,
        surfaceContainerLowest = surface,
        surfaceContainerLow = surface,
        surfaceContainer = surface,
        surfaceContainerHigh = surface,
        surfaceContainerHighest = surfaceSunken,
        inverseSurface = inverseSurface,
        inverseOnSurface = onInverseSurface,
        error = error,
        onError = onPrimary,
        errorContainer = errorContainer,
        onErrorContainer = onErrorContainer,
        outline = borderStrong,
        outlineVariant = border,
        scrim = scrim,
    )
}
