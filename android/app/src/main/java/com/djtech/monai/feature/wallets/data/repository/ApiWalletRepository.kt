package com.djtech.monai.feature.wallets.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.dao.WalletDao
import com.djtech.monai.core.database.entity.WalletEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.feature.wallets.data.dto.WalletDto
import com.djtech.monai.feature.wallets.data.mapper.asModel
import com.djtech.monai.feature.wallets.data.mapper.toWalletError
import com.djtech.monai.feature.wallets.data.remote.WalletApiService
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.cancellation.CancellationException

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

    override suspend fun refresh(): WalletResult<Unit> {
        // Archived wallets too, so replacing the cache keeps them for history and the archive screen.
        // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
        val result = apiCaller.callRaw {
            walletApiService.getWallets(includeArchived = true).data.map(WalletDto::asModel)
        }
        return when (result) {
            is Outcome.Success -> cache(result.data)
            is Outcome.Failure -> Outcome.Failure(result.error.toWalletError())
        }
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private suspend fun cache(wallets: List<Wallet>): WalletResult<Unit> = try {
        walletDao.replaceAll(wallets.map(Wallet::asEntity))
        Outcome.Success(Unit)
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Caching wallets failed", e)
        Outcome.Failure(WalletError.Unexpected)
    }
}
