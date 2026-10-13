package com.djtech.monai.feature.profile.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.EmptyResponse
import com.djtech.monai.core.network.model.UserDto
import com.djtech.monai.feature.profile.data.dto.DeleteAccountRequestDto
import com.djtech.monai.feature.profile.data.dto.UpdateMeRequestDto
import okhttp3.MultipartBody
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.HTTP
import retrofit2.http.Multipart
import retrofit2.http.PATCH
import retrofit2.http.PUT
import retrofit2.http.Part

interface ProfileApiService {

    @GET("me")
    suspend fun getMe(): ApiResponse<UserDto>

    @PATCH("me")
    suspend fun updateMe(@Body body: UpdateMeRequestDto): ApiResponse<UserDto>

    @Multipart
    @PUT("me/avatar")
    suspend fun setAvatar(@Part file: MultipartBody.Part): ApiResponse<UserDto>

    @DELETE("me/avatar")
    suspend fun deleteAvatar(): EmptyResponse

    // @DELETE can't carry a body, and this one needs the password.
    @HTTP(method = "DELETE", path = "me", hasBody = true)
    suspend fun deleteMe(@Body body: DeleteAccountRequestDto): EmptyResponse
}
