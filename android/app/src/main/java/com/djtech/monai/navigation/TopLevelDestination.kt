package com.djtech.monai.navigation

import androidx.annotation.StringRes
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.R

/** The main tabs, in bar order. Each keeps its own back stack rooted at [route]. */
enum class TopLevelDestination(val route: NavKey, @StringRes val labelRes: Int) {
    Home(HomeRoute, R.string.nav_home),
    Transactions(TransactionsRoute, R.string.nav_transactions),
    Wallets(WalletsRoute, R.string.nav_wallets),
    Settings(SettingsRoute, R.string.nav_settings),
}
