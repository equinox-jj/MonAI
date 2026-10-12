package com.djtech.monai.feature.auth.data.session

import com.djtech.monai.core.common.dispatcher.ApplicationScope
import com.djtech.monai.core.database.LocalCache
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.network.auth.SessionExpiredHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Signs the user out and clears their cached data when the server rejects their
 * token. Navigation follows [SessionStore.sessionState] back to Login.
 */
class ClearSessionOnExpiry @Inject constructor(
    private val sessionStore: SessionStore,
    private val localCache: LocalCache,
    @ApplicationScope private val scope: CoroutineScope,
) : SessionExpiredHandler {

    // Called on an OkHttp thread; the clear runs async so the call can return.
    override fun onSessionExpired(rejectedToken: String) {
        scope.launch {
            // A stale 401 after a newer login must not wipe the new session's cache.
            if (sessionStore.clearIfCurrent(rejectedToken)) localCache.clear()
        }
    }
}
