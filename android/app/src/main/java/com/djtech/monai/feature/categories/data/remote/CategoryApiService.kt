package com.djtech.monai.feature.categories.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.EmptyResponse
import com.djtech.monai.feature.categories.data.dto.CategoryDto
import com.djtech.monai.feature.categories.data.dto.CreateCategoryRequestDto
import com.djtech.monai.feature.categories.data.dto.UpdateCategoryRequestDto
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.PATCH
import retrofit2.http.POST
import retrofit2.http.Path
import retrofit2.http.Query

interface CategoryApiService {

    @GET("categories")
    suspend fun getCategories(@Query("include_hidden") includeHidden: Boolean): ApiResponse<List<CategoryDto>>

    /** 409 `conflict` when the user already has a category with this name. */
    @POST("categories")
    suspend fun createCategory(@Body body: CreateCategoryRequestDto): ApiResponse<CategoryDto>

    @PATCH("categories/{id}")
    suspend fun updateCategory(@Path("id") id: String, @Body body: UpdateCategoryRequestDto): ApiResponse<CategoryDto>

    /** [moveTo] is required when the category has transactions (422 `category_has_transactions`). */
    @DELETE("categories/{id}")
    suspend fun deleteCategory(@Path("id") id: String, @Query("move_to") moveTo: String?): EmptyResponse
}
