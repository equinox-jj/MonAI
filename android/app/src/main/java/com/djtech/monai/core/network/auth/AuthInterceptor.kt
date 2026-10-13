package com.djtech.monai.core.network.auth

import okhttp3.Interceptor
import okhttp3.Response
import javax.inject.Inject

/**
 * Gives OkHttp the current access token. OkHttp calls this on its own
 * threads, so implementations should serve it from memory, not block on disk.
 */
fun interface AccessTokenProvider {
    fun accessToken(): String?
}

/** Adds `Authorization: Bearer <token>` when a token is stored. */
class AuthInterceptor @Inject constructor(
    private val tokenProvider: AccessTokenProvider,
) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        val token = tokenProvider.accessToken()
        if (token.isNullOrBlank() || request.header(AUTHORIZATION) != null) {
            return chain.proceed(request)
        }

        return chain.proceed(
            request.newBuilder()
                .header(AUTHORIZATION, "$BEARER_PREFIX$token")
                .build(),
        )
    }

    internal companion object {
        const val AUTHORIZATION = "Authorization"
        const val BEARER_PREFIX = "Bearer "
    }
}
