package com.djtech.monai.feature.settings.domain.repository

import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.model.ProviderChanges
import com.djtech.monai.feature.settings.domain.model.ProviderInput

/**
 * The provider catalog's admin endpoints. Network only: admins edit rarely and must see the
 * server's current list. Users get the changes through the catalog's ETag on their next refresh.
 */
interface AdminProviderRepository {

    /** Every provider, inactive ones included, by sort order then name. */
    suspend fun listProviders(): AdminProviderResult<List<AdminPaymentProvider>>

    suspend fun getProvider(id: String): AdminProviderResult<AdminPaymentProvider>

    /** Created active; the slug is made from the name by the server. */
    suspend fun createProvider(input: ProviderInput): AdminProviderResult<AdminPaymentProvider>

    suspend fun updateProvider(id: String, changes: ProviderChanges): AdminProviderResult<AdminPaymentProvider>

    suspend fun setActive(id: String, active: Boolean): AdminProviderResult<AdminPaymentProvider>

    suspend fun deleteProvider(id: String): AdminProviderResult<Unit>

    suspend fun uploadLogo(id: String, image: EncodedImage): AdminProviderResult<AdminPaymentProvider>
}
