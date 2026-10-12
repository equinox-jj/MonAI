package com.djtech.monai.feature.auth.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.EmptyResponse
import com.djtech.monai.feature.auth.data.dto.AuthDataDto
import com.djtech.monai.feature.auth.data.dto.ChangePasswordRequestDto
import com.djtech.monai.feature.auth.data.dto.LoginRequestDto
import com.djtech.monai.feature.auth.data.dto.RegisterRequestDto
import retrofit2.http.Body
import retrofit2.http.POST
import retrofit2.http.PUT

interface AuthApiService {

    @POST("auth/register")
    suspend fun register(@Body body: RegisterRequestDto): ApiResponse<AuthDataDto>

    @POST("auth/login")
    suspend fun login(@Body body: LoginRequestDto): ApiResponse<AuthDataDto>

    @POST("auth/logout-all")
    suspend fun logoutAll(): EmptyResponse

    @PUT("auth/password")
    suspend fun changePassword(@Body body: ChangePasswordRequestDto): ApiResponse<AuthDataDto>
}
