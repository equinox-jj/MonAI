package com.djtech.monai.core.network.auth

/**
 * Called when the server rejects the stored token. Implementations clear the
 * token and the local cache, then send the user to Login.
 */
fun interface SessionExpiredHandler {
    fun onSessionExpired()
}
