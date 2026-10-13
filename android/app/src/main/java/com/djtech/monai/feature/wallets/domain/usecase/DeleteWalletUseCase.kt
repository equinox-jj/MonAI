package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.flow.first
import javax.inject.Inject

/**
 * Deletes a wallet with no transactions. The default wallet is refused on the device; a wallet with
 * transactions fails with [WalletError.HasTransactions], so the screen can offer to archive it.
 */
class DeleteWalletUseCase @Inject constructor(private val walletRepository: WalletRepository) {
    suspend operator fun invoke(id: String): WalletResult<Unit> {
        if (walletRepository.observeWallet(id).first()?.isDefault == true) {
            return Outcome.Failure(WalletError.DefaultRequired)
        }
        return walletRepository.deleteWallet(id)
    }
}
