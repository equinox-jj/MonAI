package com.djtech.monai.feature.profile.domain.model

/** A `PATCH /me`: only the non-null fields change. */
data class ProfileChanges(
    val name: String? = null,
    val timezone: String? = null,
) {
    val isEmpty: Boolean get() = name == null && timezone == null
}
