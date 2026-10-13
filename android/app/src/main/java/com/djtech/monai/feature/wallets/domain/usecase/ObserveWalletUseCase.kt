package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** One cached wallet, archived or not; null when it isn't cached. */
class ObserveWalletUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    operator fun invoke(id: String): Flow<Wallet?> = walletRepository.observeWallet(id)
}
