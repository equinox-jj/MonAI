package com.djtech.monai.feature.auth.data.repository

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.Preferences
import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.database.FakeLocalCache
import com.djtech.monai.core.datastore.FakeTokenCipher
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.datastore.TokenCipher
import com.djtech.monai.core.model.Role
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.auth.data.remote.AuthApiService
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.FieldIssue
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runTest
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonObject
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import mockwebserver3.RecordedRequest
import okhttp3.Headers
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.rules.TemporaryFolder
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.io.IOException
import java.time.Instant
import kotlin.time.Duration.Companion.seconds

class AuthRepositoryImplTest {

    private val errorLogger = RecordingErrorLogger()

    @get:Rule
    val tmp = TemporaryFolder()

    private val server = MockWebServer()
    private val dataStoreScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val localCache = FakeLocalCache()

    /** Once set, the session file refuses writes, so the token can be neither saved nor removed. */
    private var diskFull = false

    @Before
    fun setUp() {
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
        dataStoreScope.cancel()
    }

    @Test
    fun `login sends the credentials as given, saves the token and returns the user`() = runTest {
        val (repository, store) = repository()
        server.enqueue(MockResponse(code = 200, body = authBody(token = "token-1")))

        val result = repository.login("joshua@example.com", " s3cretPass ")

        assertEquals(Outcome.Success(expectedUser), result)
        assertEquals("token-1", store.accessToken())
        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals("/api/v1/auth/login", request.url.encodedPath)
        assertEquals(
            json("""{"email":"joshua@example.com","password":" s3cretPass "}"""),
            request.jsonBody(),
        )
    }

    @Test
    fun `login records when the token expires`() = runTest {
        val (repository, store) = repository()
        server.enqueue(MockResponse(code = 200, body = authBody(token = "token-1")))

        repository.login("joshua@example.com", "s3cretPass")

        assertNull(store.overdueToken(now = NOW.plusSeconds(TOKEN_LIFETIME_SECONDS - 1)))
        assertEquals("token-1", store.overdueToken(now = NOW.plusSeconds(TOKEN_LIFETIME_SECONDS)))
    }

    @Test
    fun `login with wrong credentials fails without saving a token`() = runTest {
        val (repository, store) = repository()
        server.enqueue(errorResponse(401, "invalid_credentials"))

        val result = repository.login("joshua@example.com", "wrongPass1")

        assertEquals(Outcome.Failure(AuthError.InvalidCredentials), result)
        assertNull(store.accessToken())
    }

    @Test
    fun `register sends the form and saves the token`() = runTest {
        val (repository, store) = repository()
        server.enqueue(MockResponse(code = 201, body = authBody(token = "token-new")))

        val result = repository.register("Joshua", "joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Success(expectedUser), result)
        assertEquals("token-new", store.accessToken())
        val request = server.takeRequest()
        assertEquals("/api/v1/auth/register", request.url.encodedPath)
        assertEquals(
            json("""{"name":"Joshua","email":"joshua@example.com","password":"s3cretPass"}"""),
            request.jsonBody(),
        )
    }

    @Test
    fun `register clears data left by a previous account`() = runTest {
        val (repository, _) = repository()
        server.enqueue(MockResponse(code = 201, body = authBody(token = "token-new")))

        repository.register("Joshua", "joshua@example.com", "s3cretPass")

        assertEquals(1, localCache.clearCount)
    }

    @Test
    fun `register with a taken email fails with EmailAlreadyRegistered`() = runTest {
        val (repository, _) = repository()
        server.enqueue(errorResponse(409, "conflict"))

        val result = repository.register("Joshua", "joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Failure(AuthError.EmailAlreadyRegistered), result)
    }

    @Test
    fun `validation errors are mapped to auth fields`() = runTest {
        val (repository, _) = repository()
        server.enqueue(
            errorResponse(
                422,
                "validation_failed",
                fields = """[
                    {"field":"password","code":"min_length","message":"too short","params":{"min":8}},
                    {"field":"email","code":"invalid_format","message":"bad email"},
                    {"field":"unknown_field","code":"required","message":"required"}
                ]""",
            ),
        )

        val result = repository.register("Joshua", "joshua", "short")

        assertEquals(
            Outcome.Failure(
                AuthError.InvalidFields(
                    listOf(
                        AuthFieldError(AuthField.PASSWORD, FieldIssue.TooShort(8)),
                        AuthFieldError(AuthField.EMAIL, FieldIssue.InvalidFormat),
                    ),
                ),
            ),
            result,
        )
    }

    @Test
    fun `field error codes are decoded with their params`() = runTest {
        val (repository, _) = repository()
        server.enqueue(
            errorResponse(
                422,
                "validation_failed",
                fields = """[
                    {"field":"current_password","code":"required","message":"required"},
                    {"field":"new_password","code":"not_equal","message":"same","params":{"other":"current_password"}},
                    {"field":"name","code":"max_length","message":"too long","params":{"max":100}},
                    {"field":"password","code":"min_length","message":"too short"},
                    {"field":"email","code":"some_new_code","message":"bad"}
                ]""",
            ),
        )

        val result = repository.changePassword("oldPass123", "oldPass123")

        assertEquals(
            Outcome.Failure(
                AuthError.InvalidFields(
                    listOf(
                        AuthFieldError(AuthField.CURRENT_PASSWORD, FieldIssue.Required),
                        AuthFieldError(AuthField.NEW_PASSWORD, FieldIssue.SameAsCurrent),
                        AuthFieldError(AuthField.NAME, FieldIssue.TooLong(100)),
                        // A length code without its limit, or an unknown code, still marks the field.
                        AuthFieldError(AuthField.PASSWORD, FieldIssue.Invalid),
                        AuthFieldError(AuthField.EMAIL, FieldIssue.Invalid),
                    ),
                ),
            ),
            result,
        )
    }

    @Test
    fun `validation errors without a known field are unexpected`() = runTest {
        val (repository, _) = repository()
        server.enqueue(errorResponse(422, "validation_failed"))

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Failure(AuthError.Unexpected), result)
    }

    @Test
    fun `rate limiting is reported with how long to wait`() = runTest {
        val (repository, _) = repository()
        server.enqueue(errorResponse(429, "rate_limited", headers = Headers.headersOf("Retry-After", "120")))

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Failure(AuthError.RateLimited(120.seconds)), result)
    }

    @Test
    fun `server errors are unexpected`() = runTest {
        val (repository, _) = repository()
        server.enqueue(errorResponse(500, "internal_error"))

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Failure(AuthError.Unexpected), result)
    }

    @Test
    fun `an unreachable server is a network error`() = runTest {
        val (repository, _) = repository()
        server.close()

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Failure(AuthError.Network), result)
    }

    @Test
    fun `a token that cannot be stored fails instead of throwing`() = runTest {
        val (repository, store) = repository(cipher = FailingCipher)
        server.enqueue(MockResponse(code = 200, body = authBody(token = "token-1")))

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Failure(AuthError.Unexpected), result)
        assertNull(store.accessToken())
        assertEquals(listOf("Keystore unavailable"), errorLogger.errors.map { it.message })
    }

    @Test
    fun `a malformed user fails without signing in`() = runTest {
        val (repository, store) = repository()
        val body = authBody(token = "token-1").replace("2026-10-08T12:30:00Z", "yesterday")
        server.enqueue(MockResponse(code = 200, body = body))

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(Outcome.Failure(AuthError.Unexpected), result)
        assertNull(store.accessToken())
        assertEquals(0, localCache.clearCount)
        assertEquals(1, errorLogger.errors.size)
    }

    @Test
    fun `logout clears the token and the cache`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")

        val result = repository.logout()

        assertEquals(Outcome.Success(Unit), result)
        assertNull(store.accessToken())
        assertEquals(1, localCache.clearCount)
        assertEquals(0, server.requestCount)
    }

    @Test
    fun `a token that cannot be removed fails logout and keeps the session`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")
        diskFull = true

        val result = repository.logout()

        assertEquals(Outcome.Failure(AuthError.Unexpected), result)
        assertEquals("token-1", store.accessToken())
        assertEquals(listOf("disk full"), errorLogger.errors.map { it.message })
    }

    @Test
    fun `a cache that cannot be cleared still signs out`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")
        val failure = IOException("disk full")
        localCache.failure = failure

        val result = repository.logout()

        assertEquals(Outcome.Success(Unit), result)
        assertNull(store.accessToken())
        assertEquals(listOf(failure), errorLogger.errors)
    }

    @Test
    fun `logout on all devices clears the session once the server revoked the tokens`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")
        server.enqueue(MockResponse(code = 200, body = """{"success":true,"message":"Logged out","data":null}"""))

        val result = repository.logoutAllDevices()

        assertEquals(Outcome.Success(Unit), result)
        assertNull(store.accessToken())
        assertEquals(1, localCache.clearCount)
        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals("/api/v1/auth/logout-all", request.url.encodedPath)
    }

    @Test
    fun `a cache that cannot be cleared does not fail logout on all devices`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")
        localCache.failure = IOException("disk full")
        server.enqueue(MockResponse(code = 200, body = """{"success":true,"message":"Logged out","data":null}"""))

        val result = repository.logoutAllDevices()

        assertEquals(Outcome.Success(Unit), result)
        assertNull(store.accessToken())
    }

    @Test
    fun `logout on all devices fails when this device's token cannot be removed`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")
        diskFull = true
        server.enqueue(MockResponse(code = 200, body = """{"success":true,"message":"Logged out","data":null}"""))

        val result = repository.logoutAllDevices()

        assertEquals(Outcome.Failure(AuthError.Unexpected), result)
        assertEquals("token-1", store.accessToken())
    }

    @Test
    fun `a failed logout on all devices keeps the session`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")
        server.enqueue(errorResponse(500, "internal_error"))

        val result = repository.logoutAllDevices()

        assertEquals(Outcome.Failure(AuthError.Unexpected), result)
        assertEquals("token-1", store.accessToken())
        assertEquals(0, localCache.clearCount)
    }

    @Test
    fun `changing the password signs out here too and clears the cache`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-old")
        server.enqueue(MockResponse(code = 200, body = authBody(token = "token-new")))

        val result = repository.changePassword("oldPass123", "newPass123")

        assertEquals(Outcome.Success(Unit), result)
        assertNull(store.accessToken())
        assertEquals(SessionState.PasswordChanged, store.sessionState.first())
        assertEquals(1, localCache.clearCount)
        val request = server.takeRequest()
        assertEquals("PUT", request.method)
        assertEquals("/api/v1/auth/password", request.url.encodedPath)
        assertEquals(
            json("""{"current_password":"oldPass123","new_password":"newPass123"}"""),
            request.jsonBody(),
        )
    }

    @Test
    fun `an overdue session is expired and its cache cleared`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1", expiresAt = NOW)

        repository.expireSessionIfDue()

        assertNull(store.accessToken())
        assertEquals(SessionState.Expired, store.sessionState.first())
        assertEquals(1, localCache.clearCount)
    }

    @Test
    fun `a session still in date is left alone`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1", expiresAt = NOW.plusSeconds(1))

        repository.expireSessionIfDue()

        assertEquals("token-1", store.accessToken())
        assertEquals(0, localCache.clearCount)
    }

    @Test
    fun `an overdue session that cannot be cleared is logged, not thrown`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1", expiresAt = NOW)
        diskFull = true

        repository.expireSessionIfDue()

        assertEquals(listOf("disk full"), errorLogger.errors.map { it.message })
    }

    @Test
    fun `a wrong current password keeps the old token`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-old")
        server.enqueue(errorResponse(422, "invalid_password"))

        val result = repository.changePassword("wrongPass1", "newPass123")

        assertEquals(Outcome.Failure(AuthError.WrongCurrentPassword), result)
        assertEquals("token-old", store.accessToken())
        assertEquals(0, localCache.clearCount)
    }

    private fun TestScope.repository(
        cipher: TokenCipher = FakeTokenCipher,
    ): Pair<AuthRepositoryImpl, SessionStore> {
        val store = SessionStore(
            dataStore = FailingWritesDataStore(
                PreferenceDataStoreFactory.create(scope = dataStoreScope) {
                    tmp.root.resolve("session.preferences_pb")
                },
            ) { diskFull },
            cipher = cipher,
            scope = backgroundScope,
            ioDispatcher = StandardTestDispatcher(testScheduler),
            errorLogger = errorLogger,
        )
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(AuthApiService::class.java)
        val repository = AuthRepositoryImpl(
            authApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            sessionStore = store,
            localCache = localCache,
            errorLogger = errorLogger,
            clock = FixedAppClock(NOW),
        )
        return repository to store
    }

    private fun authBody(token: String) = """
        {
          "success": true,
          "message": "OK",
          "data": {
            "access_token": "$token",
            "token_type": "Bearer",
            "expires_in": 604800,
            "user": {
              "id": "2b1f6c1e-4a7d-4c1b-9a43-1f7e0c9d2a11",
              "name": "Joshua",
              "email": "joshua@example.com",
              "avatar_url": null,
              "timezone": "Asia/Jakarta",
              "role": {"slug": "user", "name": "User"},
              "permissions": ["payment_provider.view"],
              "created_at": "2026-10-08T12:30:00Z"
            }
          }
        }
    """.trimIndent()

    private fun errorResponse(
        status: Int,
        code: String,
        fields: String = "[]",
        headers: Headers = Headers.headersOf(),
    ) = MockResponse(
        code = status,
        headers = headers,
        body = """{"success":false,"message":"Failed","data":null,"error":{"code":"$code","fields":$fields}}""",
    )

    private fun json(raw: String): JsonObject = NetworkJson.parseToJsonElement(raw).jsonObject

    private fun RecordedRequest.jsonBody(): JsonObject = json(body!!.utf8())

    private class FailingWritesDataStore(
        private val delegate: DataStore<Preferences>,
        private val failWrites: () -> Boolean,
    ) : DataStore<Preferences> {
        override val data: Flow<Preferences> get() = delegate.data

        override suspend fun updateData(transform: suspend (t: Preferences) -> Preferences): Preferences {
            if (failWrites()) throw IOException("disk full")
            return delegate.updateData(transform)
        }
    }

    // Stands in for a Keystore that refuses to encrypt (e.g. a key invalidated by the OS).
    private object FailingCipher : TokenCipher {
        override fun encrypt(plaintext: String): String = throw IllegalStateException("Keystore unavailable")

        override fun decrypt(ciphertext: String): String? = null
    }

    private companion object {
        val NOW: Instant = Instant.parse("2026-10-12T08:00:00Z")

        // authBody's expires_in: seven days.
        const val TOKEN_LIFETIME_SECONDS = 604_800L
    }

    private val expectedUser = User(
        id = "2b1f6c1e-4a7d-4c1b-9a43-1f7e0c9d2a11",
        name = "Joshua",
        email = "joshua@example.com",
        avatarUrl = null,
        timezone = "Asia/Jakarta",
        role = Role(slug = "user", name = "User"),
        permissions = setOf("payment_provider.view"),
        createdAt = Instant.parse("2026-10-08T12:30:00Z"),
    )
}
