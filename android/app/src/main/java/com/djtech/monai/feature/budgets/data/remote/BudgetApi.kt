package com.djtech.monai.feature.budgets.data.remote

import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.EmptyResponse
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.PUT
import retrofit2.http.Path

interface BudgetApiService {

    /** [month] is `YYYY-MM`; 404 `not_found` when the month has no budget. */
    @GET("budgets/{month}")
    suspend fun getBudget(@Path("month") month: String): ApiResponse<BudgetDto>

    /** Sets or changes [month]'s limit; answers with the budget and its progress. */
    @PUT("budgets/{month}")
    suspend fun setBudget(@Path("month") month: String, @Body body: SetBudgetRequestDto): ApiResponse<BudgetDto>

    /** 404 `not_found` when the month has no budget. */
    @DELETE("budgets/{month}")
    suspend fun deleteBudget(@Path("month") month: String): EmptyResponse
}

/** [month] is `YYYY-MM`. */
@Serializable
data class BudgetDto(
    @SerialName("month") val month: String,
    @SerialName("limit_amount") val limitAmount: Long,
    @SerialName("spent") val spent: Long,
    @SerialName("remaining") val remaining: Long,
    @SerialName("progress_percent") val progressPercent: Double,
    @SerialName("status") val status: BudgetStatus,
)

/** Body of `PUT /budgets/{month}`; [limitAmount] is rupiah. */
@Serializable
data class SetBudgetRequestDto(
    @SerialName("limit_amount") val limitAmount: Long,
)
