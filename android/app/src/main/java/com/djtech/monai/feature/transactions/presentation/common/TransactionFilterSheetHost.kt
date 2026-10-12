package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.runtime.Composable
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.MonthTotals
import java.time.YearMonth

/** Shows whichever filter sheet is open, if any. */
@Composable
internal fun TransactionFilterSheetHost(
    sheet: FilterSheet?,
    month: YearMonth,
    currentMonth: YearMonth,
    wallets: List<Wallet>,
    categories: List<Category>,
    totals: MonthTotals?,
    monthPickerTotals: Map<YearMonth, Long>,
    onIntent: (FilterIntent) -> Unit,
) {
    when (sheet) {
        is FilterSheet.Month -> TransactionMonthPickerSheet(
            sheet,
            currentMonth,
            monthPickerTotals,
            onIntent,
        )

        is FilterSheet.Wallet -> TransactionWalletFilterSheet(sheet, wallets, onIntent)
        is FilterSheet.Category -> TransactionCategoryFilterSheet(sheet, categories, onIntent)
        is FilterSheet.Type -> TransactionTypeFilterSheet(
            sheet,
            month,
            totals,
            onIntent,
        )

        null -> Unit
    }
}
