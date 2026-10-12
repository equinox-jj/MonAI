package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.selection.toggleable
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.Immutable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/**
 * 32dp filter chip with 8dp corners (Transactions filters). Selected chips get a check;
 * [hasDropdown] adds a chevron for chips that open a picker.
 */
@Composable
fun MonAIFilterChip(
    label: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    hasDropdown: Boolean = false,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val shape = RoundedCornerShape(MonAITheme.radius.sm)
    Row(
        modifier = modifier
            .height(sizes.filterChip)
            .clip(shape)
            .background(if (selected) colors.primaryContainer else colors.surface)
            .border(
                sizes.border,
                if (selected) colors.primaryContainerBorder else colors.borderStrong,
                shape
            )
            .toggleable(value = selected, role = Role.Checkbox, onValueChange = { onClick() })
            .padding(horizontal = MonAITheme.spacing.x2_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        val content = if (selected) colors.onPrimaryContainer else colors.iconStrong
        if (selected) Icon(
            MonAIIcons.Check,
            null,
            Modifier.size(sizes.iconSm),
            tint = content,
        )
        Text(label, style = MonAITheme.typography.labelMedium, color = content)
        if (hasDropdown) Icon(
            MonAIIcons.ExpandMore,
            null,
            Modifier.size(sizes.iconSm),
            tint = content,
        )
    }
}

/** 40dp pill with a category icon, for picking a category on the add/edit form. */
@Composable
fun MonAICategoryChip(
    label: String,
    icon: ImageVector,
    color: Color,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    Row(
        modifier = modifier
            .height(sizes.choiceChip)
            .clip(CircleShape)
            .background(if (selected) colors.primaryContainer else colors.surface)
            .border(
                width = if (selected) sizes.borderFocused else sizes.border,
                color = when {
                    selected -> colors.focus
                    colors.isDark -> colors.borderStrong
                    else -> colors.border
                },
                shape = CircleShape,
            )
            .selectable(selected = selected, role = Role.RadioButton, onClick = onClick)
            .padding(start = MonAITheme.spacing.x1, end = MonAITheme.spacing.x3),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        MonAICategoryIcon(
            icon,
            color,
            size = sizes.avatarSmall,
            iconSize = sizes.iconMd,
        )
        Text(
            label,
            style = MonAITheme.extendedTypography.bodyCompact.copy(
                fontWeight = MonAITheme.typography.labelMedium.fontWeight,
            ),
            color = colors.textPrimary,
        )
    }
}

/** One option of a [MonAISegmentedControl], with optional per-option selected colors. */
@Immutable
data class MonAISegment(
    val label: String,
    val selectedContainer: Color = Color.Unspecified,
    val selectedContent: Color = Color.Unspecified,
)

/** Pill segmented control (Expense / Income / Transfer). */
@Composable
fun MonAISegmentedControl(
    segments: List<MonAISegment>,
    selectedIndex: Int,
    onSelect: (Int) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    Row(
        modifier = modifier
            .fillMaxWidth()
            .height(MonAITheme.sizes.segmentedControl)
            .clip(CircleShape)
            .background(colors.surfaceSunken)
            .padding(spacing.x1)
            .selectableGroup(),
        horizontalArrangement = Arrangement.spacedBy(spacing.x1),
    ) {
        segments.forEachIndexed { index, segment ->
            val selected = index == selectedIndex
            val container = when {
                !selected -> Color.Transparent
                segment.selectedContainer != Color.Unspecified -> segment.selectedContainer
                else -> colors.surface
            }
            val content = when {
                !selected -> colors.textTertiary
                segment.selectedContent != Color.Unspecified -> segment.selectedContent
                else -> colors.textPrimary
            }
            Box(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxHeight()
                    .then(
                        if (selected && !colors.isDark) Modifier.shadow(
                            1.dp,
                            CircleShape
                        ) else Modifier
                    )
                    .clip(CircleShape)
                    .background(container)
                    .selectable(
                        selected = selected,
                        role = Role.Tab,
                        onClick = { onSelect(index) }),
                contentAlignment = Alignment.Center,
            ) {
                Text(segment.label, style = MonAITheme.typography.labelLarge, color = content)
            }
        }
    }
}

/** The design's transaction-type segments, colored by direction. */
@Composable
fun transactionTypeSegments(expense: String, income: String, transfer: String): List<MonAISegment> {
    val colors = MonAITheme.colors
    return listOf(
        MonAISegment(expense, colors.expenseContainer, colors.expense),
        MonAISegment(income, colors.incomeContainer, colors.income),
        MonAISegment(transfer),
    )
}

@PreviewLightDark
@Composable
private fun SelectionPreview() {
    MonAITheme {
        Column(
            Modifier
                .background(MonAITheme.colors.surface)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            MonAISegmentedControl(
                transactionTypeSegments("Expense", "Income", "Transfer"),
                selectedIndex = 0,
                onSelect = {},
            )
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                MonAIFilterChip("All types", selected = true, onClick = {})
                MonAIFilterChip(
                    "Wallet",
                    selected = false,
                    onClick = {},
                    hasDropdown = true,
                )
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                MonAICategoryChip(
                    "Food",
                    MonAIIcons.Restaurant,
                    Color(0xFFF97316),
                    selected = true,
                    onClick = {},
                )
                MonAICategoryChip(
                    "Transport",
                    MonAIIcons.DirectionsCar,
                    Color(0xFF0EA5E9),
                    selected = false,
                    onClick = {},
                )
            }
        }
    }
}
