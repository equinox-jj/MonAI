package com.djtech.monai.core.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import com.djtech.monai.core.common.dispatcher.ApplicationScope
import com.djtech.monai.core.common.dispatcher.Dispatcher
import com.djtech.monai.core.common.dispatcher.MonAIDispatcher
import com.djtech.monai.core.network.auth.AccessTokenProvider
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.withContext
import javax.inject.Inject
import javax.inject.Singleton

sealed interface SessionState {
    /** The token has not been read from disk yet. */
    data object Loading : SessionState
    data object SignedIn : SessionState
    data object SignedOut : SessionState

    /** The server rejected the token; signed out, but the UI tells the user before leaving. */
    data object Expired : SessionState
}

/**
 * Holds the access token: encrypted on disk, plain in memory so OkHttp threads
 * can read it without I/O. Disk is read once; after that every write updates
 * memory itself, so a request sent right after [saveToken] already carries it.
 */
@Singleton
class SessionStore @Inject constructor(
    @SessionPreferences private val dataStore: DataStore<Preferences>,
    private val cipher: TokenCipher,
    @ApplicationScope scope: CoroutineScope,
    @Dispatcher(MonAIDispatcher.IO) private val ioDispatcher: CoroutineDispatcher,
) : AccessTokenProvider {
    private val cached = MutableStateFlow<CachedToken>(CachedToken.Unloaded)
    private val writeLock = Mutex()

    val sessionState: Flow<SessionState> = cached
        .map { cache ->
            when (cache) {
                CachedToken.Unloaded -> SessionState.Loading
                is CachedToken.Loaded -> when {
                    cache.token != null -> SessionState.SignedIn
                    cache.expired -> SessionState.Expired
                    else -> SessionState.SignedOut
                }
            }
        }
        .distinctUntilChanged()

    init {
        scope.launch(ioDispatcher) { loadIfNeeded() }
    }

    override fun accessToken(): String? = when (val cache = cached.value) {
        is CachedToken.Loaded -> cache.token
        // Only before the startup load finishes. OkHttp calls this on its own
        // threads, so blocking on the one disk read is acceptable.
        CachedToken.Unloaded -> runBlocking { loadIfNeeded() }
    }

    suspend fun saveToken(token: String) = writeLock.withLock {
        val encrypted = withContext(ioDispatcher) { cipher.encrypt(token) }
        dataStore.edit { it[ACCESS_TOKEN] = encrypted }
        cached.value = CachedToken.Loaded(token)
    }

    suspend fun clear() = writeLock.withLock { removeToken() }

    /**
     * Clears [token] only if it is still the stored one; a newer login wins. Only called when the
     * server rejects the token, so the session becomes [SessionState.Expired] until
     * [acknowledgeExpiry]. Returns whether it was cleared.
     */
    suspend fun clearIfCurrent(token: String): Boolean = writeLock.withLock {
        val isCurrent = loadIfNeeded() == token
        if (isCurrent) removeToken(expired = true)
        isCurrent
    }

    /** The user saw the expiry notice; [SessionState.Expired] becomes [SessionState.SignedOut]. */
    suspend fun acknowledgeExpiry() = writeLock.withLock {
        val cache = cached.value
        if (cache is CachedToken.Loaded && cache.expired) cached.value = cache.copy(expired = false)
    }

    // The flag lives in memory only: after process death an expired session is plainly signed out.
    private suspend fun removeToken(expired: Boolean = false) {
        dataStore.edit { it.remove(ACCESS_TOKEN) }
        cached.value = CachedToken.Loaded(null, expired)
    }

    private suspend fun loadIfNeeded(): String? {
        (cached.value as? CachedToken.Loaded)?.let { return it.token }
        // An undecryptable token (e.g. restored without its Keystore key) means signed out.
        val token = dataStore.data.first()[ACCESS_TOKEN]?.let(cipher::decrypt)
        // A write that landed during the read is newer; keep it.
        cached.compareAndSet(CachedToken.Unloaded, CachedToken.Loaded(token))
        return (cached.value as CachedToken.Loaded).token
    }

    private sealed interface CachedToken {
        data object Unloaded : CachedToken
        data class Loaded(val token: String?, val expired: Boolean = false) : CachedToken
    }

    internal companion object {
        val ACCESS_TOKEN = stringPreferencesKey("access_token")
    }
}
