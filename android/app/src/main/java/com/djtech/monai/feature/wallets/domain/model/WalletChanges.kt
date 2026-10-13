package com.djtech.monai.feature.wallets.domain.model

import com.djtech.monai.core.model.WalletType

/** A partial wallet update: null fields are left out of the PATCH and keep their value. */
data class WalletChanges(
    val name: String? = null,
    val type: WalletType? = null,
    val initialBalance: Long? = null,
    val color: String? = null,
    /** Only `true` is accepted; another wallet stops being the default when one is set. */
    val isDefault: Boolean? = null,
    val isArchived: Boolean? = null,
) {
    val isEmpty: Boolean get() = this == WalletChanges()
}
