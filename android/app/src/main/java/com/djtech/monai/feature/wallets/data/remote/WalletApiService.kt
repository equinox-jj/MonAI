package com.djtech.monai.feature.wallets.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.EmptyResponse
import com.djtech.monai.feature.wallets.data.dto.CreateWalletRequestDto
import com.djtech.monai.feature.wallets.data.dto.UpdateWalletRequestDto
import com.djtech.monai.feature.wallets.data.dto.WalletDto
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.PATCH
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query

interface WalletApiService {

    // `meta.total_balance` is ignored: the app sums the cached wallets instead.
    @GET("wallets")
    suspend fun getWallets(@Query("include_archived") includeArchived: Boolean): ApiResponse<List<WalletDto>>

    @GET("wallets/{id}")
    suspend fun getWallet(@Path("id") id: String): ApiResponse<WalletDto>

    @POST("wallets")
    suspend fun createWallet(@Body request: CreateWalletRequestDto): ApiResponse<WalletDto>

    @PATCH("wallets/{id}")
    suspend fun updateWallet(
        @Path("id") id: String,
        @Body request: UpdateWalletRequestDto,
    ): ApiResponse<WalletDto>

    @DELETE("wallets/{id}")
    suspend fun deleteWallet(@Path("id") id: String): EmptyResponse
}
