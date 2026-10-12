package com.djtech.monai.navigation

import androidx.navigation3.runtime.NavKey
import kotlinx.serialization.Serializable

// Keys are @Serializable so rememberNavBackStack can restore them after process death.

@Serializable
data object WelcomeRoute : NavKey

/** [email] is the one typed on Sign in, so the form doesn't start empty. */
@Serializable
data class RegisterRoute(val email: String = "") : NavKey

/** [email] is the one typed on Register, e.g. after "already has an account". */
@Serializable
data class SignInRoute(val email: String = "") : NavKey

@Serializable
data object HomeRoute : NavKey

@Serializable
data object TransactionsRoute : NavKey

@Serializable
data object WalletsRoute : NavKey

@Serializable
data object SettingsRoute : NavKey

@Serializable
data class TransactionDetailRoute(val id: String) : NavKey

/** [id] is the transaction to edit; null adds one. */
@Serializable
data class TransactionFormRoute(val id: String? = null) : NavKey

/** [month] is `YYYY-MM`, the month to search first; null for the current one. */
@Serializable
data class TransactionSearchRoute(val month: String? = null) : NavKey
