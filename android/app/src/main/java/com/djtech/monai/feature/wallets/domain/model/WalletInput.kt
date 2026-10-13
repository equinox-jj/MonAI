package com.djtech.monai.feature.wallets.domain.model

import com.djtech.monai.core.model.WalletType

/**
 * The add/edit wallet form. A wallet picked from the bundled seed catalog has only [providerSlug];
 * `CreateWalletUseCase` resolves it to [providerId].
 */
data class WalletInput(
    val providerId: String? = null,
    val providerSlug: String? = null,
    val name: String,
    /** Required for a custom wallet; a provider wallet takes the provider's. */
    val type: WalletType?,
    /** Rupiah. */
    val initialBalance: Long = 0,
    /** `#RRGGBB`; null keeps the type's card color. */
    val color: String? = null,
    val isDefault: Boolean = false,
) {
    val hasProvider: Boolean get() = providerId != null || providerSlug != null
}
