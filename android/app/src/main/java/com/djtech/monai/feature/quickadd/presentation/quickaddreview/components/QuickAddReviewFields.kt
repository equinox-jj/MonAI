package com.djtech.monai.feature.quickadd.presentation.quickaddreview.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIFieldTile
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.component.MonAITileIcon
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.quickadd.presentation.common.dayText
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.QuickAddReviewIntent
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.QuickAddReviewState
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewDraft
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewWalletTarget
import com.djtech.monai.feature.transactions.domain.model.TransactionField

/** The draft's category (or a transfer's destination), wallet, date and note, each marked as drafted. */
@Composable
internal fun QuickAddReviewFields(
    state: QuickAddReviewState,
    draft: ReviewDraft,
    onIntent: (QuickAddReviewIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val choose = stringResource(R.string.transaction_form_choose)
    val check = stringResource(R.string.ai_hint_check)
    val errors = state.errors.mapValues { it.value.asString() }
    fun highlight(field: TransactionField) = draft.highlights[field] ?: FieldHighlight.None
    val isTransfer = draft.type == TransactionType.TRANSFER
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        if (isTransfer) {
            MonAIFieldTile(
                label = stringResource(R.string.transaction_form_from),
                value = state.walletName ?: choose,
                onClick = { onIntent(QuickAddReviewIntent.OpenWallet(ReviewWalletTarget.SOURCE)) },
                leading = { MonAITileIcon(MonAIIcons.AccountBalanceWallet) },
                error = errors[TransactionField.WALLET],
                highlight = highlight(TransactionField.WALLET),
                hint = check,
            )
            MonAIFieldTile(
                label = stringResource(R.string.transaction_form_to),
                value = state.toWalletName ?: choose,
                onClick = { onIntent(QuickAddReviewIntent.OpenWallet(ReviewWalletTarget.DESTINATION)) },
                leading = { MonAITileIcon(MonAIIcons.AccountBalanceWallet) },
                error = errors[TransactionField.TO_WALLET],
                highlight = highlight(TransactionField.TO_WALLET),
                hint = check,
            )
        } else {
            MonAIFieldTile(
                label = stringResource(R.string.transaction_form_category),
                value = state.category?.name ?: choose,
                onClick = { onIntent(QuickAddReviewIntent.OpenCategory) },
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
                onClick = { onIntent(QuickAddReviewIntent.OpenWallet(ReviewWalletTarget.SOURCE)) },
                leading = { MonAITileIcon(MonAIIcons.AccountBalanceWallet) },
                error = errors[TransactionField.WALLET],
                highlight = highlight(TransactionField.WALLET),
                hint = check,
            )
        }
        MonAIFieldTile(
            label = stringResource(R.string.transaction_form_date),
            value = dayText(draft.date, state.today),
            onClick = { onIntent(QuickAddReviewIntent.OpenDate) },
            leading = { MonAITileIcon(MonAIIcons.CalendarToday) },
            error = errors[TransactionField.DATE],
            highlight = highlight(TransactionField.DATE),
            hint = check,
        )
        MonAITextField(
            value = draft.note,
            onValueChange = { onIntent(QuickAddReviewIntent.NoteChanged(it)) },
            placeholder = stringResource(R.string.transaction_form_note_hint),
            leadingIcon = MonAIIcons.EditNote,
            supportingText = errors[TransactionField.NOTE],
            compact = true,
            contentDescription = stringResource(R.string.transaction_form_note),
        )
    }
}
