package com.djtech.monai.core.network.auth

/**
 * Gives OkHttp the current access token. OkHttp calls this on its own
 * threads, so implementations should serve it from memory, not block on disk.
 */
fun interface AccessTokenProvider {
    fun accessToken(): String?
}
