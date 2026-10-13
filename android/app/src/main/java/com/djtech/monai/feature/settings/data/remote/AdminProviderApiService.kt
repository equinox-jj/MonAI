package com.djtech.monai.feature.settings.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.EmptyResponse
import com.djtech.monai.core.network.model.PagedResponse
import com.djtech.monai.feature.settings.data.dto.AdminPaymentProviderDto
import com.djtech.monai.feature.settings.data.dto.CreateProviderRequestDto
import com.djtech.monai.feature.settings.data.dto.ProviderStatusRequestDto
import com.djtech.monai.feature.settings.data.dto.UpdateProviderRequestDto
import okhttp3.MultipartBody
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.Multipart
import retrofit2.http.PATCH
import retrofit2.http.POST
import retrofit2.http.PUT
import retrofit2.http.Part
import retrofit2.http.Path
import retrofit2.http.Query

/** Every call needs a `payment_provider.*` permission; without it the API answers 403. */
interface AdminProviderApiService {

    /** Every status; [perPage] is at most 100. */
    @GET("admin/payment-providers")
    suspend fun listProviders(
        @Query("page") page: Int,
        @Query("per_page") perPage: Int,
        @Query("status") status: String = "ALL",
    ): PagedResponse<AdminPaymentProviderDto>

    @GET("admin/payment-providers/{id}")
    suspend fun getProvider(@Path("id") id: String): ApiResponse<AdminPaymentProviderDto>

    @POST("admin/payment-providers")
    suspend fun createProvider(@Body body: CreateProviderRequestDto): ApiResponse<AdminPaymentProviderDto>

    @PATCH("admin/payment-providers/{id}")
    suspend fun updateProvider(
        @Path("id") id: String,
        @Body body: UpdateProviderRequestDto,
    ): ApiResponse<AdminPaymentProviderDto>

    @PATCH("admin/payment-providers/{id}/status")
    suspend fun setStatus(
        @Path("id") id: String,
        @Body body: ProviderStatusRequestDto,
    ): ApiResponse<AdminPaymentProviderDto>

    @DELETE("admin/payment-providers/{id}")
    suspend fun deleteProvider(@Path("id") id: String): EmptyResponse

    @Multipart
    @PUT("admin/payment-providers/{id}/logo")
    suspend fun setLogo(
        @Path("id") id: String,
        @Part file: MultipartBody.Part,
    ): ApiResponse<AdminPaymentProviderDto>
}
