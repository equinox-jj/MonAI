package com.djtech.monai.feature.auth.data.session

import com.djtech.monai.core.common.coroutines.ApplicationScope
import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.log.runLogged
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
    private val errorLogger: ErrorLogger,
) : SessionExpiredHandler {

    // Called on an OkHttp thread; the clear runs async so the call can return.
    override fun onSessionExpired(rejectedToken: String) {
        scope.launch {
            // The app scope has no handler, so a disk error here would crash the app. Nothing is
            // lost: a token still stored 401s again and retries, and sign-in clears the cache first.
            errorLogger.runLogged("Clearing the expired session failed", Unit) {
                // A stale 401 after a newer login must not wipe the new session's cache.
                if (sessionStore.clearIfCurrent(rejectedToken)) localCache.clear()
            }
        }
    }
}
