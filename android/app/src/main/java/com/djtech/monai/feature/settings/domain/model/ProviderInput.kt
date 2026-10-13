package com.djtech.monai.feature.settings.domain.model

import com.djtech.monai.core.model.WalletType

/** What the provider form holds. */
data class ProviderInput(
    val name: String,
    val type: WalletType,
    val aliases: List<String>,
    val sortOrder: Int,
    val isActive: Boolean,
)

/** A `PATCH /admin/payment-providers/{id}`: only the non-null fields change; [aliases] replaces the list. */
data class ProviderChanges(
    val name: String? = null,
    val type: WalletType? = null,
    val aliases: List<String>? = null,
    val sortOrder: Int? = null,
) {
    val isEmpty: Boolean get() = this == ProviderChanges()
}

/** A saved provider; [logoError] is set when it was saved but its new logo wasn't. */
data class SavedProvider(
    val provider: AdminPaymentProvider,
    val logoError: AdminProviderError? = null,
)
