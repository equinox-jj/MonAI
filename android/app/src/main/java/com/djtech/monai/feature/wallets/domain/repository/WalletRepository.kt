package com.djtech.monai.feature.wallets.domain.repository

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import kotlinx.coroutines.flow.Flow

/** Wallets read from the local cache; [refresh] fills it from the API, and writes update it with the result. */
interface WalletRepository {

    /** Wallets that are not archived, default first, then by name. */
    fun observeWallets(): Flow<List<Wallet>>

    /** Every wallet, archived ones included, in the same order. For labelling transactions by wallet id. */
    fun observeAllWallets(): Flow<List<Wallet>>

    /** One wallet, archived or not; null when it isn't cached. */
    fun observeWallet(id: String): Flow<Wallet?>

    /** Replaces the cache with the server's wallets, archived ones included. */
    suspend fun refresh(): WalletResult<Unit>

    /** Refetches one wallet into the cache; drops it when the server no longer has it. */
    suspend fun refreshWallet(id: String): WalletResult<Unit>

    /** Creates a validated wallet. [WalletInput.providerSlug] is ignored; resolve it to an id first. */
    suspend fun createWallet(input: WalletInput): WalletResult<Wallet>

    /** Edits, sets as default, archives or unarchives. Must change at least one field. */
    suspend fun updateWallet(id: String, changes: WalletChanges): WalletResult<Wallet>

    /** Deletes a wallet with no transactions; fails with `HasTransactions` otherwise. */
    suspend fun deleteWallet(id: String): WalletResult<Unit>
}
