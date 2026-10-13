package com.djtech.monai.feature.wallets.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

/**
 * Serves [wallets] as the cache, in the given order, and answers refresh with [refreshResult].
 * Writes are recorded and answered with the matching `*Result`; a null result echoes a wallet built from the call.
 */
class FakeWalletRepository(wallets: List<Wallet> = emptyList()) : WalletRepository {
    val wallets = MutableStateFlow(wallets)
    var refreshResult: WalletResult<Unit> = Outcome.Success(Unit)
    var refreshCount = 0

    /** When set, refresh suspends until it completes, to observe the in-flight state. */
    var gate: CompletableDeferred<Unit>? = null

    val created = mutableListOf<WalletInput>()
    var createResult: WalletResult<Wallet>? = null

    val updates = mutableListOf<Pair<String, WalletChanges>>()
    var updateResult: WalletResult<Wallet>? = null

    val deleted = mutableListOf<String>()
    var deleteResult: WalletResult<Unit> = Outcome.Success(Unit)

    val refreshedIds = mutableListOf<String>()
    var refreshWalletResult: WalletResult<Unit> = Outcome.Success(Unit)

    override fun observeWallets(): Flow<List<Wallet>> = wallets.map { list -> list.filterNot(Wallet::isArchived) }

    override fun observeAllWallets(): Flow<List<Wallet>> = wallets

    override fun observeWallet(id: String): Flow<Wallet?> = wallets.map { list -> list.find { it.id == id } }

    override suspend fun refresh(): WalletResult<Unit> {
        refreshCount++
        gate?.await()
        return refreshResult
    }

    override suspend fun refreshWallet(id: String): WalletResult<Unit> {
        refreshedIds += id
        return refreshWalletResult
    }

    override suspend fun createWallet(input: WalletInput): WalletResult<Wallet> {
        created += input
        return createResult ?: Outcome.Success(input.toWallet())
    }

    override suspend fun updateWallet(id: String, changes: WalletChanges): WalletResult<Wallet> {
        updates += id to changes
        return updateResult ?: Outcome.Success(checkNotNull(wallets.value.find { it.id == id }).applying(changes))
    }

    override suspend fun deleteWallet(id: String): WalletResult<Unit> {
        deleted += id
        return deleteResult
    }

    private fun WalletInput.toWallet() = wallet(
        id = "new",
        name = name,
        isDefault = isDefault,
        type = checkNotNull(type),
        providerId = providerId,
        initialBalance = initialBalance,
        balance = initialBalance,
        color = color,
    )

    private fun Wallet.applying(changes: WalletChanges) = copy(
        name = changes.name ?: name,
        type = changes.type ?: type,
        initialBalance = changes.initialBalance ?: initialBalance,
        color = changes.color ?: color,
        isDefault = changes.isDefault ?: isDefault,
        isArchived = changes.isArchived ?: isArchived,
    )
}
