package com.djtech.monai.feature.wallets.domain.model

import com.djtech.monai.core.model.Wallet

/** Rupiah across wallets that are not archived, the same rule as the API's `meta.total_balance`. */
fun List<Wallet>.totalBalance(): Long = filterNot(Wallet::isArchived).sumOf(Wallet::currentBalance)
