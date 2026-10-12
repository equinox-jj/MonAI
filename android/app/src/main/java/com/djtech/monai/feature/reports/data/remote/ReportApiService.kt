package com.djtech.monai.feature.reports.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.feature.reports.data.dto.MonthlyReportDto
import retrofit2.http.GET
import retrofit2.http.Query

interface ReportApiService {

    /** [month] is `YYYY-MM`. */
    @GET("reports/monthly")
    suspend fun getMonthlyReport(@Query("month") month: String): ApiResponse<MonthlyReportDto>
}
