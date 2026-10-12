package com.djtech.monai.feature.transactions.presentation.transactiondetail.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.presentation.common.dateText
import com.djtech.monai.feature.transactions.presentation.common.label
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import java.time.LocalDate

/** The transaction's fields as label/value rows. Empty merchant and note rows are left out. */
@Composable
internal fun TransactionDetailFields(
    transaction: Transaction,
    lookups: TransactionLookups,
    today: LocalDate,
    modifier: Modifier = Modifier,
) {
    val unknown = stringResource(R.string.transaction_unknown)
    val fields = buildList {
        if (transaction.type == TransactionType.TRANSFER) {
            val from = lookups.wallet(transaction.walletId)?.name ?: unknown
            val to = lookups.wallet(transaction.toWalletId)?.name ?: unknown
            add(stringResource(R.string.transaction_detail_from) to from)
            add(stringResource(R.string.transaction_detail_to) to to)
        } else {
            val category = lookups.category(transaction.categoryId)?.name ?: unknown
            val wallet = lookups.wallet(transaction.walletId)?.name ?: unknown
            add(stringResource(R.string.transaction_detail_category) to category)
            add(stringResource(R.string.transaction_detail_wallet) to wallet)
        }
        add(stringResource(R.string.transaction_detail_date) to dateText(transaction.date, today))
        transaction.merchant?.takeIf(String::isNotBlank)?.let {
            add(stringResource(R.string.transaction_detail_merchant) to it)
        }
        transaction.note?.takeIf(String::isNotBlank)?.let {
            add(stringResource(R.string.transaction_detail_note) to it)
        }
    }
    MonAICard(
        modifier.fillMaxWidth(),
        contentPadding = PaddingValues(horizontal = MonAITheme.spacing.x4, vertical = MonAITheme.spacing.x1),
        verticalArrangement = Arrangement.Top,
    ) {
        fields.forEach { (label, value) ->
            FieldRow(label) {
                Text(
                    value,
                    style = MonAITheme.typography.labelLarge,
                    color = MonAITheme.colors.textPrimary,
                    textAlign = TextAlign.End,
                )
            }
            MonAIDivider()
        }
        FieldRow(stringResource(R.string.transaction_detail_added_by)) {
            val isAi = transaction.source != TransactionSource.MANUAL
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
            ) {
                val color = if (isAi) MonAITheme.colors.accent else MonAITheme.colors.textPrimary
                if (isAi) {
                    Icon(
                        MonAIIcons.AutoAwesome,
                        null,
                        Modifier.size(MonAITheme.sizes.iconSm),
                        tint = color,
                    )
                }
                Text(transaction.source.label(), style = MonAITheme.typography.labelLarge, color = color)
            }
        }
    }
}

@Composable
private fun FieldRow(label: String, value: @Composable () -> Unit) {
    Row(
        Modifier
            .fillMaxWidth()
            .semantics(mergeDescendants = true) {}
            .padding(vertical = MonAITheme.spacing.x3),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4),
    ) {
        Text(
            label,
            Modifier.weight(1f),
            style = MonAITheme.typography.bodyMedium,
            color = MonAITheme.colors.textTertiary,
        )
        value()
    }
}
