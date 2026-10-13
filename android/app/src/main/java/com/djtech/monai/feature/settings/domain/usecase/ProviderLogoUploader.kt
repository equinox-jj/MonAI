package com.djtech.monai.feature.settings.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.ImageEncoding
import com.djtech.monai.core.media.ImageProcessor
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
import javax.inject.Inject

/**
 * Shrinks the picked logo to a lossless WebP within the API's 512 KB and uploads it. Shared by the
 * create and update use cases, which both end with an optional new logo.
 */
class ProviderLogoUploader @Inject constructor(
    private val adminProviderRepository: AdminProviderRepository,
    private val imageProcessor: ImageProcessor,
) {
    suspend fun upload(providerId: String, logoUri: String): AdminProviderResult<AdminPaymentProvider> {
        val image = imageProcessor.fitWithin(
            logoUri,
            LOGO_MAX_SIDE,
            ImageEncoding.WEBP_LOSSLESS,
            MAX_LOGO_BYTES,
        ) ?: return Outcome.Failure(AdminProviderError.LogoUnsupported)
        return adminProviderRepository.uploadLogo(providerId, image)
    }

    companion object {
        /** Logos show at most 48dp; 256px stays sharp on any screen. */
        const val LOGO_MAX_SIDE = 256
        const val MAX_LOGO_BYTES = 512 * 1024
    }
}
