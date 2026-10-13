package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
import javax.inject.Inject

/** Removes a provider and frees its aliases; existing wallets keep their own name and type. */
class DeleteProviderUseCase @Inject constructor(
    private val adminProviderRepository: AdminProviderRepository,
    private val changeEvents: ProviderChangeEvents,
) {
    suspend operator fun invoke(id: String): AdminProviderResult<Unit> {
        val result = adminProviderRepository.deleteProvider(id)
        if (result is Outcome.Success) changeEvents.emit(id)
        return result
    }
}
