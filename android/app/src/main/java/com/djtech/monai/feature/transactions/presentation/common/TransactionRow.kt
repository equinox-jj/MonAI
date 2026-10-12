package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAmountText
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.component.arrowIcon
import com.djtech.monai.core.designsystem.component.color
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.presentation.common.mapper.highlighted
import com.djtech.monai.feature.transactions.presentation.common.mapper.matchesSearch
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import java.time.ZoneId

/**
 * A transaction in the list, search results and the tablet list pane. With [highlight], the words
 * of a search are marked in the title and meta, and a merchant match shows as "at <merchant>".
 */
@Composable
internal fun TransactionRow(
    transaction: Transaction,
    lookups: TransactionLookups,
    rowWhen: RowWhen,
    zone: ZoneId,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    highlight: String? = null,
    selected: Boolean = false,
    showDivider: Boolean = true,
) {
    val colors = MonAITheme.colors
    val direction = transaction.type.direction()
    val (icon, iconColor) = transaction.iconAndColor(lookups)
    val title = transaction.title(lookups)
    val meta = transaction.metaText(lookups, rowWhen, zone)
    val merchant = transaction.merchant
    // A match only in the merchant would be invisible under a note title, so the merchant leads the meta.
    val metaWithMerchant = if (
        highlight != null && merchant != null && merchant != title && merchant.matchesSearch(highlight)
    ) {
        stringResource(R.string.transaction_search_merchant, merchant) + " · " + meta
    } else {
        meta
    }
    val markColor = colors.primaryContainer
    val titleText = remember(title, highlight, markColor) { title.highlighted(highlight, markColor) }
    val metaText = remember(metaWithMerchant, highlight, markColor) {
        metaWithMerchant.highlighted(highlight, markColor)
    }
    Column(modifier.background(if (selected) colors.primaryContainer else colors.surface)) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clickable(onClick = onClick)
                .padding(horizontal = MonAITheme.spacing.x4, vertical = MonAITheme.spacing.x3),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            MonAICategoryIcon(icon, iconColor)
            Column(Modifier.weight(1f)) {
                Text(
                    titleText,
                    style = MonAITheme.typography.titleMedium,
                    color = colors.textPrimary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                Text(
                    metaText,
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
            Column(horizontalAlignment = Alignment.End) {
                MonAIAmountText(transaction.amountText(), direction)
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
                ) {
                    if (transaction.receiptUrl != null) {
                        Icon(
                            MonAIIcons.AttachFile,
                            stringResource(R.string.transaction_has_receipt),
                            Modifier.size(MonAITheme.sizes.iconSm),
                            tint = colors.textTertiary,
                        )
                    }
                    Icon(
                        direction.arrowIcon(),
                        null,
                        Modifier.size(MonAITheme.sizes.iconSm),
                        tint = direction.color(),
                    )
                }
            }
        }
        if (showDivider) MonAIDivider()
    }
}
