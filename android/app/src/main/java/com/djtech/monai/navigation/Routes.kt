package com.djtech.monai.navigation

import androidx.navigation3.runtime.NavKey
import kotlinx.serialization.Serializable

// Keys are @Serializable so rememberNavBackStack can restore them after process death.

@Serializable
data object WelcomeRoute : NavKey

@Serializable
data object HomeRoute : NavKey

@Serializable
data object TransactionsRoute : NavKey

@Serializable
data object WalletsRoute : NavKey

@Serializable
data object SettingsRoute : NavKey
