package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import javax.inject.Inject

/** Replaces the cached wallets with the server's, archived ones included. */
class RefreshWalletsUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    suspend operator fun invoke(): WalletResult<Unit> = walletRepository.refresh()
}
