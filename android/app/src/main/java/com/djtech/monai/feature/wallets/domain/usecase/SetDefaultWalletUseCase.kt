package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import javax.inject.Inject

/** Makes the wallet the default; the server clears the previous default in the same step. */
class SetDefaultWalletUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    suspend operator fun invoke(id: String): WalletResult<Wallet> =
        walletRepository.updateWallet(id, WalletChanges(isDefault = true))
}
