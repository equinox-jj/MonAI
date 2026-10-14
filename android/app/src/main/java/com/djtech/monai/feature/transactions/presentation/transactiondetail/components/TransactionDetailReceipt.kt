package com.djtech.monai.feature.transactions.presentation.transactiondetail.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
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
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import kotlin.math.roundToInt

/**
 * The receipt card: the attached photo's thumbnail with View and Replace, or an Add button when
 * there is none. [upload] (0..1) shows a new photo's progress and holds the buttons meanwhile.
 */
@Composable
internal fun TransactionDetailReceipt(
    receiptUrl: String?,
    upload: Float?,
    onView: () -> Unit,
    onAdd: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val thumbShape = RoundedCornerShape(MonAITheme.radius.sm)
    val thumbnail = Modifier
        .size(width = 64.dp, height = 84.dp)
        .clip(thumbShape)
        .background(colors.surfaceSunken)
        .border(MonAITheme.sizes.border, colors.border, thumbShape)
    MonAICard(
        modifier.fillMaxWidth(),
        contentPadding = PaddingValues(MonAITheme.spacing.x3),
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            if (receiptUrl != null) {
                AsyncImage(
                    model = receiptUrl,
                    contentDescription = null,
                    modifier = thumbnail,
                    contentScale = ContentScale.Crop,
                )
            } else {
                Box(thumbnail, contentAlignment = Alignment.Center) {
                    Icon(MonAIIcons.AddPhotoAlternate, null, tint = colors.textTertiary)
                }
            }
            Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1)) {
                Text(
                    stringResource(
                        if (receiptUrl != null) {
                            R.string.transaction_detail_receipt
                        } else {
                            R.string.transaction_detail_receipt_add
                        },
                    ),
                    style = MonAITheme.typography.labelLarge,
                    color = colors.textPrimary,
                )
                Text(
                    when {
                        upload != null -> stringResource(
                            R.string.transaction_detail_receipt_uploading,
                            (upload * 100).roundToInt(),
                        )

                        receiptUrl != null -> stringResource(R.string.transaction_detail_receipt_meta)
                        else -> stringResource(R.string.transaction_detail_receipt_add_meta)
                    },
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                )
                if (upload != null) LinearProgressIndicator(progress = { upload }, Modifier.fillMaxWidth())
            }
            Column(verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5)) {
                if (receiptUrl != null) {
                    MonAIButton(
                        stringResource(R.string.transaction_detail_receipt_view),
                        onView,
                        variant = MonAIButtonVariant.Outlined,
                        size = MonAIButtonSize.Small,
                    )
                }
                MonAIButton(
                    stringResource(
                        if (receiptUrl != null) {
                            R.string.transaction_detail_receipt_replace
                        } else {
                            R.string.transaction_detail_receipt_add_action
                        },
                    ),
                    onAdd,
                    variant = if (receiptUrl != null) MonAIButtonVariant.Text else MonAIButtonVariant.Tonal,
                    size = MonAIButtonSize.Small,
                    enabled = upload == null,
                    loading = upload != null && receiptUrl == null,
                )
            }
        }
    }
}
