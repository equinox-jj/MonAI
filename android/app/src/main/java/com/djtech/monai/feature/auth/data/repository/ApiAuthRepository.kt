package com.djtech.monai.feature.auth.data.repository

import com.djtech.monai.core.database.LocalCache
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiResult
import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.asModel
import com.djtech.monai.feature.auth.data.dto.AuthDataDto
import com.djtech.monai.feature.auth.data.dto.ChangePasswordRequestDto
import com.djtech.monai.feature.auth.data.dto.LoginRequestDto
import com.djtech.monai.feature.auth.data.dto.RegisterRequestDto
import com.djtech.monai.feature.auth.data.mapper.toAuthError
import com.djtech.monai.feature.auth.data.remote.AuthApiService
import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ApiAuthRepository @Inject constructor(
    private val authApiService: AuthApiService,
    private val apiCaller: ApiCaller,
    private val sessionStore: SessionStore,
    private val localCache: LocalCache,
) : AuthRepository {

    // Passwords are sent as typed: spaces may be part of them.
    override suspend fun register(name: String, email: String, password: String): AuthResult<User> =
        signIn {
            authApiService.register(
                RegisterRequestDto(
                    name.trim(),
                    email.normalizedEmail(),
                    password
                )
            )
        }

    override suspend fun login(email: String, password: String): AuthResult<User> =
        signIn { authApiService.login(LoginRequestDto(email.normalizedEmail(), password)) }

    override suspend fun logout() {
        sessionStore.clear()
        localCache.clear()
    }

    override suspend fun logoutAllDevices(): AuthResult<Unit> =
        when (val result = apiCaller.callRaw { authApiService.logoutAll() }) {
            // The server revoked this device's token too.
            is ApiResult.Success -> AuthResult.Success(logout())
            is ApiResult.Failure -> AuthResult.Failure(result.error.toAuthError())
        }

    override suspend fun changePassword(
        currentPassword: String,
        newPassword: String
    ): AuthResult<Unit> {
        val body = ChangePasswordRequestDto(currentPassword, newPassword)
        return when (val result = apiCaller.call { authApiService.changePassword(body) }) {
            // Older tokens are revoked; requests still carrying one 401 harmlessly,
            // since SessionStore.clearIfCurrent keeps this newer token.
            is ApiResult.Success -> AuthResult.Success(sessionStore.saveToken(result.data.accessToken))
            is ApiResult.Failure -> AuthResult.Failure(result.error.toAuthError())
        }
    }

    private suspend fun signIn(request: suspend () -> ApiResponse<AuthDataDto>): AuthResult<User> =
        when (val result = apiCaller.call(request)) {
            is ApiResult.Success -> {
                // Drop anything cached for a previous account before the new session starts.
                localCache.clear()
                sessionStore.saveToken(result.data.accessToken)
                AuthResult.Success(result.data.user.asModel())
            }

            is ApiResult.Failure -> AuthResult.Failure(result.error.toAuthError())
        }

    private fun String.normalizedEmail(): String = trim().lowercase()
}
