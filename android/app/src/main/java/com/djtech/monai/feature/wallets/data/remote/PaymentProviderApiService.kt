package com.djtech.monai.feature.wallets.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.feature.wallets.data.dto.PaymentProviderCatalogDto
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Header

interface PaymentProviderApiService {

    /**
     * Public catalog. Send the cached [etag] to get `304 Not Modified` (no body) when nothing changed;
     * the [Response] wrapper is what lets the caller see the 304 and read the new `ETag` header.
     */
    @GET("payment-providers")
    suspend fun getCatalog(@Header("If-None-Match") etag: String?): Response<ApiResponse<PaymentProviderCatalogDto>>
}
