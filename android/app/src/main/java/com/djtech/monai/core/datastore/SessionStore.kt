package com.djtech.monai.core.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import com.djtech.monai.core.common.dispatcher.ApplicationScope
import com.djtech.monai.core.common.dispatcher.Dispatcher
import com.djtech.monai.core.common.dispatcher.MonAIDispatcher
import com.djtech.monai.core.common.log.ErrorLogger
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
import java.io.IOException
import java.time.Instant
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
    private val errorLogger: ErrorLogger,
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

    /** @param expiresAt when the server stops accepting [token]; null when it didn't say. */
    suspend fun saveToken(token: String, expiresAt: Instant? = null) = writeLock.withLock {
        val encrypted = withContext(ioDispatcher) { cipher.encrypt(token) }
        dataStore.edit {
            it[ACCESS_TOKEN] = encrypted
            if (expiresAt != null) it[EXPIRES_AT] = expiresAt.toEpochMilli() else it.remove(EXPIRES_AT)
        }
        cached.value = CachedToken.Loaded(token, expiresAt = expiresAt)
    }

    suspend fun clear() = writeLock.withLock { removeToken() }

    /** The stored token if its expiry is at or before [now], so it can be expired before a request 401s. */
    suspend fun overdueToken(now: Instant): String? {
        val session = load()
        val expiresAt = session.expiresAt ?: return null
        return session.token?.takeIf { !now.isBefore(expiresAt) }
    }

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
        dataStore.edit {
            it.remove(ACCESS_TOKEN)
            it.remove(EXPIRES_AT)
        }
        cached.value = CachedToken.Loaded(null, expired)
    }

    private suspend fun loadIfNeeded(): String? = load().token

    private suspend fun load(): CachedToken.Loaded {
        (cached.value as? CachedToken.Loaded)?.let { return it }
        // An unreadable file or an undecryptable token (e.g. restored without its Keystore key) means
        // signed out; a read error escaping here would crash startup or leave it Loading for good.
        val stored = try {
            dataStore.data.first()
        } catch (e: IOException) {
            errorLogger.log("Session file unreadable; starting signed out", e)
            null
        }
        val token = stored?.get(ACCESS_TOKEN)?.let(cipher::decrypt)
        val expiresAt = stored?.get(EXPIRES_AT)?.takeIf { token != null }?.let(Instant::ofEpochMilli)
        // A write that landed during the read is newer; keep it.
        cached.compareAndSet(CachedToken.Unloaded, CachedToken.Loaded(token, expiresAt = expiresAt))
        return cached.value as CachedToken.Loaded
    }

    private sealed interface CachedToken {
        data object Unloaded : CachedToken
        data class Loaded(
            val token: String?,
            val expired: Boolean = false,
            val expiresAt: Instant? = null,
        ) : CachedToken
    }

    internal companion object {
        val ACCESS_TOKEN = stringPreferencesKey("access_token")
        val EXPIRES_AT = longPreferencesKey("access_token_expires_at")
    }
}
