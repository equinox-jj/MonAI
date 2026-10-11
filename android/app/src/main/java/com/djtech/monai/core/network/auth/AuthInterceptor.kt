package com.djtech.monai.core.network.auth

import okhttp3.Interceptor
import okhttp3.Response
import javax.inject.Inject

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
                .header(AUTHORIZATION, "Bearer $token")
                .build(),
        )
    }

    internal companion object {
        const val AUTHORIZATION = "Authorization"
    }
}
