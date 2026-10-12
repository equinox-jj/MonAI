package com.djtech.monai.feature.categories.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.feature.categories.data.dto.CategoryDto
import retrofit2.http.GET
import retrofit2.http.Query

interface CategoryApiService {

    @GET("categories")
    suspend fun getCategories(@Query("include_hidden") includeHidden: Boolean): ApiResponse<List<CategoryDto>>
}
