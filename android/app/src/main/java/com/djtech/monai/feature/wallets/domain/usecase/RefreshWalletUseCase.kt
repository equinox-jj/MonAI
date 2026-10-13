package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import javax.inject.Inject

/** Refetches one wallet into the cache, e.g. when its detail screen opens. */
class RefreshWalletUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    suspend operator fun invoke(id: String): WalletResult<Unit> = walletRepository.refreshWallet(id)
}
