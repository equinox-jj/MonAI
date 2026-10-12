package com.djtech.monai.feature.wallets.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.feature.wallets.data.dto.WalletDto
import retrofit2.http.GET
import retrofit2.http.Query

interface WalletApiService {

    // `meta.total_balance` is ignored: the app sums the cached wallets instead.
    @GET("wallets")
    suspend fun getWallets(@Query("include_archived") includeArchived: Boolean): ApiResponse<List<WalletDto>>
}
