package com.djtech.monai.core.designsystem.component

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType

/** The sign a drafted amount is shown with: minus for an expense, plus for income. */
fun TransactionType.moneySign(): MoneySign = when (this) {
    TransactionType.EXPENSE -> MoneySign.Negative
    TransactionType.INCOME -> MoneySign.Positive
    TransactionType.TRANSFER -> MoneySign.None
}

/** Red for an expense, green for income, plain text for a transfer. */
@Composable
fun TransactionType.moneyColor(): Color = when (this) {
    TransactionType.EXPENSE -> MoneyDirection.Expense.color()
    TransactionType.INCOME -> MoneyDirection.Income.color()
    TransactionType.TRANSFER -> MonAITheme.colors.textPrimary
}
