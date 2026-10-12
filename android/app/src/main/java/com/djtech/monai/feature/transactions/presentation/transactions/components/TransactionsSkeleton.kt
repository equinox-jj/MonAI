package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.theme.MonAITheme

private class SkeletonRow(val title: Float, val meta: Float, val amount: Int)

private val GROUPS = listOf(
    140 to listOf(SkeletonRow(0.55f, 0.4f, 72), SkeletonRow(0.4f, 0.45f, 64), SkeletonRow(0.62f, 0.35f, 80)),
    160 to listOf(SkeletonRow(0.48f, 0.42f, 70), SkeletonRow(0.58f, 0.38f, 60)),
)

/** Day headers and rows that shimmer while the month's first page loads. */
@Composable
internal fun TransactionsSkeleton(modifier: Modifier = Modifier) {
    val description = stringResource(R.string.transactions_loading)
    Column(modifier.semantics(mergeDescendants = true) { contentDescription = description }) {
        GROUPS.forEach { (headerWidth, rows) ->
            Row(
                Modifier
                    .fillMaxWidth()
                    .padding(horizontal = MonAITheme.spacing.x4)
                    .padding(top = MonAITheme.spacing.x3, bottom = MonAITheme.spacing.x2),
                horizontalArrangement = Arrangement.SpaceBetween,
            ) {
                MonAISkeleton(14.dp, width = headerWidth.dp)
                MonAISkeleton(14.dp, width = 64.dp)
            }
            Column(Modifier.background(MonAITheme.colors.surface)) {
                MonAIDivider()
                rows.forEach { row ->
                    Row(
                        Modifier
                            .fillMaxWidth()
                            .padding(MonAITheme.spacing.x4),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
                    ) {
                        MonAISkeleton(40.dp, width = 40.dp, shape = CircleShape)
                        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(6.dp)) {
                            MonAISkeleton(14.dp, Modifier.fillMaxWidth(row.title))
                            MonAISkeleton(10.dp, Modifier.fillMaxWidth(row.meta))
                        }
                        MonAISkeleton(14.dp, width = row.amount.dp)
                    }
                    MonAIDivider()
                }
            }
        }
    }
}
