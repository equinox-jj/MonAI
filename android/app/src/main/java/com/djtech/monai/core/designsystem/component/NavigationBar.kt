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
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.tooling.preview.PreviewLightDark
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
            items.take(half).forEachIndexed { i, item -> NavItem(item, i == selectedIndex) { onItemClick(i) } }
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
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1, Alignment.CenterVertically),
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
            .then(if (enabled && !colors.isDark) Modifier.shadow(8.dp, CircleShape, ambientColor = glow, spotColor = glow) else Modifier)
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
            MonAIBottomBar(monAIMainNavItems(), selectedIndex = 0, onItemClick = {}, onAddClick = {}, addContentDescription = "Add transaction")
            MonAIBottomBar(monAIMainNavItems(), selectedIndex = 1, onItemClick = {}, onAddClick = {}, addContentDescription = "Add transaction", addEnabled = false)
        }
    }
}
