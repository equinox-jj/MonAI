package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
import javax.inject.Inject

/** Every provider in the catalog, inactive ones included, by sort order. */
class GetAdminProvidersUseCase @Inject constructor(private val adminProviderRepository: AdminProviderRepository) {
    suspend operator fun invoke(): AdminProviderResult<List<AdminPaymentProvider>> =
        adminProviderRepository.listProviders()
}
