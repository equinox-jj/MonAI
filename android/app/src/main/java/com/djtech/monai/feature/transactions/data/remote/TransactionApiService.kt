package com.djtech.monai.feature.transactions.data.remote

import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.CursorResponse
import com.djtech.monai.core.network.model.EmptyResponse
import com.djtech.monai.feature.transactions.data.dto.CreateTransactionRequestDto
import com.djtech.monai.feature.transactions.data.dto.TransactionDto
import okhttp3.RequestBody
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.PATCH
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query

interface TransactionApiService {

    /**
     * [month] is `YYYY-MM`; the API lists one month at a time, newest first. Null filters are
     * left out of the query. Send the same filters with the [cursor] from the previous page.
     */
    @GET("transactions")
    suspend fun getTransactions(
        @Query("month") month: String,
        @Query("limit") limit: Int,
        @Query("wallet_id") walletId: String? = null,
        @Query("category_id") categoryId: String? = null,
        @Query("type") type: TransactionType? = null,
        @Query("q") query: String? = null,
        @Query("cursor") cursor: String? = null,
    ): CursorResponse<TransactionDto>

    @GET("transactions/{id}")
    suspend fun getTransaction(@Path("id") id: String): ApiResponse<TransactionDto>

    @POST("transactions")
    suspend fun createTransaction(@Body request: CreateTransactionRequestDto): ApiResponse<TransactionDto>

    /** [body] is an encoded UpdateTransactionRequestDto; see `UpdateTransactionRequestDto.toRequestBody()`. */
    @PATCH("transactions/{id}")
    suspend fun updateTransaction(
        @Path("id") id: String,
        @Body body: RequestBody,
    ): ApiResponse<TransactionDto>

    @DELETE("transactions/{id}")
    suspend fun deleteTransaction(@Path("id") id: String): EmptyResponse

    @POST("transactions/{id}/restore")
    suspend fun restoreTransaction(@Path("id") id: String): ApiResponse<TransactionDto>
}
