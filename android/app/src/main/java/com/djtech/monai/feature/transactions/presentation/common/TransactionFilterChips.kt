package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIFilterChip
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheetKind
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups

/**
 * The scrolling filter chips. An unset filter opens its sheet; a set one shows its value and an
 * × that removes it. [leading] holds the screen's own chips, e.g. "All types" or the month.
 */
@Composable
internal fun TransactionFilterChips(
    filter: TransactionFilter,
    lookups: TransactionLookups,
    onIntent: (FilterIntent) -> Unit,
    modifier: Modifier = Modifier,
    contentPadding: PaddingValues = PaddingValues(),
    leading: @Composable RowScope.() -> Unit = {},
) {
    Row(
        modifier = modifier
            .horizontalScroll(rememberScrollState())
            .padding(contentPadding),
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        leading()
        FilterChip(
            kind = FilterSheetKind.WALLET,
            label = stringResource(R.string.transactions_filter_wallet),
            value = filter.walletId?.let { lookups.wallet(it)?.name ?: stringResource(R.string.transaction_unknown) },
            onIntent = onIntent,
        )
        FilterChip(
            kind = FilterSheetKind.CATEGORY,
            label = stringResource(R.string.transactions_filter_category),
            value = filter.categoryId?.let {
                lookups.category(it)?.name ?: stringResource(R.string.transaction_unknown)
            },
            onIntent = onIntent,
        )
        FilterChip(
            kind = FilterSheetKind.TYPE,
            label = stringResource(R.string.transactions_filter_type),
            value = filter.type?.label(),
            onIntent = onIntent,
        )
    }
}

@Composable
private fun FilterChip(
    kind: FilterSheetKind,
    label: String,
    value: String?,
    onIntent: (FilterIntent) -> Unit,
) {
    if (value == null) {
        MonAIFilterChip(
            label,
            selected = false,
            onClick = { onIntent(FilterIntent.Open(kind)) },
            hasDropdown = true,
        )
    } else {
        ActiveFilterChip(
            value,
            onClick = { onIntent(FilterIntent.Open(kind)) },
            onRemove = { onIntent(FilterIntent.Remove(kind)) },
            removeDescription = stringResource(R.string.transactions_filter_clear, label),
        )
    }
}

/** A set filter: its value opens the sheet again, the × removes it. */
@Composable
internal fun ActiveFilterChip(
    value: String,
    onClick: () -> Unit,
    onRemove: () -> Unit,
    removeDescription: String,
    leadingIcon: ImageVector? = null,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.sm)
    Row(
        modifier = Modifier
            .height(MonAITheme.sizes.filterChip)
            .clip(shape)
            .background(colors.primaryContainer)
            .border(MonAITheme.sizes.border, colors.primaryContainerBorder, shape)
            .clickable(role = Role.Button, onClick = onClick)
            .padding(start = MonAITheme.spacing.x2_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        if (leadingIcon != null) {
            Icon(
                leadingIcon,
                null,
                Modifier.size(MonAITheme.sizes.iconSm),
                tint = colors.onPrimaryContainer,
            )
        }
        Text(value, style = MonAITheme.typography.labelMedium, color = colors.onPrimaryContainer, maxLines = 1)
        Icon(
            MonAIIcons.Close,
            removeDescription,
            Modifier
                .clip(RoundedCornerShape(MonAITheme.radius.xs))
                .clickable(role = Role.Button, onClick = onRemove)
                .padding(horizontal = MonAITheme.spacing.x1_5, vertical = 8.dp)
                .size(MonAITheme.sizes.iconSm),
            tint = colors.onPrimaryContainer,
        )
    }
}

/** A plain chip with a leading icon, e.g. the search screen's month. */
@Composable
internal fun IconFilterChip(
    label: String,
    icon: ImageVector,
    onClick: () -> Unit,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.sm)
    Row(
        modifier = Modifier
            .height(MonAITheme.sizes.filterChip)
            .clip(shape)
            .background(colors.surface)
            .border(MonAITheme.sizes.border, colors.borderStrong, shape)
            .clickable(role = Role.Button, onClick = onClick)
            .padding(horizontal = MonAITheme.spacing.x2_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        Icon(
            icon,
            null,
            Modifier.size(MonAITheme.sizes.iconSm),
            tint = colors.iconStrong,
        )
        Text(label, style = MonAITheme.typography.labelMedium, color = colors.iconStrong, maxLines = 1)
    }
}
