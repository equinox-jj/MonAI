package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.runtime.Composable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.home.presentation.home.model.Greeting
import com.djtech.monai.feature.home.presentation.home.model.RecentTransaction
import com.djtech.monai.feature.home.presentation.home.model.TransactionDay
import java.time.YearMonth
import java.time.format.DateTimeFormatter
import java.time.format.TextStyle
import java.util.Locale

// Display text shared by the Home sections. Month and day names follow the app's locale.

@Composable
@ReadOnlyComposable
internal fun currentLocale(): Locale = LocalConfiguration.current.locales[0]

/** `October`. */
@Composable
@ReadOnlyComposable
internal fun YearMonth.monthName(): String = month.getDisplayName(TextStyle.FULL_STANDALONE, currentLocale())

/** `Oct`. */
@Composable
@ReadOnlyComposable
internal fun YearMonth.shortMonthName(): String = month.getDisplayName(TextStyle.SHORT_STANDALONE, currentLocale())

@Composable
@ReadOnlyComposable
internal fun Greeting.text(): String = stringResource(
    when (this) {
        Greeting.MORNING -> R.string.home_greeting_morning
        Greeting.AFTERNOON -> R.string.home_greeting_afternoon
        Greeting.EVENING -> R.string.home_greeting_evening
        Greeting.WELCOME -> R.string.home_greeting_welcome
    },
)

@Composable
@ReadOnlyComposable
internal fun WalletType.label(): String = stringResource(
    when (this) {
        WalletType.CASH -> R.string.home_wallet_type_cash
        WalletType.BANK -> R.string.home_wallet_type_bank
        WalletType.E_WALLET -> R.string.home_wallet_type_e_wallet
        WalletType.OTHER -> R.string.home_wallet_type_other
    },
)

/** `−Rp 35.000` / `+Rp 8.500.000` / `Rp 500.000`: the sign comes from the type. */
internal fun RecentTransaction.amountText(): String = formatRupiahSigned(
    amount,
    when (type) {
        TransactionType.EXPENSE -> MoneySign.Negative
        TransactionType.INCOME -> MoneySign.Positive
        TransactionType.TRANSFER -> MoneySign.None
    },
)

/** `Food · GoPay · 12:40`, or `Transfer · BCA → GoPay · Yesterday`. Unknown names are left out. */
@Composable
internal fun RecentTransaction.metaText(): String {
    val isTransfer = type == TransactionType.TRANSFER
    val category = if (isTransfer) stringResource(R.string.home_transaction_transfer) else categoryName
    val wallets = if (isTransfer && walletName != null && toWalletName != null) {
        "$walletName → $toWalletName"
    } else {
        walletName
    }
    val day = when (day) {
        is TransactionDay.Today -> day.time.format(TIME)
        TransactionDay.Yesterday -> stringResource(R.string.home_yesterday)
        is TransactionDay.Earlier -> day.date.format(DateTimeFormatter.ofPattern("d MMM", currentLocale()))
    }
    return listOfNotNull(category, wallets, day).joinToString(" · ")
}

private val TIME: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")
