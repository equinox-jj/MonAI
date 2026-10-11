package com.djtech.monai.core.model

import java.time.Instant

/** Shared by wallets and payment providers. Names match the API values. */
enum class WalletType { CASH, BANK, E_WALLET, OTHER }

data class Wallet(
    val id: String,
    /** Null for a custom wallet. */
    val providerId: String?,
    val name: String,
    val type: WalletType,
    /** The provider's logo; null for custom wallets or providers without one. */
    val logoUrl: String?,
    /** Rupiah. */
    val initialBalance: Long,
    /** Rupiah, calculated by the server from transactions. */
    val currentBalance: Long,
    val icon: String?,
    /** `#RRGGBB`. */
    val color: String?,
    val isDefault: Boolean,
    /** Hidden from pickers, kept in history. */
    val isArchived: Boolean,
    val createdAt: Instant,
    val updatedAt: Instant,
)
