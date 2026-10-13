package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.flow.first
import javax.inject.Inject

/** Hides the wallet from pickers, keeping its history. The default wallet is refused on the device. */
class ArchiveWalletUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    suspend operator fun invoke(id: String): WalletResult<Wallet> {
        val wallet = walletRepository.observeWallet(id).first() ?: return Outcome.Failure(WalletError.NotFound)
        if (wallet.isDefault) return Outcome.Failure(WalletError.DefaultRequired)
        return walletRepository.updateWallet(id, WalletChanges(isArchived = true))
    }
}
