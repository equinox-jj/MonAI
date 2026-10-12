package com.djtech.monai.feature.profile.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.UserDto
import retrofit2.http.GET

interface ProfileApiService {

    @GET("me")
    suspend fun getMe(): ApiResponse<UserDto>
}
