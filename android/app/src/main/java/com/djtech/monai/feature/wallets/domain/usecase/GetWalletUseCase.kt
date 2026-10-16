package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.flatMap
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.flow.firstOrNull
import javax.inject.Inject

/** One wallet, from the cache or else fetched into it; NotFound when the server doesn't have it either. */
class GetWalletUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    suspend operator fun invoke(id: String): WalletResult<Wallet> {
        cached(id)?.let { return Outcome.Success(it) }
        return walletRepository.refreshWallet(id).flatMap {
            cached(id)?.let { Outcome.Success(it) } ?: Outcome.Failure(WalletError.NotFound)
        }
    }

    private suspend fun cached(id: String): Wallet? = walletRepository.observeWallet(id).firstOrNull()
}
