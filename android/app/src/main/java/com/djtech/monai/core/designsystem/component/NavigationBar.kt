package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawing
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

@Immutable
data class MonAINavItem(
    val label: String,
    val icon: ImageVector,
    val selectedIcon: ImageVector = icon,
)

/**
 * The main bottom bar: four destinations with the raised "add" button in the middle.
 * [items] are split evenly around the button (two on each side in the design).
 *
 * @param addEnabled false greys the button out (offline).
 */
@Composable
fun MonAIBottomBar(
    items: List<MonAINavItem>,
    selectedIndex: Int,
    onItemClick: (Int) -> Unit,
    onAddClick: () -> Unit,
    addContentDescription: String,
    modifier: Modifier = Modifier,
    addEnabled: Boolean = true,
) {
    val colors = MonAITheme.colors
    val half = (items.size + 1) / 2
    Column(
        modifier
            .fillMaxWidth()
            .background(colors.surface),
    ) {
        Box(
            Modifier
                .fillMaxWidth()
                .height(MonAITheme.sizes.border)
                .background(colors.border),
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .height(MonAITheme.sizes.navBar - MonAITheme.sizes.border)
                .selectableGroup(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            items.take(half)
                .forEachIndexed { i, item -> NavItem(item, i == selectedIndex) { onItemClick(i) } }
            Box(Modifier.weight(1f), contentAlignment = Alignment.Center) {
                AddButton(onAddClick, addContentDescription, addEnabled)
            }
            items.drop(half).forEachIndexed { j, item ->
                val i = half + j
                NavItem(item, i == selectedIndex) { onItemClick(i) }
            }
        }
        Box(Modifier.navigationBarsPadding())
    }
}

@Composable
private fun RowScope.NavItem(item: MonAINavItem, selected: Boolean, onClick: () -> Unit) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    Column(
        modifier = Modifier
            .weight(1f)
            .fillMaxHeight()
            .selectable(
                selected = selected,
                onClick = onClick,
                role = Role.Tab,
                interactionSource = remember { MutableInteractionSource() },
                indication = ripple(bounded = false, radius = sizes.navIndicatorWidth / 2),
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(
            MonAITheme.spacing.x1,
            Alignment.CenterVertically,
        ),
    ) {
        Box(
            Modifier
                .size(sizes.navIndicatorWidth, sizes.navIndicatorHeight)
                .clip(CircleShape)
                .background(if (selected) colors.primaryContainer else colors.surface),
            contentAlignment = Alignment.Center,
        ) {
            Icon(
                imageVector = if (selected) item.selectedIcon else item.icon,
                contentDescription = null,
                tint = if (selected) colors.accent else colors.textTertiary,
            )
        }
        Text(
            text = item.label,
            style = MonAITheme.typography.labelSmall,
            color = if (selected) colors.textPrimary else colors.textTertiary,
            maxLines = 1,
        )
    }
}

@Composable
private fun AddButton(onClick: () -> Unit, contentDescription: String, enabled: Boolean) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val glow = colors.primary.copy(alpha = 0.35f)
    // 56dp button + 4dp ring in the page background color, raised so it breaks the bar's top edge.
    Box(
        modifier = Modifier
            .offset(y = (-15).dp)
            .size(sizes.fab + 8.dp)
            .then(
                if (enabled && !colors.isDark) {
                    Modifier.shadow(
                        8.dp,
                        CircleShape,
                        ambientColor = glow,
                        spotColor = glow,
                    )
                } else {
                    Modifier
                },
            )
            .clip(CircleShape)
            .background(if (enabled) colors.primary else colors.disabledContainer)
            .border(4.dp, colors.background, CircleShape)
            .clickable(enabled = enabled, role = Role.Button, onClick = onClick)
            .semantics { this.contentDescription = contentDescription },
        contentAlignment = Alignment.Center,
    ) {
        Icon(
            MonAIIcons.Add,
            contentDescription = null,
            modifier = Modifier.size(sizes.iconXl),
            tint = if (enabled) colors.onPrimary else colors.disabledContent,
        )
    }
}

/**
 * Medium-width navigation: an 80dp rail with the "add" button above the destinations.
 */
@Composable
fun MonAINavigationRail(
    items: List<MonAINavItem>,
    selectedIndex: Int,
    onItemClick: (Int) -> Unit,
    onAddClick: () -> Unit,
    addContentDescription: String,
    modifier: Modifier = Modifier,
    addEnabled: Boolean = true,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    Row(modifier.fillMaxHeight()) {
        Column(
            modifier = Modifier
                .width(sizes.navRail - sizes.border)
                .fillMaxHeight()
                .background(colors.surface)
                .windowInsetsPadding(
                    WindowInsets.safeDrawing.only(WindowInsetsSides.Vertical + WindowInsetsSides.Start),
                )
                .padding(vertical = MonAITheme.spacing.x6)
                .selectableGroup(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4),
        ) {
            AddSquareButton(
                onClick = onAddClick,
                enabled = addEnabled,
                modifier = Modifier
                    .padding(bottom = MonAITheme.spacing.x6)
                    .size(sizes.fab)
                    .semantics { contentDescription = addContentDescription },
            ) {
                Icon(
                    MonAIIcons.Add,
                    contentDescription = null,
                    modifier = Modifier.size(sizes.iconXl),
                )
            }
            items.forEachIndexed { i, item ->
                RailItem(
                    item,
                    i == selectedIndex,
                ) { onItemClick(i) }
            }
        }
        VerticalBorder()
    }
}

@Composable
private fun RailItem(item: MonAINavItem, selected: Boolean, onClick: () -> Unit) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    Column(
        modifier = Modifier
            .width(sizes.navRail)
            .selectable(
                selected = selected,
                onClick = onClick,
                role = Role.Tab,
                interactionSource = remember { MutableInteractionSource() },
                indication = ripple(bounded = false, radius = sizes.navRailIndicatorWidth / 2),
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        Box(
            Modifier
                .size(sizes.navRailIndicatorWidth, sizes.navIndicatorHeight)
                .clip(CircleShape)
                .background(if (selected) colors.primaryContainer else colors.surface),
            contentAlignment = Alignment.Center,
        ) {
            Icon(
                imageVector = if (selected) item.selectedIcon else item.icon,
                contentDescription = null,
                tint = if (selected) colors.accent else colors.textTertiary,
            )
        }
        Text(
            text = item.label,
            style = MonAITheme.typography.labelSmall,
            color = if (selected) colors.textPrimary else colors.textTertiary,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
        )
    }
}

/**
 * Expanded-width navigation: a 240dp permanent drawer with the app name, a full-width
 * "add" button and pill-shaped destinations.
 */
@Composable
fun MonAINavigationDrawer(
    title: String,
    items: List<MonAINavItem>,
    selectedIndex: Int,
    onItemClick: (Int) -> Unit,
    onAddClick: () -> Unit,
    addLabel: String,
    modifier: Modifier = Modifier,
    addEnabled: Boolean = true,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val spacing = MonAITheme.spacing
    Row(modifier.fillMaxHeight()) {
        Column(
            modifier = Modifier
                .width(sizes.navDrawer - sizes.border)
                .fillMaxHeight()
                .background(colors.surface)
                .windowInsetsPadding(
                    WindowInsets.safeDrawing.only(WindowInsetsSides.Vertical + WindowInsetsSides.Start),
                )
                .padding(vertical = spacing.x6, horizontal = spacing.x4)
                .selectableGroup(),
            verticalArrangement = Arrangement.spacedBy(spacing.x1),
        ) {
            Row(
                modifier = Modifier.padding(
                    start = spacing.x2,
                    end = spacing.x2,
                    bottom = spacing.x5,
                ),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(spacing.x2_5),
            ) {
                Box(
                    Modifier
                        .size(sizes.navDrawerLogo)
                        .clip(RoundedCornerShape(MonAITheme.radius.md))
                        .background(colors.primary),
                    contentAlignment = Alignment.Center,
                ) {
                    Icon(
                        MonAIIcons.AccountBalanceWallet,
                        null,
                        Modifier.size(sizes.iconLg),
                        tint = colors.onPrimary,
                    )
                }
                Text(
                    text = title,
                    style = MonAITheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold),
                    color = colors.textPrimary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
            AddSquareButton(
                onClick = onAddClick,
                enabled = addEnabled,
                modifier = Modifier
                    .padding(bottom = spacing.x4)
                    .fillMaxWidth()
                    .height(sizes.fab),
            ) {
                Row(
                    Modifier
                        .fillMaxSize()
                        .padding(horizontal = spacing.x5),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(spacing.x2_5),
                ) {
                    Icon(MonAIIcons.Add, contentDescription = null)
                    Text(
                        addLabel,
                        style = MonAITheme.typography.titleSmall.copy(fontWeight = FontWeight.SemiBold),
                    )
                }
            }
            items.forEachIndexed { i, item ->
                DrawerItem(
                    item,
                    i == selectedIndex,
                ) { onItemClick(i) }
            }
        }
        VerticalBorder()
    }
}

@Composable
private fun DrawerItem(item: MonAINavItem, selected: Boolean, onClick: () -> Unit) {
    val colors = MonAITheme.colors
    val content = if (selected) colors.onPrimaryContainer else colors.textSecondary
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .height(MonAITheme.sizes.navDrawerItem)
            .clip(CircleShape)
            .background(if (selected) colors.primaryContainer else colors.surface)
            .selectable(selected = selected, onClick = onClick, role = Role.Tab)
            .padding(horizontal = MonAITheme.spacing.x4),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Icon(
            if (selected) item.selectedIcon else item.icon,
            contentDescription = null,
            tint = content,
        )
        Text(
            item.label,
            style = MonAITheme.typography.labelLarge,
            color = content,
            maxLines = 1,
        )
    }
}

/** The primary "add" button of the rail and drawer: a rounded square rather than the bar's raised circle. */
@Composable
private fun AddSquareButton(
    onClick: () -> Unit,
    enabled: Boolean,
    modifier: Modifier = Modifier,
    content: @Composable () -> Unit,
) {
    val colors = MonAITheme.colors
    val shape: Shape = RoundedCornerShape(MonAITheme.radius.lg)
    val glow = colors.primary.copy(alpha = 0.3f)
    Box(
        modifier = modifier
            .then(
                if (enabled && !colors.isDark) {
                    Modifier.shadow(
                        6.dp,
                        shape,
                        ambientColor = glow,
                        spotColor = glow,
                    )
                } else {
                    Modifier
                },
            )
            .clip(shape)
            .background(if (enabled) colors.primary else colors.disabledContainer)
            .clickable(enabled = enabled, role = Role.Button, onClick = onClick),
        contentAlignment = Alignment.Center,
    ) {
        CompositionLocalProvider(
            LocalContentColor provides if (enabled) colors.onPrimary else colors.disabledContent,
            content = content,
        )
    }
}

@Composable
private fun VerticalBorder(width: Dp = MonAITheme.sizes.border) {
    Box(
        Modifier
            .width(width)
            .fillMaxHeight()
            .background(MonAITheme.colors.border),
    )
}

/** The four destinations from the design, for previews and the app shell. */
@Composable
fun monAIMainNavItems(
    home: String = "Home",
    transactions: String = "Transactions",
    wallets: String = "Wallets",
    settings: String = "Settings",
): List<MonAINavItem> = listOf(
    MonAINavItem(home, MonAIIcons.Home, MonAIIcons.HomeFilled),
    MonAINavItem(transactions, MonAIIcons.ReceiptLong, MonAIIcons.ReceiptLongFilled),
    MonAINavItem(wallets, MonAIIcons.AccountBalanceWallet, MonAIIcons.AccountBalanceWalletFilled),
    MonAINavItem(settings, MonAIIcons.Settings, MonAIIcons.SettingsFilled),
)

@PreviewLightDark
@Composable
private fun BottomBarPreview() {
    MonAITheme {
        Column(
            Modifier.background(MonAITheme.colors.background),
            verticalArrangement = Arrangement.spacedBy(24.dp),
        ) {
            Box(Modifier.height(16.dp))
            MonAIBottomBar(
                monAIMainNavItems(),
                selectedIndex = 0,
                onItemClick = {},
                onAddClick = {},
                addContentDescription = "Add transaction",
            )
            MonAIBottomBar(
                monAIMainNavItems(),
                selectedIndex = 1,
                onItemClick = {},
                onAddClick = {},
                addContentDescription = "Add transaction",
                addEnabled = false,
            )
        }
    }
}

@PreviewLightDark
@Composable
private fun RailAndDrawerPreview() {
    MonAITheme {
        Row(
            Modifier
                .height(480.dp)
                .background(MonAITheme.colors.background),
        ) {
            MonAINavigationRail(
                monAIMainNavItems(),
                selectedIndex = 0,
                onItemClick = {},
                onAddClick = {},
                addContentDescription = "Add transaction",
            )
            Box(Modifier.width(24.dp))
            MonAINavigationDrawer(
                "MonAI",
                monAIMainNavItems(),
                selectedIndex = 1,
                onItemClick = {},
                onAddClick = {},
                addLabel = "Add transaction",
            )
        }
    }
}
