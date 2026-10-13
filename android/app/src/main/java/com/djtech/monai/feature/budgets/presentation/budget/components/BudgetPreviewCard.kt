package com.djtech.monai.feature.budgets.presentation.budget.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIProgressBar
import com.djtech.monai.core.designsystem.component.color
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.feature.budgets.domain.model.BudgetPreview
import kotlin.math.absoluteValue

/** The typed limit against this month's spending: amount spent, percent, bar and what's left. */
@Composable
internal fun BudgetPreviewCard(preview: BudgetPreview, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.lg)
    val statusColor = preview.status.color()
    Column(
        modifier
            .fillMaxWidth()
            .background(colors.background, shape)
            .border(MonAITheme.sizes.border, colors.border, shape)
            .padding(MonAITheme.spacing.cardPadding)
            .semantics { liveRegion = LiveRegionMode.Polite },
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Text(
            stringResource(R.string.budget_preview_title),
            style = MonAITheme.typography.labelMedium,
            color = colors.textSecondary,
        )
        Row(verticalAlignment = Alignment.Bottom) {
            Text(
                stringResource(R.string.budget_preview_spent, formatRupiah(preview.spent)),
                Modifier.weight(1f),
                style = MonAITheme.typography.titleMedium.tabular(),
                color = colors.textPrimary,
            )
            Text(
                stringResource(R.string.percent_value, preview.percent),
                style = MonAITheme.extendedTypography.amountMedium,
                color = statusColor,
            )
        }
        MonAIProgressBar(preview.percent / 100f, color = statusColor, trackColor = colors.border)
        StatusLine(preview)
    }
}

@Composable
private fun StatusLine(preview: BudgetPreview) {
    val colors = MonAITheme.colors
    val (icon, color) = when (preview.status) {
        BudgetStatus.OK -> MonAIIcons.CheckCircle to colors.textSecondary
        BudgetStatus.WARNING -> MonAIIcons.Warning to colors.warning
        BudgetStatus.EXCEEDED -> MonAIIcons.Error to colors.error
    }
    val text = if (preview.remaining < 0) {
        stringResource(R.string.budget_preview_over, formatRupiah(preview.remaining.absoluteValue))
    } else {
        stringResource(R.string.budget_left, formatRupiah(preview.remaining))
    }
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        Icon(
            icon,
            null,
            Modifier.size(MonAITheme.sizes.iconSm),
            tint = color,
        )
        Text(
            text,
            style = MonAITheme.extendedTypography.bodyCompact.copy(fontWeight = FontWeight.SemiBold).tabular(),
            color = color,
        )
    }
}
