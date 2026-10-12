package com.djtech.monai.feature.auth.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.map
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.common.time.AppClock
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
import java.time.Instant
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.cancellation.CancellationException

@Singleton
class ApiAuthRepository @Inject constructor(
    private val authApiService: AuthApiService,
    private val apiCaller: ApiCaller,
    private val sessionStore: SessionStore,
    private val localCache: LocalCache,
    private val errorLogger: ErrorLogger,
    private val clock: AppClock,
) : AuthRepository {

    override suspend fun register(name: String, email: String, password: String): AuthResult<User> =
        signIn { authApiService.register(RegisterRequestDto(name, email, password)) }

    override suspend fun login(email: String, password: String): AuthResult<User> =
        signIn { authApiService.login(LoginRequestDto(email, password)) }

    override suspend fun logout(): AuthResult<Unit> = storingSession {
        sessionStore.clear()
        clearCacheAfterSignOut()
        Outcome.Success(Unit)
    }

    override suspend fun logoutAllDevices(): AuthResult<Unit> =
        when (val result = apiCaller.callRaw { authApiService.logoutAll() }) {
            // The server revoked this device's token too.
            is Outcome.Success -> logout()
            is Outcome.Failure -> Outcome.Failure(result.error.toAuthError())
        }

    override suspend fun expireSessionIfDue() {
        try {
            val token = sessionStore.overdueToken(clock.now()) ?: return
            // As if the server had rejected it: a newer login is kept, and the cache goes with the session.
            if (sessionStore.clearIfCurrent(token)) clearCacheAfterSignOut()
        } catch (e: CancellationException) {
            throw e
        } catch (e: Exception) {
            // The server will reject the token on the next request, which expires the session anyway.
            errorLogger.log("Expiring the overdue session failed", e)
        }
    }

    override suspend fun changePassword(currentPassword: String, newPassword: String): AuthResult<Unit> {
        val body = ChangePasswordRequestDto(currentPassword, newPassword)
        return storingSession {
            // Older tokens are revoked; requests still carrying one 401 harmlessly,
            // since SessionStore.clearIfCurrent keeps this newer token.
            apiCaller.call { authApiService.changePassword(body) }
                .map { sessionStore.saveToken(it.accessToken, it.expiresAt()) }
                .mapError(ApiError::toAuthError)
        }
    }

    private suspend fun signIn(request: suspend () -> ApiResponse<AuthDataDto>): AuthResult<User> =
        storingSession {
            apiCaller.call(request).map { data ->
                // Map first: a payload that fails to parse must not leave a half-started session.
                val user = data.user.asModel()
                // Drop anything cached for a previous account before the new session starts.
                localCache.clear()
                sessionStore.saveToken(data.accessToken, data.expiresAt())
                user
            }.mapError(ApiError::toAuthError)
        }

    private fun AuthDataDto.expiresAt(): Instant = clock.now().plusSeconds(expiresIn)

    /**
     * ApiCaller already turns network failures into results; this does the same for failures
     * after the server answered (Keystore, disk, an unparseable payload), so callers never get
     * an exception.
     */
    private inline fun <T> storingSession(block: () -> AuthResult<T>): AuthResult<T> = try {
        block()
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Storing the session failed", e)
        Outcome.Failure(AuthError.Unexpected)
    }

    // Once the token is gone the user is signed out, so a cache that fails to clear doesn't fail the
    // logout: the next sign-in clears it before its session starts.
    private suspend fun clearCacheAfterSignOut() {
        try {
            localCache.clear()
        } catch (e: CancellationException) {
            throw e
        } catch (e: Exception) {
            // Left for the next sign-in.
            errorLogger.log("Clearing the cache on logout failed", e)
        }
    }
}
