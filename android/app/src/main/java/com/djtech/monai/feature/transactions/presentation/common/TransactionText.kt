package com.djtech.monai.feature.transactions.presentation.common

import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MoneyDirection
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import java.time.LocalDate
import java.time.YearMonth
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.format.TextStyle
import java.time.temporal.ChronoUnit
import java.util.Locale

// Display text shared by the transaction screens. Month and day names follow the app's locale.

@Composable
@ReadOnlyComposable
internal fun currentLocale(): Locale = LocalConfiguration.current.locales[0]

internal fun TransactionType.direction(): MoneyDirection = when (this) {
    TransactionType.EXPENSE -> MoneyDirection.Expense
    TransactionType.INCOME -> MoneyDirection.Income
    TransactionType.TRANSFER -> MoneyDirection.Transfer
}

internal fun TransactionType.sign(): MoneySign = when (this) {
    TransactionType.EXPENSE -> MoneySign.Negative
    TransactionType.INCOME -> MoneySign.Positive
    TransactionType.TRANSFER -> MoneySign.None
}

/** `−Rp 35.000` / `+Rp 8.500.000` / `Rp 500.000`: the sign comes from the type. */
internal fun Transaction.amountText(): String = formatRupiahSigned(amount, type.sign())

/** A net that can be either sign: `+Rp 40.000`, `−Rp 65.000`, `Rp 0`. */
internal fun netText(net: Long): String = formatRupiahSigned(
    net,
    when {
        net > 0 -> MoneySign.Positive
        net < 0 -> MoneySign.Negative
        else -> MoneySign.None
    },
)

@Composable
@ReadOnlyComposable
internal fun TransactionType.label(): String = stringResource(
    when (this) {
        TransactionType.EXPENSE -> R.string.transaction_type_expense
        TransactionType.INCOME -> R.string.transaction_type_income
        TransactionType.TRANSFER -> R.string.transaction_type_transfer
    },
)

@Composable
@ReadOnlyComposable
internal fun TransactionSource.label(): String = stringResource(
    when (this) {
        TransactionSource.MANUAL -> R.string.transaction_source_manual
        TransactionSource.QUICK_ADD -> R.string.transaction_source_quick_add
        TransactionSource.RECEIPT -> R.string.transaction_source_receipt
    },
)

/** The note, else the merchant, else the category name, else "Transfer" or "Transaction". */
@Composable
internal fun Transaction.title(lookups: TransactionLookups): String =
    note?.takeIf(String::isNotBlank)
        ?: merchant?.takeIf(String::isNotBlank)
        ?: lookups.category(categoryId)?.name
        ?: if (type == TransactionType.TRANSFER) {
            stringResource(R.string.transaction_type_transfer)
        } else {
            stringResource(R.string.transaction_untitled)
        }

/** `BCA → GoPay` for a transfer, else the wallet name; null when a name isn't cached. */
internal fun Transaction.walletsText(lookups: TransactionLookups): String? {
    val from = lookups.wallet(walletId)?.name
    if (type != TransactionType.TRANSFER) return from
    val to = lookups.wallet(toWalletId)?.name
    return if (from != null && to != null) "$from → $to" else from ?: to
}

/** How a row says when: the time it was recorded (day lists) or its date (search). */
enum class RowWhen { TIME, DATE }

/** `Food · GoPay · 12:40`, `Transfer · BCA → GoPay · 19:20`, or with `10 Oct`. Unknown names are left out. */
@Composable
internal fun Transaction.metaText(lookups: TransactionLookups, rowWhen: RowWhen, zone: ZoneId): String {
    val kind = if (type == TransactionType.TRANSFER) {
        stringResource(R.string.transaction_type_transfer)
    } else {
        lookups.category(categoryId)?.name
    }
    val time = when (rowWhen) {
        RowWhen.TIME -> createdAt.atZone(zone).toLocalTime().truncatedTo(ChronoUnit.MINUTES).format(TIME)
        RowWhen.DATE -> date.format(DateTimeFormatter.ofPattern("d MMM", currentLocale()))
    }
    return listOfNotNull(kind, walletsText(lookups), time).joinToString(" · ")
}

/** `Today · Sat, 10 Oct`, `Yesterday · Fri, 9 Oct`, `Thu, 8 Oct 2026`. */
@Composable
internal fun dayHeaderText(date: LocalDate, today: LocalDate): String {
    val locale = currentLocale()
    val short = date.format(DateTimeFormatter.ofPattern("EEE, d MMM", locale))
    return when (date) {
        today -> stringResource(R.string.transaction_day_today, short)
        today.minusDays(1) -> stringResource(R.string.transaction_day_yesterday, short)
        else -> date.format(DateTimeFormatter.ofPattern("EEE, d MMM yyyy", locale))
    }
}

/** `Today, 10 Oct`, `Yesterday, 9 Oct`, `Fri, 9 Oct 2026`. */
@Composable
internal fun dateText(date: LocalDate, today: LocalDate): String {
    val locale = currentLocale()
    val short = date.format(DateTimeFormatter.ofPattern("d MMM", locale))
    return when (date) {
        today -> stringResource(R.string.transaction_date_today, short)
        today.minusDays(1) -> stringResource(R.string.transaction_date_yesterday, short)
        else -> date.format(DateTimeFormatter.ofPattern("EEE, d MMM yyyy", locale))
    }
}

/** `October 2026`. */
@Composable
internal fun monthText(month: YearMonth): String =
    month.format(DateTimeFormatter.ofPattern("LLLL yyyy", currentLocale()))

/** `October`. */
@Composable
internal fun monthNameText(month: YearMonth): String =
    month.month.getDisplayName(TextStyle.FULL_STANDALONE, currentLocale())

/** The circle icon of a row: the category's, or the swap icon on the brand color for a transfer. */
@Composable
internal fun Transaction.iconAndColor(lookups: TransactionLookups): Pair<ImageVector, Color> =
    if (type == TransactionType.TRANSFER) {
        MonAIIcons.SwapHoriz to MonAITheme.colors.primary
    } else {
        lookups.category(categoryId).iconAndColor()
    }

@Composable
internal fun Category?.iconAndColor(): Pair<ImageVector, Color> =
    categoryIcon(this?.icon) to CategoryColors.parse(this?.color)

private val TIME: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")
