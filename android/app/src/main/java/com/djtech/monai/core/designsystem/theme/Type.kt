package com.djtech.monai.core.designsystem.theme

import androidx.compose.material3.Typography
import androidx.compose.runtime.Immutable
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontVariation
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.LineHeightStyle
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.sp
import com.djtech.monai.R

/** Plus Jakarta Sans, bundled as one variable font (wght 200–800). */
val PlusJakartaSans = FontFamily(
    listOf(
        FontWeight.Normal,
        FontWeight.Medium,
        FontWeight.SemiBold,
        FontWeight.Bold,
        FontWeight.ExtraBold,
    )
        .map { weight ->
            Font(
                resId = R.font.plus_jakarta_sans,
                weight = weight,
                variationSettings = FontVariation.Settings(FontVariation.weight(weight.weight)),
            )
        },
)

private val Centered = LineHeightStyle(
    alignment = LineHeightStyle.Alignment.Center,
    trim = LineHeightStyle.Trim.None,
)

private fun style(
    size: Int,
    lineHeight: Int,
    weight: FontWeight,
    letterSpacing: TextUnit = 0.sp,
) = TextStyle(
    fontFamily = PlusJakartaSans,
    fontWeight = weight,
    fontSize = size.sp,
    lineHeight = lineHeight.sp,
    letterSpacing = letterSpacing,
    lineHeightStyle = Centered,
)

/**
 * The design's type scale mapped onto Material slots:
 *
 * | Slot           | Size/line | Use                                      |
 * |----------------|-----------|------------------------------------------|
 * | displayLarge   | 40/48 B   | Amount being entered                     |
 * | displayMedium  | 36/44 B   | Total balance hero                       |
 * | displaySmall   | 32/40 B   | Onboarding headline, transaction amount  |
 * | headlineLarge  | 28/36 B   | Auth titles, wallet balance              |
 * | headlineMedium | 24/32 B   | Tab screen titles                        |
 * | headlineSmall  | 20/28 SB  | Section headings, sheet/dialog titles    |
 * | titleLarge     | 18/26 SB  | Top bar title, profile name              |
 * | titleMedium    | 16/24 SB  | List and card titles, large buttons      |
 * | titleSmall     | 15/22 M   | Settings rows                            |
 * | bodyLarge      | 16/24 R   | Inputs, paragraphs                       |
 * | bodyMedium     | 14/20 R   | Supporting copy                          |
 * | bodySmall      | 12/16 R   | Meta lines, helper text                  |
 * | labelLarge     | 14/20 SB  | Medium buttons, links                    |
 * | labelMedium    | 12/16 SB  | Field labels, chips, small buttons       |
 * | labelSmall     | 11/16 SB  | Nav labels, badges                       |
 */
val MonAITypography = Typography(
    displayLarge = style(
        40,
        48,
        FontWeight.Bold,
        (-0.5).sp,
    ),
    displayMedium = style(
        36,
        44,
        FontWeight.Bold,
        (-0.5).sp,
    ),
    displaySmall = style(
        32,
        40,
        FontWeight.Bold,
        (-0.5).sp,
    ),
    headlineLarge = style(
        28,
        36,
        FontWeight.Bold,
        (-0.25).sp,
    ),
    headlineMedium = style(
        24,
        32,
        FontWeight.Bold,
        (-0.25).sp,
    ),
    headlineSmall = style(20, 28, FontWeight.SemiBold),
    titleLarge = style(18, 26, FontWeight.SemiBold),
    titleMedium = style(16, 24, FontWeight.SemiBold),
    titleSmall = style(15, 22, FontWeight.Medium),
    bodyLarge = style(16, 24, FontWeight.Normal),
    bodyMedium = style(14, 20, FontWeight.Normal),
    bodySmall = style(12, 16, FontWeight.Normal),
    labelLarge = style(14, 20, FontWeight.SemiBold),
    labelMedium = style(12, 16, FontWeight.SemiBold),
    labelSmall = style(11, 16, FontWeight.SemiBold),
)

/** Styles the design uses that have no Material slot. Read via `MonAITheme.extendedTypography`. */
@Immutable
data class MonAIExtendedTypography(
    /** 28/36 bold, wallet card balances. */
    val amountLarge: TextStyle,
    /** 20/28 bold, budget percentage. */
    val amountMedium: TextStyle,
    /** 16/24 semibold, list-row amounts. */
    val amount: TextStyle,
    /** 13/18 regular, banners and dense rows. */
    val bodyCompact: TextStyle,
    /** 12/16 semibold uppercase with tracking; settings group headers. Uppercase the text yourself. */
    val overline: TextStyle,
)

val MonAIExtendedTypographyDefaults = MonAIExtendedTypography(
    amountLarge = style(28, 36, FontWeight.Bold).tabular(),
    amountMedium = style(20, 28, FontWeight.Bold).tabular(),
    amount = style(16, 24, FontWeight.SemiBold).tabular(),
    bodyCompact = style(13, 18, FontWeight.Normal),
    overline = style(
        12,
        16,
        FontWeight.SemiBold,
        0.4.sp,
    ),
)

/** Tabular figures, so digits line up in amounts. */
fun TextStyle.tabular(): TextStyle = copy(fontFeatureSettings = "tnum")
