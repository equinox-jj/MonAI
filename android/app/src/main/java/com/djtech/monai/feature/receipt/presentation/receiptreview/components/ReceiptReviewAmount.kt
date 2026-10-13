package com.djtech.monai.feature.receipt.presentation.receiptreview.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatThousands
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.HighlightIcon
import com.djtech.monai.core.designsystem.component.moneyColor
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.TransactionType

/** The total in a large tappable field, marked like the other drafted fields. */
@Composable
internal fun ReceiptReviewAmount(
    type: TransactionType,
    amount: Long?,
    highlight: FieldHighlight,
    error: String?,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    val sizes = MonAITheme.sizes
    val (container, border, width) = when {
        error != null -> Triple(colors.surfaceSunken, colors.error, sizes.borderFocused)
        highlight == FieldHighlight.Low -> Triple(colors.warningContainer, colors.warning, sizes.borderFocused)
        highlight == FieldHighlight.Ai -> Triple(colors.primaryContainer, colors.primaryContainerBorder, sizes.border)
        else -> Triple(colors.surfaceSunken, colors.border, sizes.border)
    }
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.fieldLabelGap)) {
        Text(
            stringResource(R.string.ai_amount_title),
            style = MonAITheme.typography.labelMedium,
            color = colors.textSecondary,
        )
        Row(
            Modifier
                .fillMaxWidth()
                .height(64.dp)
                .clip(shape)
                .background(container)
                .border(width, border, shape)
                .clickable(role = Role.Button, onClick = onClick)
                .padding(horizontal = MonAITheme.spacing.x3_5),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            Text("Rp", style = MonAITheme.typography.titleMedium, color = colors.textTertiary)
            Text(
                amount?.let(::formatThousands) ?: "—",
                Modifier.weight(1f),
                style = MonAITheme.typography.headlineMedium.copy(fontWeight = FontWeight.Bold).tabular(),
                color = if (amount == null) colors.textDisabled else type.moneyColor(),
            )
            if (error == null) HighlightIcon(highlight)
        }
        if (error != null) Text(error, style = MonAITheme.typography.bodySmall, color = colors.errorText)
    }
}
