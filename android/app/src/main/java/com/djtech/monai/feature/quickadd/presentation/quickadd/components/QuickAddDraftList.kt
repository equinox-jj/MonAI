package com.djtech.monai.feature.quickadd.presentation.quickadd.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.moneyColor
import com.djtech.monai.core.designsystem.component.moneySign
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.quickadd.presentation.common.dayText
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddDraftRow
import java.time.LocalDate

/** "Draft ready" / "2 drafts ready", one card per draft, and a warning when an amount is missing. */
@Composable
internal fun QuickAddDraftList(
    drafts: List<QuickAddDraftRow>,
    amountMissing: Boolean,
    today: LocalDate,
    modifier: Modifier = Modifier,
) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        Text(
            pluralStringResource(R.plurals.quick_add_drafts_ready, drafts.size, drafts.size),
            style = MonAITheme.typography.titleSmall,
            color = MonAITheme.colors.textPrimary,
        )
        drafts.forEach { DraftCard(it, today) }
        if (amountMissing) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
            ) {
                Icon(
                    MonAIIcons.Warning,
                    null,
                    Modifier.size(MonAITheme.sizes.iconSm),
                    tint = MonAITheme.colors.warning,
                )
                Text(
                    stringResource(R.string.quick_add_amount_missing),
                    style = MonAITheme.typography.bodySmall,
                    color = MonAITheme.colors.onWarningContainer,
                )
            }
        }
    }
}

@Composable
private fun DraftCard(row: QuickAddDraftRow, today: LocalDate) {
    val colors = MonAITheme.colors
    val isTransfer = row.type == TransactionType.TRANSFER
    val wallet = when {
        isTransfer -> listOfNotNull(row.walletName, row.toWalletName).joinToString(" → ")
        row.walletIsDefault && row.walletName != null ->
            stringResource(R.string.quick_add_default_wallet, row.walletName)
        else -> row.walletName
    }
    val meta = listOfNotNull(
        if (isTransfer) stringResource(R.string.transaction_type_transfer) else row.categoryName,
        wallet,
        dayText(row.date, today),
    ).joinToString(" · ")
    MonAICard(
        contentPadding = PaddingValues(horizontal = MonAITheme.spacing.x3_5, vertical = MonAITheme.spacing.x3),
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            MonAICategoryIcon(
                if (isTransfer) MonAIIcons.SwapHoriz else categoryIcon(row.categoryIcon),
                if (isTransfer) colors.primary else CategoryColors.parse(row.categoryColor),
            )
            Column(Modifier.weight(1f)) {
                Text(
                    row.title ?: row.categoryName.orEmpty(),
                    style = MonAITheme.typography.titleSmall,
                    color = colors.textPrimary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                // Two lines, so the date still shows after a long wallet name.
                Text(
                    meta,
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis,
                )
            }
            DraftAmount(row.type, row.amount)
        }
    }
}

@Composable
private fun DraftAmount(type: TransactionType, amount: Long?) {
    val colors = MonAITheme.colors
    val style = MonAITheme.typography.titleSmall.tabular()
    if (amount == null) {
        Text(
            stringResource(R.string.quick_add_no_amount),
            Modifier
                .background(colors.warningContainer, RoundedCornerShape(MonAITheme.radius.sm))
                .padding(horizontal = MonAITheme.spacing.x1_5, vertical = MonAITheme.spacing.x1),
            style = style,
            color = colors.onWarningContainer,
        )
        return
    }
    Text(formatRupiahSigned(amount, type.moneySign()), style = style, color = type.moneyColor())
}
