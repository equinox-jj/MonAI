package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import javax.inject.Inject

/** Brings an archived wallet back to the pickers. */
class UnarchiveWalletUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    suspend operator fun invoke(id: String): WalletResult<Wallet> =
        walletRepository.updateWallet(id, WalletChanges(isArchived = false))
}
