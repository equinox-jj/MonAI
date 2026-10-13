package com.djtech.monai.feature.wallets.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.log.runLogged
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.flatMap
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.database.dao.WalletDao
import com.djtech.monai.core.database.entity.WalletEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.wallets.data.dto.WalletDto
import com.djtech.monai.feature.wallets.data.mapper.asModel
import com.djtech.monai.feature.wallets.data.mapper.toCreateRequest
import com.djtech.monai.feature.wallets.data.mapper.toUpdateRequest
import com.djtech.monai.feature.wallets.data.mapper.toWalletError
import com.djtech.monai.feature.wallets.data.remote.WalletApiService
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ApiWalletRepository @Inject constructor(
    private val walletApiService: WalletApiService,
    private val apiCaller: ApiCaller,
    private val walletDao: WalletDao,
    private val errorLogger: ErrorLogger,
) : WalletRepository {

    override fun observeWallets(): Flow<List<Wallet>> = walletDao.observeAll().map { entities ->
        entities.filterNot(WalletEntity::isArchived).map(WalletEntity::asModel)
    }

    override fun observeAllWallets(): Flow<List<Wallet>> = walletDao.observeAll().map { entities ->
        entities.map(WalletEntity::asModel)
    }

    override fun observeWallet(id: String): Flow<Wallet?> = walletDao.observe(id).map { it?.asModel() }

    // Archived wallets too, so replacing the cache keeps them for history and the archive screen.
    // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
    override suspend fun refresh(): WalletResult<Unit> =
        apiCaller.callRaw { walletApiService.getWallets(includeArchived = true).data.map(WalletDto::asModel) }
            .mapError(ApiError::toWalletError)
            .flatMap { wallets ->
                cacheWrite("Caching wallets") { walletDao.replaceAll(wallets.map(Wallet::asEntity)) }
            }

    override suspend fun refreshWallet(id: String): WalletResult<Unit> {
        val result = apiCaller.callRaw { walletApiService.getWallet(id).data.asModel() }
        return when (result) {
            is Outcome.Success -> cacheWrite("Caching a wallet") { walletDao.upsertAll(listOf(result.data.asEntity())) }
            is Outcome.Failure -> {
                val error = result.error.toWalletError()
                // Deleted elsewhere: drop it so the screens stop showing it.
                if (error == WalletError.NotFound) cacheWrite("Dropping a deleted wallet") { walletDao.delete(id) }
                Outcome.Failure(error)
            }
        }
    }

    override suspend fun createWallet(input: WalletInput): WalletResult<Wallet> =
        write(nameSent = true) { walletApiService.createWallet(input.toCreateRequest()).data }

    override suspend fun updateWallet(id: String, changes: WalletChanges): WalletResult<Wallet> =
        write(nameSent = changes.name != null) { walletApiService.updateWallet(id, changes.toUpdateRequest()).data }

    override suspend fun deleteWallet(id: String): WalletResult<Unit> =
        apiCaller.callRaw { walletApiService.deleteWallet(id) }
            .mapError(ApiError::toWalletError)
            .flatMap { cacheWrite("Removing a deleted wallet") { walletDao.delete(id) } }

    /** Sends a create or update, then caches the wallet the server returns. */
    private suspend fun write(nameSent: Boolean, call: suspend () -> WalletDto): WalletResult<Wallet> =
        apiCaller.callRaw { call().asModel() }
            .mapError { it.toWalletError(nameSent) }
            .flatMap { wallet ->
                cacheWrite("Caching a saved wallet") {
                    cacheSaved(wallet)
                    wallet
                }
            }

    // The server clears the old default when a new one is set; mirror that here instead of refetching.
    private suspend fun cacheSaved(wallet: Wallet) {
        val formerDefaults = if (wallet.isDefault) {
            walletDao.observeAll().first()
                .filter { it.isDefault && it.id != wallet.id }
                .map { it.copy(isDefault = false) }
        } else {
            emptyList()
        }
        walletDao.upsertAll(listOf(wallet.asEntity()) + formerDefaults)
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private inline fun <T> cacheWrite(what: String, write: () -> T): WalletResult<T> =
        errorLogger.runLogged("$what failed", WalletError.Unexpected, write)
}
