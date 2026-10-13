package com.djtech.monai.feature.receipt.presentation.receiptreview.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** The photo's thumbnail and what to do: check the AI's fields, or fill them when it failed. */
@Composable
internal fun ReceiptReviewBanner(
    photoUri: String,
    aiFailed: Boolean,
    showThumbnail: Boolean,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val (container, content) = if (aiFailed) {
        colors.warningContainer to colors.onWarningContainer
    } else {
        colors.primaryContainer to colors.onPrimaryContainer
    }
    Row(
        modifier
            .fillMaxWidth()
            .background(container, RoundedCornerShape(MonAITheme.radius.md))
            .padding(horizontal = MonAITheme.spacing.x3, vertical = MonAITheme.spacing.x2_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        if (showThumbnail) {
            AsyncImage(
                photoUri,
                stringResource(R.string.receipt_review_photo),
                Modifier
                    .size(width = 44.dp, height = 56.dp)
                    .clip(RoundedCornerShape(MonAITheme.radius.sm))
                    .border(MonAITheme.sizes.border, colors.borderStrong, RoundedCornerShape(MonAITheme.radius.sm)),
                contentScale = ContentScale.Crop,
            )
        }
        Text(
            stringResource(if (aiFailed) R.string.receipt_review_failed else R.string.receipt_review_filled),
            Modifier.weight(1f),
            style = MonAITheme.typography.bodySmall,
            color = content,
        )
    }
}
