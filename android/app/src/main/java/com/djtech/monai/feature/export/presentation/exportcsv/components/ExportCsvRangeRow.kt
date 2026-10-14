package com.djtech.monai.feature.export.presentation.exportcsv.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.monthYearName
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import java.time.YearMonth

/** "From" or "To" with a month stepper; moving back is always allowed, the other end follows. */
@Composable
internal fun ExportCsvRangeRow(
    label: String,
    month: YearMonth,
    canMoveForward: Boolean,
    enabled: Boolean,
    onMove: (months: Int) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Row(
        modifier
            .fillMaxWidth()
            .clip(CircleShape)
            .background(colors.surfaceSunken)
            .padding(
                start = MonAITheme.spacing.x4,
                end = 2.dp,
                top = 2.dp,
                bottom = 2.dp,
            ),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(
            label,
            Modifier.weight(1f),
            style = MonAITheme.typography.bodyMedium,
            color = colors.textSecondary,
        )
        MonAIIconButton(
            MonAIIcons.ChevronLeft,
            stringResource(R.string.export_previous_month),
            onClick = { onMove(-1) },
            enabled = enabled,
        )
        Text(
            month.monthYearName(),
            Modifier.weight(1.4f),
            style = MonAITheme.typography.titleSmall,
            color = colors.textPrimary,
            textAlign = TextAlign.Center,
            maxLines = 1,
        )
        MonAIIconButton(
            MonAIIcons.ChevronRight,
            stringResource(R.string.export_next_month),
            onClick = { onMove(1) },
            enabled = enabled && canMoveForward,
        )
    }
}
