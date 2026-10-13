package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
import javax.inject.Inject

class GetAdminProviderUseCase @Inject constructor(private val adminProviderRepository: AdminProviderRepository) {
    suspend operator fun invoke(id: String): AdminProviderResult<AdminPaymentProvider> =
        adminProviderRepository.getProvider(id)
}
