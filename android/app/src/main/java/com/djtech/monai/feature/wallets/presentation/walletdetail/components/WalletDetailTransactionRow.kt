package com.djtech.monai.feature.wallets.presentation.walletdetail.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MonAITransactionRow
import com.djtech.monai.core.designsystem.component.MoneyDirection
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.wallets.presentation.common.shortDate
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.RowFlow
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletTransactionRow

/** A transaction in "This month", signed from the wallet's side: a transfer out is `−`, in is `+`. */
@Composable
internal fun WalletDetailTransactionRow(
    row: WalletTransactionRow,
    onClick: () -> Unit,
    showDivider: Boolean,
    modifier: Modifier = Modifier,
) {
    val isTransfer = row.type == TransactionType.TRANSFER
    MonAITransactionRow(
        title = row.title.asString(),
        meta = stringResource(R.string.wallet_detail_row_meta, row.label.asString(), row.date.shortDate()),
        amount = formatRupiahSigned(
            row.amount,
            if (row.flow == RowFlow.IN) MoneySign.Positive else MoneySign.Negative,
        ),
        direction = when (row.type) {
            TransactionType.EXPENSE -> MoneyDirection.Expense
            TransactionType.INCOME -> MoneyDirection.Income
            TransactionType.TRANSFER -> MoneyDirection.Transfer
        },
        categoryIcon = if (isTransfer) MonAIIcons.SwapHoriz else categoryIcon(row.icon),
        categoryColor = if (isTransfer) MonAITheme.colors.primary else CategoryColors.parse(row.color),
        modifier = modifier,
        onClick = onClick,
        showDivider = showDivider,
    )
}
