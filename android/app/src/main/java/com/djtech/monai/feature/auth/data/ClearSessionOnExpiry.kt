package com.djtech.monai.feature.auth.data

import com.djtech.monai.core.common.dispatcher.ApplicationScope
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.network.auth.SessionExpiredHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Signs the user out when the server rejects their token. Navigation follows
 * [SessionStore.sessionState] back to Login. Clearing the local cache joins
 * this once the database exists.
 */
class ClearSessionOnExpiry @Inject constructor(
    private val sessionStore: SessionStore,
    @ApplicationScope private val scope: CoroutineScope,
) : SessionExpiredHandler {

    // Called on an OkHttp thread; the clear runs async so the call can return.
    override fun onSessionExpired(rejectedToken: String) {
        scope.launch { sessionStore.clearIfCurrent(rejectedToken) }
    }
}
