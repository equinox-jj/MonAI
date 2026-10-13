package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import com.djtech.monai.feature.wallets.domain.validation.normalized
import com.djtech.monai.feature.wallets.domain.validation.validate
import javax.inject.Inject

/** Validates the edit form and sends only what differs from [Wallet]; an unchanged form makes no call. */
class UpdateWalletUseCase @Inject constructor(private val walletRepository: WalletRepository) {

    suspend operator fun invoke(wallet: Wallet, input: WalletInput): WalletResult<Wallet> {
        val normalized = input.normalized()
        val errors = normalized.validate()
        if (errors.isNotEmpty()) return Outcome.Failure(WalletError.InvalidFields(errors))
        val changes = wallet.changesTo(normalized)
        if (changes.isEmpty) return Outcome.Success(wallet)
        return walletRepository.updateWallet(wallet.id, changes)
    }

    // A null color or type means "unchanged": the API can't clear them back to null. The API only
    // accepts is_default = true, so unticking the default is never sent.
    private fun Wallet.changesTo(input: WalletInput) = WalletChanges(
        name = input.name.takeIf { it != name },
        type = input.type.takeIf { it != null && it != type },
        initialBalance = input.initialBalance.takeIf { it != initialBalance },
        color = input.color.takeIf { it != null && it != color },
        isDefault = true.takeIf { input.isDefault && !isDefault },
    )
}
