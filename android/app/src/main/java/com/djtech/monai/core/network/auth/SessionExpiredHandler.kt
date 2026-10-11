package com.djtech.monai.core.network.auth

/**
 * Called when the server rejects a token. Implementations clear it (only if it
 * is still the stored one, since a new login may have replaced it while the
 * request was in flight) and the local cache, then send the user to Login.
 */
fun interface SessionExpiredHandler {
    fun onSessionExpired(rejectedToken: String)
}
