package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

/** Cached archived wallets, by name. For the Archived wallets screen. */
class ObserveArchivedWalletsUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    operator fun invoke(): Flow<List<Wallet>> =
        walletRepository.observeAllWallets().map { wallets -> wallets.filter(Wallet::isArchived) }
}
