package com.djtech.monai.core.network.auth

import okhttp3.Authenticator
import okhttp3.Request
import okhttp3.Response
import okhttp3.Route
import javax.inject.Inject

/**
 * Handles 401 responses. There is no refresh token yet, so a rejected token
 * ends the session and the request is not retried. Refresh logic goes here (P2).
 *
 * A 401 on a request sent without a token (e.g. login with a wrong password)
 * is a normal error, not an expired session.
 */
class SessionAuthenticator @Inject constructor(
    private val sessionExpiredHandler: SessionExpiredHandler,
) : Authenticator {

    override fun authenticate(route: Route?, response: Response): Request? {
        if (response.request.header(AuthInterceptor.AUTHORIZATION) != null) {
            sessionExpiredHandler.onSessionExpired()
        }
        return null
    }
}
