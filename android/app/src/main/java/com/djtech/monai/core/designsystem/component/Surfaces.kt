package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** White card with a 1dp border and 16dp corners. Clickable when [onClick] is set. */
@Composable
fun MonAICard(
    modifier: Modifier = Modifier,
    onClick: (() -> Unit)? = null,
    contentPadding: PaddingValues = PaddingValues(MonAITheme.spacing.cardPadding),
    verticalArrangement: Arrangement.Vertical = Arrangement.spacedBy(MonAITheme.spacing.x3),
    content: @Composable ColumnScope.() -> Unit,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.lg)
    val border = BorderStroke(MonAITheme.sizes.border, colors.border)
    val body: @Composable () -> Unit = {
        Column(Modifier.padding(contentPadding), verticalArrangement = verticalArrangement, content = content)
    }
    if (onClick != null) {
        Surface(onClick = onClick, modifier = modifier, shape = shape, color = colors.surface, contentColor = colors.textPrimary, border = border, content = body)
    } else {
        Surface(modifier = modifier, shape = shape, color = colors.surface, contentColor = colors.textPrimary, border = border, content = body)
    }
}

/**
 * Indigo gradient card with the decorative circles: the balance hero, onboarding panel and
 * wallet cards. Content is white.
 */
@Composable
fun MonAIGradientCard(
    modifier: Modifier = Modifier,
    brush: Brush = MonAITheme.colors.heroGradient,
    cornerRadius: Dp = MonAITheme.radius.xxl,
    contentPadding: PaddingValues = PaddingValues(MonAITheme.spacing.x5),
    elevated: Boolean = true,
    decorated: Boolean = true,
    onClick: (() -> Unit)? = null,
    verticalArrangement: Arrangement.Vertical = Arrangement.spacedBy(MonAITheme.spacing.x4),
    content: @Composable ColumnScope.() -> Unit,
) {
    val shape = RoundedCornerShape(cornerRadius)
    val glow = MonAITheme.colors.primary.copy(alpha = 0.28f)
    Box(
        modifier = modifier
            .then(
                if (elevated && !MonAITheme.colors.isDark) {
                    Modifier.shadow(12.dp, shape, ambientColor = glow, spotColor = glow)
                } else {
                    Modifier
                },
            )
            .clip(shape)
            .background(brush)
            .then(if (onClick != null) Modifier.clickable(role = Role.Button, onClick = onClick) else Modifier),
    ) {
        if (decorated) {
            Box(
                Modifier
                    .align(Alignment.TopEnd)
                    .offset(x = 48.dp, y = (-56).dp)
                    .size(180.dp)
                    .clip(CircleShape)
                    .background(Color.White.copy(alpha = 0.08f)),
            )
        }
        Column(
            modifier = Modifier.padding(contentPadding),
            verticalArrangement = verticalArrangement,
            content = {
                CompositionLocalProvider(
                    LocalContentColor provides Color.White,
                ) { content() }
            },
        )
    }
}

enum class MonAITopBarNavigation { Back, Close, None }

/**
 * Screen header for pushed screens and full-screen forms: back/close, title, actions.
 * Applies the status-bar inset by default; pass `WindowInsets(0)` when the parent handles it.
 */
@Composable
fun MonAITopBar(
    title: String,
    modifier: Modifier = Modifier,
    navigation: MonAITopBarNavigation = MonAITopBarNavigation.Back,
    onNavigationClick: () -> Unit = {},
    navigationContentDescription: String = if (navigation == MonAITopBarNavigation.Close) "Close" else "Back",
    titleStyle: TextStyle = MonAITheme.typography.titleLarge,
    windowInsets: WindowInsets = WindowInsets.statusBars,
    actions: @Composable RowScope.() -> Unit = {},
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .windowInsetsPadding(windowInsets)
            .height(56.dp)
            // 44dp buttons sit 6dp in, so their icons line up with the 16dp content edge.
            .padding(horizontal = MonAITheme.spacing.x1_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        when (navigation) {
            MonAITopBarNavigation.Back -> MonAIIconButton(MonAIIcons.ArrowBack, navigationContentDescription, onNavigationClick)
            MonAITopBarNavigation.Close -> MonAIIconButton(MonAIIcons.Close, navigationContentDescription, onNavigationClick, tint = MonAITheme.colors.textSecondary)
            MonAITopBarNavigation.None -> Box(Modifier.padding(start = MonAITheme.spacing.x2_5))
        }
        Text(
            text = title,
            modifier = Modifier
                .weight(1f)
                .semantics { heading() },
            style = titleStyle,
            color = MonAITheme.colors.textPrimary,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
        )
        actions()
    }
}

/** Tab-screen title ("Transactions", "Settings") with an optional trailing action. */
@Composable
fun MonAIScreenTitle(
    title: String,
    modifier: Modifier = Modifier,
    action: (@Composable () -> Unit)? = null,
) {
    Row(modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        Text(
            text = title,
            modifier = Modifier
                .weight(1f)
                .semantics { heading() },
            style = MonAITheme.typography.headlineMedium,
            color = MonAITheme.colors.textPrimary,
        )
        action?.invoke()
    }
}

/** Section title with an optional "See all"-style link. */
@Composable
fun MonAISectionHeader(
    title: String,
    modifier: Modifier = Modifier,
    actionLabel: String? = null,
    onActionClick: () -> Unit = {},
    style: TextStyle = MonAITheme.typography.headlineSmall,
) {
    Row(modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        Text(
            text = title,
            modifier = Modifier
                .weight(1f)
                .semantics { heading() },
            style = style,
            color = MonAITheme.colors.textPrimary,
        )
        if (actionLabel != null) {
            MonAITextLink(actionLabel, onActionClick)
        }
    }
}

/** Inline indigo link with a 44dp touch height. */
@Composable
fun MonAITextLink(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    trailingIcon: ImageVector? = null,
    style: TextStyle = MonAITheme.typography.labelLarge,
) {
    Row(
        modifier = modifier
            .defaultMinSize(minHeight = MonAITheme.sizes.touchTarget)
            .clip(RoundedCornerShape(MonAITheme.radius.sm))
            .clickable(role = Role.Button, onClick = onClick)
            .padding(horizontal = MonAITheme.spacing.x1),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        Text(text, style = style, color = MonAITheme.colors.accent)
        if (trailingIcon != null) {
            Icon(trailingIcon, null, Modifier.size(MonAITheme.sizes.iconMd), tint = MonAITheme.colors.accent)
        }
    }
}

@Composable
fun MonAIDivider(modifier: Modifier = Modifier) {
    HorizontalDivider(modifier = modifier, thickness = MonAITheme.sizes.border, color = MonAITheme.colors.divider)
}

@PreviewLightDark
@Composable
private fun SurfacesPreview() {
    MonAITheme {
        Column(
            Modifier
                .background(MonAITheme.colors.background)
                .padding(bottom = 16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            MonAITopBar("Transaction", windowInsets = WindowInsets(0)) {
                MonAIIconButton(MonAIIcons.Edit, "Edit", onClick = {})
                MonAIIconButton(MonAIIcons.Delete, "Delete", onClick = {}, tint = MonAITheme.colors.error)
            }
            Column(Modifier.padding(horizontal = 16.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
                MonAIScreenTitle("Wallets") {
                    MonAIButton("Add wallet", onClick = {}, variant = MonAIButtonVariant.Tonal, size = MonAIButtonSize.Small, leadingIcon = MonAIIcons.Add)
                }
                MonAIGradientCard(Modifier.fillMaxWidth()) {
                    Text("Total balance · 4 wallets", style = MonAITheme.typography.labelLarge, color = MonAITheme.colors.onGradientMuted)
                    Text("Rp 12.450.000", style = MonAITheme.typography.displayMedium)
                }
                MonAISectionHeader("Wallets", actionLabel = "See all")
                MonAICard(Modifier.fillMaxWidth(), onClick = {}) {
                    Text("October budget", style = MonAITheme.typography.titleMedium)
                    MonAIDivider()
                    Text("21 days left", style = MonAITheme.typography.bodySmall, color = MonAITheme.colors.textTertiary)
                }
            }
        }
    }
}
