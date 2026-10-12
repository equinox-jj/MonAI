package com.djtech.monai.feature.auth.data.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.map
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.database.LocalCache
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.core.network.model.asModel
import com.djtech.monai.feature.auth.data.dto.AuthDataDto
import com.djtech.monai.feature.auth.data.dto.ChangePasswordRequestDto
import com.djtech.monai.feature.auth.data.dto.LoginRequestDto
import com.djtech.monai.feature.auth.data.dto.RegisterRequestDto
import com.djtech.monai.feature.auth.data.mapper.toAuthError
import com.djtech.monai.feature.auth.data.remote.AuthApiService
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.cancellation.CancellationException

@Singleton
class ApiAuthRepository @Inject constructor(
    private val authApiService: AuthApiService,
    private val apiCaller: ApiCaller,
    private val sessionStore: SessionStore,
    private val localCache: LocalCache,
) : AuthRepository {

    // Passwords are sent as typed: spaces may be part of them.
    override suspend fun register(name: String, email: String, password: String): AuthResult<User> =
        signIn { authApiService.register(RegisterRequestDto(name.trim(), email.normalizedEmail(), password)) }

    override suspend fun login(email: String, password: String): AuthResult<User> =
        signIn { authApiService.login(LoginRequestDto(email.normalizedEmail(), password)) }

    override suspend fun logout() {
        sessionStore.clear()
        localCache.clear()
    }

    override suspend fun logoutAllDevices(): AuthResult<Unit> = storingSession {
        // The server revoked this device's token too.
        apiCaller.callRaw { authApiService.logoutAll() }
            .map { logout() }
            .mapError(ApiError::toAuthError)
    }

    override suspend fun changePassword(currentPassword: String, newPassword: String): AuthResult<Unit> {
        val body = ChangePasswordRequestDto(currentPassword, newPassword)
        return storingSession {
            // Older tokens are revoked; requests still carrying one 401 harmlessly,
            // since SessionStore.clearIfCurrent keeps this newer token.
            apiCaller.call { authApiService.changePassword(body) }
                .map { sessionStore.saveToken(it.accessToken) }
                .mapError(ApiError::toAuthError)
        }
    }

    private suspend fun signIn(request: suspend () -> ApiResponse<AuthDataDto>): AuthResult<User> = storingSession {
        apiCaller.call(request).map { data ->
            // Map first: a payload that fails to parse must not leave a half-started session.
            val user = data.user.asModel()
            // Drop anything cached for a previous account before the new session starts.
            localCache.clear()
            sessionStore.saveToken(data.accessToken)
            user
        }.mapError(ApiError::toAuthError)
    }

    /**
     * ApiCaller already turns network failures into results; this does the same for failures
     * after the server answered (Keystore, disk, an unparseable payload), so callers never get
     * an exception.
     */
    private inline fun <T> storingSession(block: () -> AuthResult<T>): AuthResult<T> = try {
        block()
    } catch (e: CancellationException) {
        throw e
    } catch (_: Exception) {
        Outcome.Failure(AuthError.Unexpected)
    }

    private fun String.normalizedEmail(): String = trim().lowercase()
}
