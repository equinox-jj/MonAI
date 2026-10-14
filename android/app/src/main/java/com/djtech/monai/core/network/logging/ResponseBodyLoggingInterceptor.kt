package com.djtech.monai.core.network.logging

import okhttp3.Interceptor
import okhttp3.MediaType
import okhttp3.Response
import okhttp3.logging.HttpLoggingInterceptor

/**
 * Logs each response's status, URL and body. Only response bodies: request
 * bodies carry passwords. Debug builds only (wired in `NetworkModule`).
 */
class ResponseBodyLoggingInterceptor(
    private val logger: HttpLoggingInterceptor.Logger = HttpLoggingInterceptor.Logger.DEFAULT,
) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        val response = chain.proceed(request)
        val head = "<-- ${response.code} ${request.method} ${request.url}"

        // peekBody copies the bytes, so the caller can still read the body.
        val body = response.peekBody(MAX_LOGGED_BYTES)
        if (body.contentType().isText()) {
            logger.log("$head\n${body.string()}")
        } else {
            logger.log("$head (binary ${body.contentLength()}-byte body omitted)")
        }
        return response
    }

    private fun MediaType?.isText(): Boolean =
        this == null || type == "text" || subtype == "json" || subtype.endsWith("+json")

    private companion object {
        const val MAX_LOGGED_BYTES = 256L * 1024
    }
}
