package com.djtech.monai.feature.settings.domain.model

import com.djtech.monai.core.model.WalletType
import java.time.Instant

/** A catalog provider as admins see it, inactive ones included. */
data class AdminPaymentProvider(
    val id: String,
    val slug: String,
    val name: String,
    val type: WalletType,
    val logoUrl: String?,
    /** Lowercase words quick add matches, e.g. `gpay` for GoPay. */
    val aliases: List<String>,
    /** Lower appears first. */
    val sortOrder: Int,
    /** Inactive providers are hidden from users adding a wallet. */
    val isActive: Boolean,
    /** Cash and the like: can't be deactivated, deleted or have its slug changed. */
    val isSystem: Boolean,
    val updatedAt: Instant,
)
