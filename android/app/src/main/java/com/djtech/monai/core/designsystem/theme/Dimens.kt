package com.djtech.monai.core.designsystem.theme

import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Shapes
import androidx.compose.runtime.Immutable
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

/**
 * Spacing on a 2dp grid, named by multiples of 4dp (`x3` = 12dp). Read via `MonAITheme.spacing`.
 * Semantic aliases at the bottom cover the layouts the design repeats.
 */
@Immutable
data class MonAISpacing(
    val x0_5: Dp = 2.dp,
    val x1: Dp = 4.dp,
    val x1_5: Dp = 6.dp,
    val x2: Dp = 8.dp,
    val x2_5: Dp = 10.dp,
    val x3: Dp = 12.dp,
    val x3_5: Dp = 14.dp,
    val x4: Dp = 16.dp,
    val x5: Dp = 20.dp,
    val x6: Dp = 24.dp,
    val x8: Dp = 32.dp,
    val x10: Dp = 40.dp,
    /** Side padding of tab screens and full-screen forms. */
    val screenHorizontal: Dp = 16.dp,
    /** Side padding of auth, onboarding, sheets and dialogs. */
    val screenHorizontalWide: Dp = 24.dp,
    /** Top padding of tab screens. */
    val screenTop: Dp = 24.dp,
    /** Gap between Home sections. */
    val sectionGap: Dp = 20.dp,
    /** Gap between a section header and its content, and between Settings groups. */
    val sectionContentGap: Dp = 12.dp,
    /** Inner padding of cards. */
    val cardPadding: Dp = 16.dp,
    /** Label → input gap, and field → helper gap. */
    val fieldLabelGap: Dp = 6.dp,
)

/** Corner radii. Read via `MonAITheme.radius`. */
@Immutable
data class MonAIRadius(
    /** Tags like "ADMIN" and "DEFAULT". */
    val xs: Dp = 4.dp,
    /** Filter chips, receipt thumbnail. */
    val sm: Dp = 8.dp,
    /** Inputs, banners, snackbars, small stat cards. */
    val md: Dp = 12.dp,
    /** Picker options. */
    val mdl: Dp = 14.dp,
    /** Cards, wallet cards, number-pad keys. */
    val lg: Dp = 16.dp,
    /** App logo tile. */
    val xl: Dp = 18.dp,
    /** Balance hero, sheets, dialogs. */
    val xxl: Dp = 24.dp,
    /** Onboarding hero panel. */
    val xxxl: Dp = 32.dp,
)

/** Fixed component sizes. Read via `MonAITheme.sizes`. */
@Immutable
data class MonAISizes(
    /** Minimum touch target and icon-button size. */
    val touchTarget: Dp = 44.dp,
    val buttonLarge: Dp = 56.dp,
    val buttonMedium: Dp = 48.dp,
    val buttonSmall: Dp = 36.dp,
    val input: Dp = 56.dp,
    val inputCompact: Dp = 48.dp,
    val searchField: Dp = 48.dp,
    val quickAddField: Dp = 52.dp,
    val segmentedControl: Dp = 44.dp,
    val filterChip: Dp = 32.dp,
    val choiceChip: Dp = 40.dp,
    val listRowMin: Dp = 64.dp,
    val settingsRow: Dp = 56.dp,
    val pickerOption: Dp = 64.dp,
    val navBar: Dp = 80.dp,
    val navIndicatorWidth: Dp = 64.dp,
    val navIndicatorHeight: Dp = 32.dp,
    /** Medium-width (tablet portrait) navigation rail. */
    val navRail: Dp = 80.dp,
    val navRailIndicatorWidth: Dp = 56.dp,
    /** Expanded-width (tablet landscape) permanent drawer. */
    val navDrawer: Dp = 240.dp,
    val navDrawerItem: Dp = 48.dp,
    val navDrawerLogo: Dp = 32.dp,
    val fab: Dp = 56.dp,
    val avatarSmall: Dp = 32.dp,
    val avatarMedium: Dp = 40.dp,
    val avatarLarge: Dp = 44.dp,
    val avatarXLarge: Dp = 64.dp,
    val stateIcon: Dp = 64.dp,
    val dialogIcon: Dp = 48.dp,
    val iconXs: Dp = 14.dp,
    val iconSm: Dp = 16.dp,
    val iconMd: Dp = 18.dp,
    val iconLg: Dp = 20.dp,
    val icon: Dp = 24.dp,
    val iconXl: Dp = 28.dp,
    val iconXxl: Dp = 32.dp,
    val progressTrack: Dp = 8.dp,
    val sheetHandleWidth: Dp = 32.dp,
    val sheetHandleHeight: Dp = 4.dp,
    val dialogWidth: Dp = 312.dp,
    val walletCardWidth: Dp = 300.dp,
    val walletCardHeight: Dp = 160.dp,
    val border: Dp = 1.dp,
    val borderFocused: Dp = 2.dp,
)

/** Material shapes so stock M3 components pick up the design's radii. */
internal fun MonAIRadius.toShapes() = Shapes(
    extraSmall = RoundedCornerShape(xs),
    small = RoundedCornerShape(sm),
    medium = RoundedCornerShape(md),
    large = RoundedCornerShape(lg),
    extraLarge = RoundedCornerShape(xxl),
)
