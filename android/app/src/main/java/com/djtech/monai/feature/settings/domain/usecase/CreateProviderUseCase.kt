package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.model.SavedProvider
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
import com.djtech.monai.feature.settings.domain.validation.aliasIssue
import com.djtech.monai.feature.settings.domain.validation.nameIssue
import com.djtech.monai.feature.settings.domain.validation.normalized
import javax.inject.Inject

/**
 * Creates a provider, deactivates it when the form says so (the API creates them active) and then
 * uploads [logoUri]. Once created, a failed status or logo step doesn't fail the whole: it comes back
 * in [SavedProvider.logoError] or as an active provider the admin can switch off.
 */
class CreateProviderUseCase @Inject constructor(
    private val adminProviderRepository: AdminProviderRepository,
    private val logoUploader: ProviderLogoUploader,
    private val changeEvents: ProviderChangeEvents,
) {
    suspend operator fun invoke(input: ProviderInput, logoUri: String?): AdminProviderResult<SavedProvider> {
        val normalized = input.normalized()
        normalized.nameIssue()?.let { return Outcome.Failure(AdminProviderError.InvalidName(it)) }
        normalized.aliasIssue()?.let { return Outcome.Failure(AdminProviderError.InvalidAliases(it)) }

        var provider = when (val created = adminProviderRepository.createProvider(normalized)) {
            is Outcome.Success -> created.data
            is Outcome.Failure -> return created
        }
        if (!normalized.isActive) {
            val deactivated = adminProviderRepository.setActive(provider.id, active = false)
            if (deactivated is Outcome.Success) provider = deactivated.data
        }
        val saved = if (logoUri == null) {
            SavedProvider(provider)
        } else {
            when (val logo = logoUploader.upload(provider.id, logoUri)) {
                is Outcome.Success -> SavedProvider(logo.data)
                is Outcome.Failure -> SavedProvider(provider, logoError = logo.error)
            }
        }
        changeEvents.emit(provider.id)
        return Outcome.Success(saved)
    }
}
