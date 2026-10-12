package com.djtech.monai.feature.wallets.domain.repository

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import kotlinx.coroutines.flow.Flow

/** Wallets read from the local cache; [refresh] fills it from the API. */
interface WalletRepository {

    /** Wallets that are not archived, default first, then by name. */
    fun observeWallets(): Flow<List<Wallet>>

    /** One wallet, archived or not; null when it isn't cached. */
    fun observeWallet(id: String): Flow<Wallet?>

    /** Replaces the cache with the server's wallets, archived ones included. */
    suspend fun refresh(): WalletResult<Unit>
}
