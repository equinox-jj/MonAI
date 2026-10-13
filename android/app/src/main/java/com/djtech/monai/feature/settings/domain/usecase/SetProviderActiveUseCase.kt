package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
import javax.inject.Inject

/** Shows a provider to users adding a wallet, or hides it; existing wallets keep working either way. */
class SetProviderActiveUseCase @Inject constructor(
    private val adminProviderRepository: AdminProviderRepository,
    private val changeEvents: ProviderChangeEvents,
) {
    suspend operator fun invoke(id: String, active: Boolean): AdminProviderResult<AdminPaymentProvider> {
        val result = adminProviderRepository.setActive(id, active)
        if (result is Outcome.Success) changeEvents.emit(id)
        return result
    }
}
