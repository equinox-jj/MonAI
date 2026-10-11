package com.djtech.monai.core.model

import java.time.Instant

/** The signed-in user, from `GET /me`. */
data class User(
    val id: String,
    val name: String,
    val email: String,
    /** Presigned GET URL; expires after 15 minutes. Null shows the initials avatar. */
    val avatarUrl: String?,
    /** IANA zone, e.g. `Asia/Jakarta`. Decides what "today" means for transaction dates. */
    val timezone: String,
    val role: Role,
    val permissions: Set<String>,
    val createdAt: Instant,
) {
    fun hasPermission(code: String): Boolean = code in permissions
}

data class Role(
    val slug: String,
    val name: String,
)

/** Permission codes the backend grants; they match its Go constants. */
object Permissions {
    const val PAYMENT_PROVIDER_VIEW = "payment_provider.view"
    const val PAYMENT_PROVIDER_CREATE = "payment_provider.create"
    const val PAYMENT_PROVIDER_UPDATE = "payment_provider.update"
    const val PAYMENT_PROVIDER_DELETE = "payment_provider.delete"
}
