package com.djtech.monai.feature.budgets.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.EmptyResponse
import com.djtech.monai.feature.budgets.data.dto.BudgetDto
import com.djtech.monai.feature.budgets.data.dto.SetBudgetRequestDto
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
