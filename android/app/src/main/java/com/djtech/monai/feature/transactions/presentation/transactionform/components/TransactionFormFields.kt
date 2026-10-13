package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIFieldTile
import com.djtech.monai.core.designsystem.component.MonAITileIcon
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.presentation.common.dateText
import com.djtech.monai.feature.transactions.presentation.common.iconAndColor
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormIntent
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormState
import com.djtech.monai.feature.transactions.presentation.transactionform.model.WalletTarget

/**
 * Everything between the amount and the keypad: the category (chips when adding, a tile when
 * editing) or a transfer's From → To, then wallet and date, then the note.
 */
@Composable
internal fun TransactionFormFields(
    state: TransactionFormState,
    onIntent: (TransactionFormIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val horizontal = Modifier.padding(horizontal = MonAITheme.spacing.screenHorizontal)
    val choose = stringResource(R.string.transaction_form_choose)
    val errors = state.errors.mapValues { it.value.asString() }
    val check = stringResource(R.string.ai_hint_check)
    fun highlight(field: TransactionField) = state.highlights[field] ?: FieldHighlight.None
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
        when {
            state.type == TransactionType.TRANSFER -> TransferWallets(state, errors, onIntent, horizontal)
            state.isEdit -> {
                val category = state.lookups.category(state.categoryId)
                val (icon, color) = category.iconAndColor()
                MonAIFieldTile(
                    label = stringResource(R.string.transaction_form_category),
                    value = category?.name ?: choose,
                    onClick = { onIntent(TransactionFormIntent.OpenCategoryPicker) },
                    modifier = horizontal,
                    leading = {
                        MonAICategoryIcon(
                            icon,
                            color,
                            size = MonAITheme.sizes.avatarSmall,
                            iconSize = MonAITheme.sizes.iconMd,
                        )
                    },
                    showChevron = true,
                    error = errors[TransactionField.CATEGORY],
                    highlight = highlight(TransactionField.CATEGORY),
                    hint = check,
                )
            }

            else -> TransactionFormCategoryChips(
                categories = state.categories,
                selectedId = state.categoryId,
                error = errors[TransactionField.CATEGORY],
                onPick = { onIntent(TransactionFormIntent.PickCategory(it)) },
                onShowAll = { onIntent(TransactionFormIntent.OpenCategoryPicker) },
                highlight = highlight(TransactionField.CATEGORY),
            )
        }
        Row(horizontal.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
            if (state.type != TransactionType.TRANSFER) {
                MonAIFieldTile(
                    label = if (state.isEdit) stringResource(R.string.transaction_form_wallet) else null,
                    value = state.lookups.wallet(state.walletId)?.name ?: choose,
                    onClick = { onIntent(TransactionFormIntent.OpenWalletPicker(WalletTarget.SOURCE)) },
                    modifier = Modifier.weight(1f),
                    leading = { MonAITileIcon(MonAIIcons.AccountBalanceWallet) },
                    showChevron = !state.isEdit,
                    error = errors[TransactionField.WALLET],
                    highlight = highlight(TransactionField.WALLET),
                    hint = check,
                )
            }
            MonAIFieldTile(
                label = if (state.isEdit) stringResource(R.string.transaction_form_date) else null,
                value = dateText(state.date, state.today),
                onClick = { onIntent(TransactionFormIntent.OpenDatePicker) },
                modifier = Modifier.weight(1f),
                leading = { MonAITileIcon(MonAIIcons.CalendarToday) },
                error = errors[TransactionField.DATE],
                highlight = highlight(TransactionField.DATE),
                hint = check,
            )
        }
        TransactionFormNote(
            note = state.note,
            onNoteChange = { onIntent(TransactionFormIntent.NoteChanged(it)) },
            error = errors[TransactionField.NOTE],
            modifier = horizontal,
        )
    }
}

@Composable
private fun TransferWallets(
    state: TransactionFormState,
    errors: Map<TransactionField, String>,
    onIntent: (TransactionFormIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val choose = stringResource(R.string.transaction_form_choose)
    Row(modifier.fillMaxWidth(), verticalAlignment = Alignment.Top) {
        MonAIFieldTile(
            label = stringResource(R.string.transaction_form_from),
            value = state.lookups.wallet(state.walletId)?.name ?: choose,
            onClick = { onIntent(TransactionFormIntent.OpenWalletPicker(WalletTarget.SOURCE)) },
            modifier = Modifier.weight(1f),
            error = errors[TransactionField.WALLET],
            highlight = state.highlights[TransactionField.WALLET] ?: FieldHighlight.None,
        )
        Icon(
            MonAIIcons.ArrowForward,
            null,
            Modifier
                .padding(horizontal = MonAITheme.spacing.x1, vertical = MonAITheme.spacing.x4)
                .size(MonAITheme.sizes.icon),
            tint = MonAITheme.colors.accent,
        )
        MonAIFieldTile(
            label = stringResource(R.string.transaction_form_to),
            value = state.lookups.wallet(state.toWalletId)?.name ?: choose,
            onClick = { onIntent(TransactionFormIntent.OpenWalletPicker(WalletTarget.DESTINATION)) },
            modifier = Modifier.weight(1f),
            error = errors[TransactionField.TO_WALLET],
            highlight = state.highlights[TransactionField.TO_WALLET] ?: FieldHighlight.None,
        )
    }
}
