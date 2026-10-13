package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.model.ProviderChanges
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.model.SavedProvider
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
import com.djtech.monai.feature.settings.domain.validation.aliasIssue
import com.djtech.monai.feature.settings.domain.validation.nameIssue
import com.djtech.monai.feature.settings.domain.validation.normalized
import javax.inject.Inject

/**
 * Saves the form over [original], sending only the fields that changed, then a new status and a
 * new logo when there is one. A logo that fails after the rest saved is reported in
 * [SavedProvider.logoError].
 */
class UpdateProviderUseCase @Inject constructor(
    private val adminProviderRepository: AdminProviderRepository,
    private val logoUploader: ProviderLogoUploader,
    private val changeEvents: ProviderChangeEvents,
) {
    suspend operator fun invoke(
        original: AdminPaymentProvider,
        input: ProviderInput,
        logoUri: String?,
    ): AdminProviderResult<SavedProvider> {
        val normalized = input.normalized()
        normalized.nameIssue()?.let { return Outcome.Failure(AdminProviderError.InvalidName(it)) }
        normalized.aliasIssue()?.let { return Outcome.Failure(AdminProviderError.InvalidAliases(it)) }

        val changes = ProviderChanges(
            name = normalized.name.takeIf { it != original.name },
            type = normalized.type.takeIf { it != original.type },
            aliases = normalized.aliases.takeIf { it != original.aliases.sorted() },
            sortOrder = normalized.sortOrder.takeIf { it != original.sortOrder },
        )
        if (changes.isEmpty && normalized.isActive == original.isActive && logoUri == null) {
            return Outcome.Success(SavedProvider(original))
        }
        var provider = original
        if (!changes.isEmpty) {
            when (val updated = adminProviderRepository.updateProvider(original.id, changes)) {
                is Outcome.Success -> provider = updated.data
                is Outcome.Failure -> return updated
            }
        }
        // From here on something saved, so the list reloads whatever fails next.
        changeEvents.emit(original.id)
        if (normalized.isActive != original.isActive) {
            when (val status = adminProviderRepository.setActive(original.id, normalized.isActive)) {
                is Outcome.Success -> provider = status.data
                is Outcome.Failure -> return status
            }
        }
        if (logoUri == null) return Outcome.Success(SavedProvider(provider))
        return when (val logo = logoUploader.upload(provider.id, logoUri)) {
            is Outcome.Success -> Outcome.Success(SavedProvider(logo.data))
            is Outcome.Failure -> Outcome.Success(SavedProvider(provider, logoError = logo.error))
        }
    }
}
