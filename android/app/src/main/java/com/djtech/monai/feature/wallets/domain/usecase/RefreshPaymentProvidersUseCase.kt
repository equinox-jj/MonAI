package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.feature.wallets.domain.model.WalletResult
import com.djtech.monai.feature.wallets.domain.repository.PaymentProviderRepository
import javax.inject.Inject

/** Updates the cached provider catalog when the server's has changed. */
class RefreshPaymentProvidersUseCase @Inject constructor(
    private val paymentProviderRepository: PaymentProviderRepository,
) {
    suspend operator fun invoke(): WalletResult<Unit> = paymentProviderRepository.refresh()
}
