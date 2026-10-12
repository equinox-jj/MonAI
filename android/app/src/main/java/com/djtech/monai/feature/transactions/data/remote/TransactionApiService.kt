package com.djtech.monai.feature.transactions.data.remote

import com.djtech.monai.core.network.model.CursorResponse
import com.djtech.monai.feature.transactions.data.dto.TransactionDto
import retrofit2.http.GET
import retrofit2.http.Query

interface TransactionApiService {

    /** [month] is `YYYY-MM`; the API lists one month at a time, newest first. */
    @GET("transactions")
    suspend fun getTransactions(
        @Query("month") month: String,
        @Query("limit") limit: Int,
    ): CursorResponse<TransactionDto>
}
