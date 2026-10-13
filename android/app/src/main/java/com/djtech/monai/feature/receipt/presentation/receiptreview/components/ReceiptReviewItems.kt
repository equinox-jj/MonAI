package com.djtech.monai.feature.receipt.presentation.receiptreview.components

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.ReceiptItem

/** "4 items found", open by default, with each line and the receipt's total. */
@Composable
internal fun ReceiptReviewItems(items: List<ReceiptItem>, total: Long?, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    // Purely visual and per-screen, so it lives in the UI.
    var expanded by rememberSaveable { mutableStateOf(true) }
    Column(
        modifier
            .fillMaxWidth()
            .clip(shape)
            .border(MonAITheme.sizes.border, colors.border, shape),
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .clickable(role = Role.Button) { expanded = !expanded }
                .padding(horizontal = MonAITheme.spacing.x3_5, vertical = MonAITheme.spacing.x3),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(
                pluralStringResource(R.plurals.receipt_review_items, items.size, items.size),
                Modifier.weight(1f),
                style = MonAITheme.typography.labelLarge,
                color = colors.textPrimary,
            )
            Icon(
                MonAIIcons.ExpandMore,
                null,
                Modifier.rotate(if (expanded) 180f else 0f),
                tint = colors.textTertiary,
            )
        }
        AnimatedVisibility(expanded) {
            Column(
                Modifier.padding(
                    start = MonAITheme.spacing.x3_5,
                    end = MonAITheme.spacing.x3_5,
                    bottom = MonAITheme.spacing.x3,
                ),
                verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
            ) {
                items.forEach { item ->
                    Line(item.name, item.amount?.let(::formatRupiah).orEmpty(), strong = false)
                }
                if (total != null) {
                    MonAIDivider()
                    Line(stringResource(R.string.receipt_review_total), formatRupiah(total), strong = true)
                }
            }
        }
    }
}

@Composable
private fun Line(label: String, amount: String, strong: Boolean) {
    val colors = MonAITheme.colors
    val style = if (strong) MonAITheme.typography.labelLarge else MonAITheme.typography.bodySmall
    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        val color = if (strong) colors.textPrimary else colors.textSecondary
        Text(label, Modifier.weight(1f), style = style, color = color)
        Text(amount, style = style.tabular(), color = color)
    }
}
