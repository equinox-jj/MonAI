package com.djtech.monai.feature.auth.domain.repository

import com.djtech.monai.core.model.User
import com.djtech.monai.feature.auth.domain.model.AuthResult

/**
 * Signs the user in and out. A successful register, login or password change stores
 * the new token, and navigation follows the session state from there. Failures come back as
 * [com.djtech.monai.core.common.result.Outcome.Failure]; nothing here throws except cancellation.
 * Input is sent as given: the use cases have already cleaned it up.
 */
interface AuthRepository {
    suspend fun register(name: String, email: String, password: String): AuthResult<User>

    suspend fun login(email: String, password: String): AuthResult<User>

    /**
     * Signs out of this device only; the token stays valid on the server until it expires. Fails only
     * when the token could not be removed, and the user is then still signed in.
     */
    suspend fun logout(): AuthResult<Unit>

    /** Revokes every token of the user, this device's included, then signs out here. */
    suspend fun logoutAllDevices(): AuthResult<Unit>

    /**
     * Expires the session now if its token is past the expiry the server gave, the same way a
     * rejected token does: the session-expired notice, then the cache. Never throws.
     */
    suspend fun expireSessionIfDue()

    /** Other devices are signed out; this one keeps going with the returned token. */
    suspend fun changePassword(currentPassword: String, newPassword: String): AuthResult<Unit>
}
