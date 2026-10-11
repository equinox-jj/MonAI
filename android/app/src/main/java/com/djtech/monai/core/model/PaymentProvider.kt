package com.djtech.monai.core.model

/** A bank or e-wallet from the catalog, used as a template when adding a wallet. */
data class PaymentProvider(
    val id: String,
    val slug: String,
    val name: String,
    val type: WalletType,
    val logoUrl: String?,
    /** Lowercase names the quick-add parser matches, e.g. `gpay` for GoPay. */
    val aliases: List<String>,
    /** Lower appears first. */
    val sortOrder: Int,
)

/** `GET /payment-providers`. [version] changes whenever the catalog does. */
data class PaymentProviderCatalog(
    val version: Long,
    val providers: List<PaymentProvider>,
)
