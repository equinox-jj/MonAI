package com.djtech.monai.feature.settings.data.repository

import com.djtech.monai.core.common.result.map
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.upload.filePart
import com.djtech.monai.feature.settings.data.dto.AdminPaymentProviderDto
import com.djtech.monai.feature.settings.data.dto.ProviderStatusRequestDto
import com.djtech.monai.feature.settings.data.mapper.asModel
import com.djtech.monai.feature.settings.data.mapper.toAdminProviderError
import com.djtech.monai.feature.settings.data.mapper.toCreateRequest
import com.djtech.monai.feature.settings.data.mapper.toUpdateRequest
import com.djtech.monai.feature.settings.data.remote.AdminProviderApiService
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.model.ProviderChanges
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AdminProviderRepositoryImpl @Inject constructor(
    private val adminProviderApiService: AdminProviderApiService,
    private val apiCaller: ApiCaller,
) : AdminProviderRepository {

    override suspend fun listProviders(): AdminProviderResult<List<AdminPaymentProvider>> = apiCaller.callRaw {
        // The catalog is small, so every page is read at once; MAX_PAGES guards against a runaway loop.
        val providers = mutableListOf<AdminPaymentProvider>()
        var page = 1
        do {
            val response = adminProviderApiService.listProviders(page, PAGE_SIZE)
            providers += response.data.map(AdminPaymentProviderDto::asModel)
            page++
        } while (page <= response.meta.totalPages && page <= MAX_PAGES)
        providers.sortedWith(compareBy(AdminPaymentProvider::sortOrder, AdminPaymentProvider::name))
    }.mapError(ApiError::toAdminProviderError)

    override suspend fun getProvider(id: String): AdminProviderResult<AdminPaymentProvider> =
        provider { adminProviderApiService.getProvider(id).data }

    override suspend fun createProvider(input: ProviderInput): AdminProviderResult<AdminPaymentProvider> =
        provider { adminProviderApiService.createProvider(input.toCreateRequest()).data }

    override suspend fun updateProvider(
        id: String,
        changes: ProviderChanges,
    ): AdminProviderResult<AdminPaymentProvider> =
        provider { adminProviderApiService.updateProvider(id, changes.toUpdateRequest()).data }

    override suspend fun setActive(id: String, active: Boolean): AdminProviderResult<AdminPaymentProvider> =
        provider { adminProviderApiService.setStatus(id, ProviderStatusRequestDto(active)).data }

    override suspend fun deleteProvider(id: String): AdminProviderResult<Unit> =
        apiCaller.callRaw { adminProviderApiService.deleteProvider(id) }
            .map { }
            .mapError(ApiError::toAdminProviderError)

    override suspend fun uploadLogo(id: String, image: EncodedImage): AdminProviderResult<AdminPaymentProvider> =
        provider { adminProviderApiService.setLogo(id, filePart(image.bytes, image.mimeType)).data }

    // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
    private suspend fun provider(
        request: suspend () -> AdminPaymentProviderDto,
    ): AdminProviderResult<AdminPaymentProvider> =
        apiCaller.callRaw { request().asModel() }.mapError(ApiError::toAdminProviderError)

    private companion object {
        const val PAGE_SIZE = 100
        const val MAX_PAGES = 20
    }
}
