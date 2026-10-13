package com.djtech.monai.feature.settings.presentation.settings.mapper

import com.djtech.monai.core.common.format.initialsOf
import com.djtech.monai.core.model.Permissions
import com.djtech.monai.core.model.User
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsProfile

/** The role every account starts with; it gets no badge. */
private const val DEFAULT_ROLE = "user"

fun User.toSettingsProfile(): SettingsProfile = SettingsProfile(
    name = name,
    email = email,
    initials = initialsOf(name),
    avatarUrl = avatarUrl,
    roleBadge = role.name.takeIf { role.slug != DEFAULT_ROLE },
)

/**
 * Regular users can view the catalog too (the wallet picker reads it), so the admin section needs
 * a permission to change it.
 */
fun User?.canManageProviders(): Boolean = this != null && (
    hasPermission(Permissions.PAYMENT_PROVIDER_CREATE) ||
        hasPermission(Permissions.PAYMENT_PROVIDER_UPDATE) ||
        hasPermission(Permissions.PAYMENT_PROVIDER_DELETE)
    )
