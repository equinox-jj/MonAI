package com.djtech.monai.core.designsystem.theme

import androidx.compose.runtime.Immutable
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color

/** Raw palette from the MonAI design canvas. Screens use [MonAIColors], not these. */
internal object Palette {
    val Indigo950 = Color(0xFF1A1842)
    val Indigo900 = Color(0xFF24225A)
    val Indigo850 = Color(0xFF2C2B71)
    val Indigo800 = Color(0xFF322F8F)
    val Indigo700 = Color(0xFF3C36B3)
    val Indigo600 = Color(0xFF4A45D6)
    val Indigo500 = Color(0xFF5B5CEB)
    val Indigo400 = Color(0xFF7A7FF8)
    val Indigo300 = Color(0xFF9EA5FF)
    val Indigo200 = Color(0xFFC4C9FF)
    val Indigo100 = Color(0xFFE0E3FF)
    val Indigo50 = Color(0xFFEEF0FF)

    val Lime = Color(0xFFC8F169)

    val Gray950 = Color(0xFF060911)
    val Gray925 = Color(0xFF0B0F1A)
    val Gray900 = Color(0xFF101828)
    val Gray800 = Color(0xFF1D2939)
    val Gray700 = Color(0xFF344054)
    val Gray600 = Color(0xFF475467)
    val Gray500 = Color(0xFF667085)
    val Gray400 = Color(0xFF98A2B3)
    val Gray300 = Color(0xFFD0D5DD)
    val Gray200 = Color(0xFFE4E7EC)
    val Gray100 = Color(0xFFF0F2F5)
    val Gray50 = Color(0xFFF7F8FA)
    val White = Color(0xFFFFFFFF)

    val Red900 = Color(0xFF7A271A)
    val Red700 = Color(0xFFB42318)
    val Red600 = Color(0xFFD92D20)
    val Red400 = Color(0xFFF97066)
    val Red200 = Color(0xFFFECDCA)
    val Red50 = Color(0xFFFEF3F2)

    val Green700 = Color(0xFF067647)
    val Green600 = Color(0xFF079455)
    val Green400 = Color(0xFF47CD89)
    val Green50 = Color(0xFFECFDF3)

    val Amber900 = Color(0xFF93370D)
    val Amber600 = Color(0xFFDC6803)
    val Amber400 = Color(0xFFFDB022)
    val Amber200 = Color(0xFFFEDF89)
    val Amber50 = Color(0xFFFFFAEB)

    val Cyan800 = Color(0xFF155E75)
    val Cyan700 = Color(0xFF0E7490)
    val Cyan600 = Color(0xFF0891B2)
    val Cyan400 = Color(0xFF22D3EE)
    val Cyan100 = Color(0xFFCFFAFE)
    val Emerald800 = Color(0xFF05603A)
}

/**
 * Semantic colors. Read them through `MonAITheme.colors`.
 *
 * Naming: `text*` for foreground copy, `surface*` for fills, `border*` for strokes,
 * and paired `x`/`xContainer`/`onXContainer` for status colors.
 */
@Immutable
data class MonAIColors(
    val isDark: Boolean,
    // Brand
    /** Filled buttons, FAB, selected radio. Stays indigo 600 in dark mode. */
    val primary: Color,
    val onPrimary: Color,
    /** Links, icon accents, active tab icon. */
    val accent: Color,
    /** 2dp focus ring and selected-option border. */
    val focus: Color,
    val primaryContainer: Color,
    val onPrimaryContainer: Color,
    /** Border of a selected filter chip, dashed empty-state border. */
    val primaryContainerBorder: Color,
    /** Lime highlight used for badges and pills on the indigo gradient. */
    val highlight: Color,
    val onHighlight: Color,
    /** Secondary text on the indigo gradient. */
    val onGradientMuted: Color,
    val heroGradientStart: Color,
    val heroGradientEnd: Color,
    // Surfaces
    val background: Color,
    val surface: Color,
    /** Inputs, segmented-control track, progress track. */
    val surfaceSunken: Color,
    /** Number-pad keys. */
    val surfaceKey: Color,
    val inverseSurface: Color,
    val onInverseSurface: Color,
    val inverseAccent: Color,
    val scrim: Color,
    // Text
    val textPrimary: Color,
    val textSecondary: Color,
    val textTertiary: Color,
    /** Disabled text, chevrons, version footer. */
    val textDisabled: Color,
    /** Icon buttons in top bars and outlined button labels. */
    val iconStrong: Color,
    // Strokes
    val border: Color,
    val borderStrong: Color,
    val divider: Color,
    // Money
    val expense: Color,
    val expenseContainer: Color,
    val income: Color,
    val incomeContainer: Color,
    val transfer: Color,
    // Status
    val error: Color,
    val errorText: Color,
    val errorContainer: Color,
    val onErrorContainer: Color,
    val errorContainerBorder: Color,
    val success: Color,
    val successText: Color,
    val warning: Color,
    val warningContainer: Color,
    val onWarningContainer: Color,
    val warningContainerBorder: Color,
    // Disabled controls
    val disabledContainer: Color,
    val disabledContent: Color,
) {
    val heroGradient: Brush get() = Brush.linearGradient(listOf(heroGradientStart, heroGradientEnd))
}

val LightMonAIColors = MonAIColors(
    isDark = false,
    primary = Palette.Indigo600,
    onPrimary = Palette.White,
    accent = Palette.Indigo600,
    focus = Palette.Indigo500,
    primaryContainer = Palette.Indigo50,
    onPrimaryContainer = Palette.Indigo700,
    primaryContainerBorder = Palette.Indigo200,
    highlight = Palette.Lime,
    onHighlight = Palette.Indigo950,
    onGradientMuted = Palette.Indigo100,
    heroGradientStart = Palette.Indigo700,
    heroGradientEnd = Palette.Indigo500,
    background = Palette.Gray50,
    surface = Palette.White,
    surfaceSunken = Palette.Gray100,
    surfaceKey = Palette.Gray50,
    inverseSurface = Palette.Gray900,
    onInverseSurface = Palette.White,
    inverseAccent = Palette.Indigo300,
    scrim = Palette.Gray900.copy(alpha = 0.48f),
    textPrimary = Palette.Gray900,
    textSecondary = Palette.Gray600,
    textTertiary = Palette.Gray500,
    textDisabled = Palette.Gray400,
    iconStrong = Palette.Gray700,
    border = Palette.Gray200,
    borderStrong = Palette.Gray300,
    divider = Palette.Gray100,
    expense = Palette.Red600,
    expenseContainer = Palette.Red50,
    income = Palette.Green600,
    incomeContainer = Palette.Green50,
    transfer = Palette.Gray900,
    error = Palette.Red600,
    errorText = Palette.Red700,
    errorContainer = Palette.Red50,
    onErrorContainer = Palette.Red900,
    errorContainerBorder = Palette.Red200,
    success = Palette.Green600,
    successText = Palette.Green700,
    warning = Palette.Amber600,
    warningContainer = Palette.Amber50,
    onWarningContainer = Palette.Amber900,
    warningContainerBorder = Palette.Amber200,
    disabledContainer = Palette.Gray200,
    disabledContent = Palette.Gray400,
)

val DarkMonAIColors = MonAIColors(
    isDark = true,
    primary = Palette.Indigo600,
    onPrimary = Palette.White,
    accent = Palette.Indigo300,
    focus = Palette.Indigo300,
    primaryContainer = Palette.Indigo900,
    onPrimaryContainer = Palette.Indigo200,
    primaryContainerBorder = Palette.Indigo800,
    highlight = Palette.Lime,
    onHighlight = Palette.Indigo950,
    onGradientMuted = Palette.Indigo100,
    heroGradientStart = Palette.Indigo800,
    heroGradientEnd = Palette.Indigo600,
    background = Palette.Gray925,
    surface = Palette.Gray900,
    surfaceSunken = Palette.Gray950,
    surfaceKey = Palette.Gray800,
    inverseSurface = Palette.Gray50,
    onInverseSurface = Palette.Gray900,
    inverseAccent = Palette.Indigo600,
    scrim = Palette.Gray950.copy(alpha = 0.64f),
    textPrimary = Palette.Gray50,
    textSecondary = Palette.Gray300,
    textTertiary = Palette.Gray400,
    textDisabled = Palette.Gray500,
    iconStrong = Palette.Gray300,
    border = Palette.Gray800,
    borderStrong = Palette.Gray700,
    divider = Palette.Gray800,
    expense = Palette.Red400,
    expenseContainer = Palette.Red600.copy(alpha = 0.20f),
    income = Palette.Green400,
    incomeContainer = Palette.Green600.copy(alpha = 0.22f),
    transfer = Palette.Gray50,
    error = Palette.Red400,
    errorText = Palette.Red400,
    errorContainer = Palette.Red600.copy(alpha = 0.16f),
    onErrorContainer = Palette.Red200,
    errorContainerBorder = Palette.Red600.copy(alpha = 0.40f),
    success = Palette.Green400,
    successText = Palette.Green400,
    warning = Palette.Amber400,
    warningContainer = Palette.Amber600.copy(alpha = 0.16f),
    onWarningContainer = Palette.Amber200,
    warningContainerBorder = Palette.Amber600.copy(alpha = 0.40f),
    disabledContainer = Palette.Gray800,
    disabledContent = Palette.Gray500,
)

/** Wallet card gradients by wallet type, light and dark. */
@Immutable
data class WalletGradient(val start: Color, val end: Color, val muted: Color) {
    val brush: Brush get() = Brush.linearGradient(listOf(start, end))
}

object WalletGradients {
    fun bank(dark: Boolean) =
        if (dark) WalletGradient(Palette.Indigo800, Palette.Indigo600, Palette.Indigo100)
        else WalletGradient(Palette.Indigo700, Palette.Indigo500, Palette.Indigo100)

    fun bankAlt(dark: Boolean) =
        if (dark) WalletGradient(Palette.Indigo850, Palette.Indigo700, Palette.Indigo100)
        else WalletGradient(Palette.Indigo800, Palette.Indigo600, Palette.Indigo100)

    fun eWallet(dark: Boolean) =
        if (dark) WalletGradient(Palette.Cyan800, Palette.Cyan700, Palette.Cyan100)
        else WalletGradient(Palette.Cyan700, Palette.Cyan600, Palette.Cyan100)

    fun cash(dark: Boolean) =
        if (dark) WalletGradient(Palette.Emerald800, Palette.Green700, Palette.Green50)
        else WalletGradient(Palette.Green700, Palette.Green600, Palette.Green50)
}

/**
 * Category colors. The server stores the light hex (`#F97316`); dark mode swaps it
 * for a lighter shade so it reads on dark surfaces. Unknown colors are used as-is.
 */
object CategoryColors {
    private val darkVariants = mapOf(
        0xFFF97316 to 0xFFFB923C, // orange (Food)
        0xFF0EA5E9 to 0xFF38BDF8, // sky (Transport)
        0xFF8B5CF6 to 0xFFA78BFA, // violet (Bills)
        0xFFEC4899 to 0xFFF472B6, // pink (Shopping)
        0xFF10B981 to 0xFF34D399, // emerald (Health)
        0xFFF59E0B to 0xFFFBBF24, // amber (Entertainment)
        0xFF64748B to 0xFF94A3B8, // slate (Other)
        0xFF14B8A6 to 0xFF2DD4BF, // teal (Salary)
        0xFF84CC16 to 0xFFA3E635, // lime (Bonus)
        0xFF6366F1 to 0xFF818CF8, // indigo
    ).mapKeys { Color(it.key) }.mapValues { Color(it.value) }

    /** Slate, used when a category has no color. */
    val Fallback = Color(0xFF64748B)

    /** The icon color for [color] in the current theme. */
    fun content(color: Color, dark: Boolean): Color =
        if (dark) darkVariants[color] ?: color else color

    /** The circle behind a category icon. */
    fun tint(color: Color, dark: Boolean): Color = color.copy(alpha = if (dark) 0.20f else 0.12f)

    /** Parses `#RRGGBB`; returns [Fallback] for null or malformed input. */
    fun parse(hex: String?): Color {
        val digits = hex?.removePrefix("#")?.takeIf { it.length == 6 } ?: return Fallback
        return digits.toLongOrNull(16)?.let { Color(0xFF000000 or it) } ?: Fallback
    }
}
