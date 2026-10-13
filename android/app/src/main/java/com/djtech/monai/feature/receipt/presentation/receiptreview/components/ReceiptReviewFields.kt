package com.djtech.monai.feature.receipt.presentation.receiptreview.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.HighlightIcon
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIFieldTile
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.component.MonAITileIcon
import com.djtech.monai.core.designsystem.component.currentLocale
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.receipt.presentation.receiptreview.ReceiptReviewIntent
import com.djtech.monai.feature.receipt.presentation.receiptreview.ReceiptReviewState
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import java.time.format.DateTimeFormatter

/** Merchant, category and wallet side by side, and the date, each marked as drafted or not. */
@Composable
internal fun ReceiptReviewFields(
    state: ReceiptReviewState,
    onIntent: (ReceiptReviewIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val choose = stringResource(R.string.transaction_form_choose)
    val check = stringResource(R.string.ai_hint_check)
    val errors = state.errors.mapValues { it.value.asString() }
    fun highlight(field: TransactionField) = state.highlights[field] ?: FieldHighlight.None
    val dateText = state.date.format(DateTimeFormatter.ofPattern("EEE, d MMM yyyy", currentLocale()))
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
        MonAITextField(
            value = state.merchant,
            onValueChange = { onIntent(ReceiptReviewIntent.MerchantChanged(it)) },
            label = stringResource(R.string.receipt_review_merchant),
            trailing = if (state.merchantFromAi) {
                { HighlightIcon(FieldHighlight.Ai) }
            } else {
                null
            },
        )
        Row(horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
            MonAIFieldTile(
                label = stringResource(R.string.transaction_form_category),
                value = state.category?.name ?: choose,
                onClick = { onIntent(ReceiptReviewIntent.OpenCategory) },
                modifier = Modifier.weight(1f),
                leading = {
                    MonAICategoryIcon(
                        categoryIcon(state.category?.icon),
                        CategoryColors.parse(state.category?.color),
                        size = MonAITheme.sizes.avatarSmall,
                        iconSize = MonAITheme.sizes.iconMd,
                    )
                },
                error = errors[TransactionField.CATEGORY],
                highlight = highlight(TransactionField.CATEGORY),
                hint = check,
            )
            MonAIFieldTile(
                label = stringResource(R.string.transaction_form_wallet),
                value = state.walletName ?: choose,
                onClick = { onIntent(ReceiptReviewIntent.OpenWallet) },
                modifier = Modifier.weight(1f),
                leading = { MonAITileIcon(MonAIIcons.AccountBalance) },
                showChevron = true,
                error = errors[TransactionField.WALLET],
                highlight = highlight(TransactionField.WALLET),
                hint = check,
            )
        }
        MonAIFieldTile(
            label = stringResource(R.string.transaction_form_date),
            value = dateText,
            onClick = { onIntent(ReceiptReviewIntent.OpenDate) },
            leading = { MonAITileIcon(MonAIIcons.CalendarToday) },
            error = errors[TransactionField.DATE],
            highlight = highlight(TransactionField.DATE),
            hint = check,
        )
    }
}
