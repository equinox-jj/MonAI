package com.djtech.monai.feature.wallets.presentation.walletdetail.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.OutflowDay
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.RowFlow
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletRowLookups
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletTransactionRow
import java.time.LocalDate
import java.time.YearMonth

/** One bar per day from the 1st to [today] (the whole month once it's over), zero on days without any. */
internal fun Map<LocalDate, Long>.toOutflowDays(month: YearMonth, today: LocalDate): List<OutflowDay> {
    val lastDay = if (YearMonth.from(today) == month) today.dayOfMonth else month.lengthOfMonth()
    return (1..lastDay).map { day ->
        val date = month.atDay(day)
        OutflowDay(date, this[date] ?: 0)
    }
}

/** [walletId] is the wallet whose detail shows the row: a transfer reads as money in or out of it. */
internal fun Transaction.toWalletRow(walletId: String, lookups: WalletRowLookups): WalletTransactionRow {
    val category = categoryId?.let(lookups.categories::get)
    val isIncoming = type == TransactionType.INCOME || (type == TransactionType.TRANSFER && toWalletId == walletId)
    val text = note?.takeIf(String::isNotBlank) ?: merchant?.takeIf(String::isNotBlank) ?: category?.name
    return WalletTransactionRow(
        id = id,
        type = type,
        amount = amount,
        flow = if (isIncoming) RowFlow.IN else RowFlow.OUT,
        title = when {
            text != null -> UiText.Dynamic(text)
            type == TransactionType.TRANSFER -> UiText.Resource(R.string.wallet_detail_transfer)
            else -> UiText.Resource(R.string.wallet_detail_untitled)
        },
        label = if (type == TransactionType.TRANSFER) {
            transferLabel(isIncoming, lookups)
        } else {
            categoryLabel(category?.name)
        },
        date = date,
        icon = category?.icon,
        color = category?.color,
    )
}

private fun categoryLabel(name: String?): UiText =
    name?.let(UiText::Dynamic) ?: UiText.Resource(R.string.wallet_detail_no_category)

private fun Transaction.transferLabel(isIncoming: Boolean, lookups: WalletRowLookups): UiText {
    val other = (if (isIncoming) walletId else toWalletId)?.let(lookups.walletNames::get)
        ?: return UiText.Resource(R.string.wallet_detail_transfer)
    return UiText.Resource(
        if (isIncoming) R.string.wallet_detail_transfer_from else R.string.wallet_detail_transfer_to,
        other,
    )
}
