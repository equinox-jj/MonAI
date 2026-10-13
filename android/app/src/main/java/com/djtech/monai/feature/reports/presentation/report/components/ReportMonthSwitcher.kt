package com.djtech.monai.feature.reports.presentation.report.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.monthYearName
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import java.time.YearMonth

/** `‹ October 2026 ›` in a pill; next is disabled on the current month. */
@Composable
internal fun ReportMonthSwitcher(
    month: YearMonth,
    canGoNext: Boolean,
    onPrevious: () -> Unit,
    onNext: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Row(
        modifier
            .fillMaxWidth()
            .background(colors.surface, CircleShape)
            .border(MonAITheme.sizes.border, colors.border, CircleShape)
            .padding(MonAITheme.spacing.x0_5),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        MonAIIconButton(
            MonAIIcons.ChevronLeft,
            stringResource(R.string.report_previous_month, month.minusMonths(1).monthYearName()),
            onPrevious,
            tint = colors.textSecondary,
        )
        Text(
            month.monthYearName(),
            Modifier
                .weight(1f)
                .semantics { liveRegion = LiveRegionMode.Polite },
            style = MonAITheme.typography.titleMedium,
            color = colors.textPrimary,
            textAlign = TextAlign.Center,
        )
        MonAIIconButton(
            MonAIIcons.ChevronRight,
            stringResource(R.string.report_next_month, month.plusMonths(1).monthYearName()),
            onNext,
            tint = colors.textSecondary,
            enabled = canGoNext,
        )
    }
}
