package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** Every cached wallet, archived ones included, default first, then by name. */
class ObserveAllWalletsUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    operator fun invoke(): Flow<List<Wallet>> = walletRepository.observeAllWallets()
}
