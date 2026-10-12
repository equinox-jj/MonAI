package com.djtech.monai.feature.budgets.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.feature.budgets.data.dto.BudgetDto
import retrofit2.http.GET
import retrofit2.http.Path

interface BudgetApiService {

    /** [month] is `YYYY-MM`; 404 `not_found` when the month has no budget. */
    @GET("budgets/{month}")
    suspend fun getBudget(@Path("month") month: String): ApiResponse<BudgetDto>
}
