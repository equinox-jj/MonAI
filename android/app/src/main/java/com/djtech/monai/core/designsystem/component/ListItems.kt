package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme

/**
 * Icon on a tinted circle, in a category's color. Pass the server's light hex parsed with
 * [CategoryColors.parse]; the dark-mode shade is picked here.
 */
@Composable
fun MonAICategoryIcon(
    icon: ImageVector,
    color: Color,
    modifier: Modifier = Modifier,
    size: Dp = MonAITheme.sizes.avatarMedium,
    iconSize: Dp = MonAITheme.sizes.iconLg,
) {
    val dark = MonAITheme.colors.isDark
    Box(
        modifier = modifier
            .size(size)
            .clip(CircleShape)
            .background(CategoryColors.tint(color, dark)),
        contentAlignment = Alignment.Center,
    ) {
        Icon(
            icon,
            null,
            Modifier.size(iconSize),
            tint = CategoryColors.content(color, dark),
        )
    }
}

enum class MoneyDirection {
    /** Red, "−Rp", north-east arrow. */
    Expense,

    /** Green, "+Rp", south-west arrow. */
    Income,

    /** Neutral text color, sync arrow. */
    Transfer,
}

@Composable
fun MoneyDirection.color(): Color = when (this) {
    MoneyDirection.Expense -> MonAITheme.colors.expense
    MoneyDirection.Income -> MonAITheme.colors.income
    MoneyDirection.Transfer -> MonAITheme.colors.transfer
}

@Composable
fun MoneyDirection.arrowIcon(): ImageVector = when (this) {
    MoneyDirection.Expense -> MonAIIcons.NorthEast
    MoneyDirection.Income -> MonAIIcons.SouthWest
    MoneyDirection.Transfer -> MonAIIcons.SyncAlt
}

/** An already-formatted amount ("−Rp 35.000") in its direction's color, with tabular figures. */
@Composable
fun MonAIAmountText(
    amount: String,
    direction: MoneyDirection,
    modifier: Modifier = Modifier,
    style: TextStyle = MonAITheme.extendedTypography.amount,
) {
    Text(
        amount,
        modifier = modifier,
        style = style,
        color = direction.color(),
        maxLines = 1,
    )
}

/**
 * Two-line row: leading slot, title + supporting line, trailing slot. 12/16dp padding and an
 * optional bottom divider, for rows stacked inside a [MonAICard] with no padding.
 */
@Composable
fun MonAIListItem(
    title: String,
    modifier: Modifier = Modifier,
    supporting: String? = null,
    leading: (@Composable () -> Unit)? = null,
    trailing: (@Composable () -> Unit)? = null,
    onClick: (() -> Unit)? = null,
    showDivider: Boolean = false,
) {
    val colors = MonAITheme.colors
    Column(modifier) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .then(if (onClick != null) Modifier.clickable(onClick = onClick) else Modifier)
                .padding(horizontal = MonAITheme.spacing.x4, vertical = MonAITheme.spacing.x3),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            leading?.invoke()
            Column(Modifier.weight(1f)) {
                Text(
                    title,
                    style = MonAITheme.typography.titleMedium,
                    color = colors.textPrimary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                if (supporting != null) {
                    Text(
                        supporting,
                        style = MonAITheme.typography.bodySmall,
                        color = colors.textTertiary,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis,
                    )
                }
            }
            trailing?.invoke()
        }
        if (showDivider) MonAIDivider()
    }
}

/**
 * A transaction in Home "Recent", the Transactions list, search results and wallet detail.
 *
 * @param meta e.g. "Food · GoPay · 12:40".
 * @param amount already formatted with its sign, e.g. "−Rp 35.000".
 */
@Composable
fun MonAITransactionRow(
    title: String,
    meta: String,
    amount: String,
    direction: MoneyDirection,
    categoryIcon: ImageVector,
    categoryColor: Color,
    modifier: Modifier = Modifier,
    hasReceipt: Boolean = false,
    receiptContentDescription: String = "Has receipt",
    onClick: (() -> Unit)? = null,
    showDivider: Boolean = true,
) {
    MonAIListItem(
        title = title,
        supporting = meta,
        modifier = modifier,
        onClick = onClick,
        showDivider = showDivider,
        leading = { MonAICategoryIcon(categoryIcon, categoryColor) },
        trailing = {
            Column(horizontalAlignment = Alignment.End) {
                MonAIAmountText(amount, direction)
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
                ) {
                    if (hasReceipt) {
                        Icon(
                            MonAIIcons.AttachFile,
                            receiptContentDescription,
                            Modifier.size(MonAITheme.sizes.iconSm),
                            tint = MonAITheme.colors.textTertiary,
                        )
                    }
                    Icon(
                        direction.arrowIcon(),
                        null,
                        Modifier.size(MonAITheme.sizes.iconSm),
                        tint = direction.color(),
                    )
                }
            }
        },
    )
}

/** Uppercase group header, a card of rows, and an optional footnote (Settings). */
@Composable
fun MonAISettingsGroup(
    title: String,
    modifier: Modifier = Modifier,
    footer: String? = null,
    content: @Composable ColumnScope.() -> Unit,
) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    Column(modifier, verticalArrangement = Arrangement.spacedBy(spacing.x1_5)) {
        Text(
            text = title.uppercase(),
            modifier = Modifier.padding(start = spacing.x1),
            style = MonAITheme.extendedTypography.overline,
            color = colors.textTertiary,
        )
        MonAICard(
            modifier = Modifier.fillMaxWidth(),
            contentPadding = PaddingValues(0.dp),
            verticalArrangement = Arrangement.Top,
            content = content,
        )
        if (footer != null) {
            Text(
                footer,
                Modifier.padding(start = spacing.x1),
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
            )
        }
    }
}

/**
 * 56dp settings row: icon, label, value, chevron.
 *
 * @param destructive red label and icon, e.g. "Delete account".
 */
@Composable
fun MonAISettingsRow(
    label: String,
    icon: ImageVector,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    value: String? = null,
    showChevron: Boolean = true,
    destructive: Boolean = false,
    iconTint: Color = if (destructive) MonAITheme.colors.errorText else MonAITheme.colors.accent,
    showDivider: Boolean = true,
) {
    val colors = MonAITheme.colors
    Column(modifier) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .height(MonAITheme.sizes.settingsRow)
                .clickable(role = Role.Button, onClick = onClick)
                .padding(horizontal = MonAITheme.spacing.x4),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            Icon(icon, null, tint = iconTint)
            Text(
                label,
                modifier = Modifier.weight(1f),
                style = MonAITheme.typography.titleSmall,
                color = if (destructive) colors.errorText else colors.textPrimary,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
            if (value != null) {
                Text(
                    value,
                    style = MonAITheme.extendedTypography.bodyCompact,
                    color = colors.textTertiary,
                    maxLines = 1,
                )
            }
            if (showChevron) {
                Icon(MonAIIcons.ChevronRight, null, tint = colors.textDisabled)
            }
        }
        if (showDivider) MonAIDivider()
    }
}

/**
 * Selectable card used in picker sheets (wallet, theme, language): leading slot, title with
 * optional tag, subtitle, radio indicator.
 */
@Composable
fun MonAIRadioOption(
    title: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    subtitle: String? = null,
    tag: String? = null,
    leading: (@Composable RowScope.() -> Unit)? = null,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val shape = RoundedCornerShape(MonAITheme.radius.mdl)
    Row(
        modifier = modifier
            .fillMaxWidth()
            .defaultMinSize(minHeight = sizes.pickerOption)
            .clip(shape)
            .background(if (selected) colors.primaryContainer else colors.surface)
            .border(
                width = if (selected) sizes.borderFocused else sizes.border,
                color = if (selected) colors.focus else colors.border,
                shape = shape,
            )
            .selectable(selected = selected, role = Role.RadioButton, onClick = onClick)
            .padding(horizontal = MonAITheme.spacing.x3_5, vertical = MonAITheme.spacing.x2),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        leading?.invoke(this)
        Column(Modifier.weight(1f)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
            ) {
                Text(
                    title,
                    style = MonAITheme.typography.titleSmall.copy(
                        fontWeight = MonAITheme.typography.titleMedium.fontWeight,
                    ),
                    color = colors.textPrimary,
                )
                if (tag != null) MonAITag(tag)
            }
            if (subtitle != null) {
                Text(subtitle, style = MonAITheme.typography.bodySmall, color = colors.textTertiary)
            }
        }
        Icon(
            imageVector = if (selected) MonAIIcons.RadioButtonChecked else MonAIIcons.RadioButtonUnchecked,
            contentDescription = null,
            tint = if (selected) colors.accent else colors.textDisabled,
        )
    }
}

@PreviewLightDark
@Composable
private fun ListItemsPreview() {
    MonAITheme {
        Column(
            Modifier
                .background(MonAITheme.colors.background)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            MonAICard(
                Modifier.fillMaxWidth(),
                contentPadding = PaddingValues(0.dp),
                verticalArrangement = Arrangement.Top,
            ) {
                MonAITransactionRow(
                    "Makan siang",
                    "Food · GoPay · 12:40",
                    "−Rp 35.000",
                    MoneyDirection.Expense,
                    MonAIIcons.Restaurant,
                    Color(0xFFF97316),
                )
                MonAITransactionRow(
                    "Belanja bulanan",
                    "Shopping · BCA · Yesterday",
                    "−Rp 187.500",
                    MoneyDirection.Expense,
                    MonAIIcons.ShoppingBag,
                    Color(0xFFEC4899),
                    hasReceipt = true,
                )
                MonAITransactionRow(
                    "Gaji",
                    "Salary · BCA · 1 Oct",
                    "+Rp 8.500.000",
                    MoneyDirection.Income,
                    MonAIIcons.Payments,
                    Color(0xFF14B8A6),
                )
                MonAITransactionRow(
                    "Top up GoPay",
                    "Transfer · BCA → GoPay",
                    "Rp 500.000",
                    MoneyDirection.Transfer,
                    MonAIIcons.SwapHoriz,
                    MonAITheme.colors.primary,
                    showDivider = false,
                )
            }
            MonAISettingsGroup(
                "Money",
                footer = "Only people with provider permissions see this section.",
            ) {
                MonAISettingsRow(
                    "Monthly budget",
                    MonAIIcons.Savings,
                    onClick = {},
                    value = "Rp 3 jt",
                )
                MonAISettingsRow(
                    "Delete account",
                    MonAIIcons.PersonRemove,
                    onClick = {},
                    destructive = true,
                    showChevron = false,
                    showDivider = false,
                )
            }
            MonAIRadioOption(
                title = "BCA Tabungan",
                subtitle = "Rp 8.250.000",
                tag = "DEFAULT",
                selected = true,
                onClick = {},
                leading = {
                    MonAIMonogram(
                        "BCA",
                        containerColor = MonAITheme.colors.primary,
                        contentColor = Color.White,
                    )
                },
            )
            MonAIRadioOption(
                title = "GoPay",
                subtitle = "Rp 1.185.000",
                selected = false,
                onClick = {},
            )
        }
    }
}
