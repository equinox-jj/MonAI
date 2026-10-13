package com.djtech.monai.feature.wallets.domain.usecase

import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.feature.wallets.domain.repository.PaymentProviderRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** The provider catalog for the Add wallet grid, by sort order; the bundled seed until first refreshed. */
class ObservePaymentProvidersUseCase @Inject constructor(
    private val paymentProviderRepository: PaymentProviderRepository,
) {
    operator fun invoke(): Flow<List<PaymentProvider>> = paymentProviderRepository.observeProviders()
}
