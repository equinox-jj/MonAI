package com.djtech.monai.feature.settings.presentation.settings.model

import androidx.compose.runtime.Immutable

/**
 * The profile card. [roleBadge] is the role's name for anyone above a regular user, e.g. "Admin".
 */
@Immutable
data class SettingsProfile(
    val name: String,
    val email: String,
    val initials: String,
    val avatarUrl: String?,
    val roleBadge: String?,
)

/** A bottom sheet over Settings. */
enum class SettingsSheet { Theme, Language }

/** A confirmation over Settings. */
enum class SettingsDialog { SignOut, SignOutAllDevices }

/** What the detail pane shows next to the menu on a wide screen. */
enum class SettingsPane { Profile, Budget, Categories, Theme, Language, Providers }
