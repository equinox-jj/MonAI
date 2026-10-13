package com.djtech.monai.feature.reports.presentation.report.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Stands in for the totals and breakdown while a month with nothing cached loads. */
@Composable
internal fun ReportSkeleton(modifier: Modifier = Modifier) {
    val spacing = MonAITheme.spacing
    val card = RoundedCornerShape(MonAITheme.radius.lg)
    Column(
        modifier.clearAndSetSemantics {},
        verticalArrangement = Arrangement.spacedBy(spacing.x4),
    ) {
        Row(horizontalArrangement = Arrangement.spacedBy(spacing.x2)) {
            MonAISkeleton(76.dp, Modifier.weight(1f), shape = card)
            MonAISkeleton(76.dp, Modifier.weight(1f), shape = card)
        }
        MonAISkeleton(72.dp, shape = card)
        MonAICard(verticalArrangement = Arrangement.spacedBy(spacing.x4)) {
            MonAISkeleton(20.dp, width = 180.dp)
            MonAISkeleton(
                200.dp,
                Modifier
                    .align(Alignment.CenterHorizontally)
                    .size(200.dp),
                shape = CircleShape,
            )
            repeat(3) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(spacing.x3),
                ) {
                    MonAISkeleton(36.dp, width = 36.dp, shape = CircleShape)
                    Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(spacing.x1_5)) {
                        MonAISkeleton(14.dp)
                        MonAISkeleton(12.dp, width = 120.dp)
                    }
                }
            }
        }
    }
}
