package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.PaymentProviderRepository
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import com.djtech.monai.feature.wallets.domain.validation.normalized
import com.djtech.monai.feature.wallets.domain.validation.validate
import kotlinx.coroutines.flow.first
import javax.inject.Inject

/** Validates [WalletInput] on the device, resolves a seed provider to its server id, then creates the wallet. */
class CreateWalletUseCase @Inject constructor(
    private val walletRepository: WalletRepository,
    private val paymentProviderRepository: PaymentProviderRepository,
) {
    suspend operator fun invoke(input: WalletInput): WalletResult<Wallet> {
        val normalized = input.normalized()
        val errors = normalized.validate()
        if (errors.isNotEmpty()) return Outcome.Failure(WalletError.InvalidFields(errors))
        val resolved = when (val result = resolveProvider(normalized)) {
            is Outcome.Success -> result.data
            is Outcome.Failure -> return result
        }
        return walletRepository.createWallet(resolved)
    }

    /**
     * Seed providers only know their slug, so the catalog is fetched to find the id. A provider the
     * server no longer lists becomes a custom wallet with the same name and type.
     */
    private suspend fun resolveProvider(input: WalletInput): WalletResult<WalletInput> {
        val slug = input.providerSlug
        if (input.providerId != null || slug == null) return Outcome.Success(input)
        when (val refreshed = paymentProviderRepository.refresh()) {
            is Outcome.Failure -> return refreshed
            is Outcome.Success -> Unit
        }
        val providerId = paymentProviderRepository.observeProviders().first()
            .firstOrNull { it.slug == slug && it.id.isNotEmpty() }
            ?.id
        return Outcome.Success(input.copy(providerId = providerId, providerSlug = null))
    }
}
