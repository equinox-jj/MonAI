package com.djtech.monai.feature.categories.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.feature.categories.data.dto.CategoryDto
import com.djtech.monai.feature.categories.data.dto.CreateCategoryRequestDto
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Query

interface CategoryApiService {

    @GET("categories")
    suspend fun getCategories(@Query("include_hidden") includeHidden: Boolean): ApiResponse<List<CategoryDto>>

    /** 409 `conflict` when the user already has a category with this name. */
    @POST("categories")
    suspend fun createCategory(@Body body: CreateCategoryRequestDto): ApiResponse<CategoryDto>
}
