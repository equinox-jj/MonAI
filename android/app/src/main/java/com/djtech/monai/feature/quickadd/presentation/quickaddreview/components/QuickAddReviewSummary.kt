package com.djtech.monai.feature.quickadd.presentation.quickaddreview.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.component.moneyColor
import com.djtech.monai.core.designsystem.component.moneySign
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.quickadd.presentation.common.dayText
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewOutcome
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSummaryRow
import java.time.LocalDate

/** After the last draft: how many were saved, and each draft's outcome (skipped ones faded). */
@Composable
internal fun QuickAddReviewSummary(
    rows: List<ReviewSummaryRow>,
    savedCount: Int,
    today: LocalDate,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Column(
        modifier
            .fillMaxWidth()
            .padding(top = MonAITheme.spacing.x4)
            .semantics { liveRegion = LiveRegionMode.Polite },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Icon(MonAIIcons.CheckCircle, null, Modifier.size(MonAITheme.sizes.stateIcon), tint = colors.success)
        Text(
            if (savedCount == 0) {
                stringResource(R.string.quick_add_review_nothing_saved)
            } else {
                pluralStringResource(R.plurals.quick_add_review_saved, savedCount, savedCount)
            },
            style = MonAITheme.typography.titleLarge,
            color = colors.textPrimary,
            textAlign = TextAlign.Center,
        )
        MonAICard(contentPadding = PaddingValues(), verticalArrangement = Arrangement.Top) {
            rows.forEachIndexed { index, row ->
                if (index > 0) MonAIDivider()
                SummaryRow(row, today)
            }
        }
    }
}

@Composable
private fun SummaryRow(row: ReviewSummaryRow, today: LocalDate) {
    val colors = MonAITheme.colors
    val status = when (row.outcome) {
        ReviewOutcome.SAVED -> stringResource(
            R.string.quick_add_review_status_saved,
            row.walletName.orEmpty(),
            dayText(row.date, today),
        )

        ReviewOutcome.SKIPPED -> stringResource(R.string.quick_add_review_status_skipped)
    }
    Row(
        Modifier
            .fillMaxWidth()
            .alpha(if (row.outcome == ReviewOutcome.SAVED) 1f else 0.5f)
            .padding(horizontal = MonAITheme.spacing.x4, vertical = MonAITheme.spacing.x3),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        MonAICategoryIcon(
            categoryIcon(row.category?.icon),
            CategoryColors.parse(row.category?.color),
            size = MonAITheme.sizes.avatarSmall + MonAITheme.spacing.x1,
            iconSize = MonAITheme.sizes.iconMd,
        )
        Column(Modifier.weight(1f)) {
            Text(row.title, style = MonAITheme.typography.titleSmall, color = colors.textPrimary)
            Text(status, style = MonAITheme.typography.bodySmall, color = colors.textTertiary)
        }
        row.amount?.let {
            Text(
                formatRupiahSigned(it, row.type.moneySign()),
                style = MonAITheme.typography.titleSmall.tabular(),
                color = row.type.moneyColor(),
            )
        }
    }
}
