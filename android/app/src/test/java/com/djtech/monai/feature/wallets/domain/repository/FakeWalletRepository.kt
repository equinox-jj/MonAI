package com.djtech.monai.feature.wallets.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

/** Serves [wallets] as the cache, in the given order, and answers refresh with [refreshResult]. */
class FakeWalletRepository(wallets: List<Wallet> = emptyList()) : WalletRepository {
    val wallets = MutableStateFlow(wallets)
    var refreshResult: WalletResult<Unit> = Outcome.Success(Unit)
    var refreshCount = 0

    /** When set, refresh suspends until it completes, to observe the in-flight state. */
    var gate: CompletableDeferred<Unit>? = null

    override fun observeWallets(): Flow<List<Wallet>> = wallets.map { list -> list.filterNot(Wallet::isArchived) }

    override fun observeAllWallets(): Flow<List<Wallet>> = wallets

    override fun observeWallet(id: String): Flow<Wallet?> = wallets.map { list -> list.find { it.id == id } }

    override suspend fun refresh(): WalletResult<Unit> {
        refreshCount++
        gate?.await()
        return refreshResult
    }
}
