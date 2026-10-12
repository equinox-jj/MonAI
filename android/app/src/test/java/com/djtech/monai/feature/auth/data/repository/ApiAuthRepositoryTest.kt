package com.djtech.monai.feature.auth.data.repository

import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import com.djtech.monai.core.database.FakeLocalCache
import com.djtech.monai.core.datastore.FakeTokenCipher
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.model.Role
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.auth.data.remote.AuthApiService
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.model.AuthFieldError
import com.djtech.monai.feature.auth.domain.model.AuthResult
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runTest
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonObject
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import mockwebserver3.RecordedRequest
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
import java.time.Instant

class ApiAuthRepositoryTest {

    @get:Rule
    val tmp = TemporaryFolder()

    private val server = MockWebServer()
    private val dataStoreScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val localCache = FakeLocalCache()

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
    fun `login sends normalized credentials, saves the token and returns the user`() = runTest {
        val (repository, store) = repository()
        server.enqueue(MockResponse(code = 200, body = authBody(token = "token-1")))

        val result = repository.login("  Joshua@Example.COM ", " s3cretPass ")

        assertEquals(AuthResult.Success(expectedUser), result)
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
    fun `login with wrong credentials fails without saving a token`() = runTest {
        val (repository, store) = repository()
        server.enqueue(errorResponse(401, "invalid_credentials"))

        val result = repository.login("joshua@example.com", "wrongPass1")

        assertEquals(AuthResult.Failure(AuthError.InvalidCredentials), result)
        assertNull(store.accessToken())
    }

    @Test
    fun `register sends the trimmed name and saves the token`() = runTest {
        val (repository, store) = repository()
        server.enqueue(MockResponse(code = 201, body = authBody(token = "token-new")))

        val result = repository.register(" Joshua ", "Joshua@Example.com", "s3cretPass")

        assertEquals(AuthResult.Success(expectedUser), result)
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

        assertEquals(AuthResult.Failure(AuthError.EmailAlreadyRegistered), result)
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
            AuthResult.Failure(
                AuthError.InvalidFields(
                    listOf(
                        AuthFieldError(AuthField.PASSWORD, "min_length", mapOf("min" to "8")),
                        AuthFieldError(AuthField.EMAIL, "invalid_format"),
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

        assertEquals(AuthResult.Failure(AuthError.Unexpected), result)
    }

    @Test
    fun `rate limiting is reported`() = runTest {
        val (repository, _) = repository()
        server.enqueue(errorResponse(429, "rate_limited"))

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(AuthResult.Failure(AuthError.RateLimited), result)
    }

    @Test
    fun `server errors are unexpected`() = runTest {
        val (repository, _) = repository()
        server.enqueue(errorResponse(500, "internal_error"))

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(AuthResult.Failure(AuthError.Unexpected), result)
    }

    @Test
    fun `an unreachable server is a network error`() = runTest {
        val (repository, _) = repository()
        server.close()

        val result = repository.login("joshua@example.com", "s3cretPass")

        assertEquals(AuthResult.Failure(AuthError.Network), result)
    }

    @Test
    fun `logout clears the token and the cache`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")

        repository.logout()

        assertNull(store.accessToken())
        assertEquals(1, localCache.clearCount)
        assertEquals(0, server.requestCount)
    }

    @Test
    fun `logout on all devices clears the session once the server revoked the tokens`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")
        server.enqueue(MockResponse(code = 200, body = """{"success":true,"message":"Logged out","data":null}"""))

        val result = repository.logoutAllDevices()

        assertEquals(AuthResult.Success(Unit), result)
        assertNull(store.accessToken())
        assertEquals(1, localCache.clearCount)
        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals("/api/v1/auth/logout-all", request.url.encodedPath)
    }

    @Test
    fun `a failed logout on all devices keeps the session`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-1")
        server.enqueue(errorResponse(500, "internal_error"))

        val result = repository.logoutAllDevices()

        assertEquals(AuthResult.Failure(AuthError.Unexpected), result)
        assertEquals("token-1", store.accessToken())
        assertEquals(0, localCache.clearCount)
    }

    @Test
    fun `changing the password saves the new token`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-old")
        server.enqueue(MockResponse(code = 200, body = authBody(token = "token-new")))

        val result = repository.changePassword("oldPass123", "newPass123")

        assertEquals(AuthResult.Success(Unit), result)
        assertEquals("token-new", store.accessToken())
        assertEquals(0, localCache.clearCount)
        val request = server.takeRequest()
        assertEquals("PUT", request.method)
        assertEquals("/api/v1/auth/password", request.url.encodedPath)
        assertEquals(
            json("""{"current_password":"oldPass123","new_password":"newPass123"}"""),
            request.jsonBody(),
        )
    }

    @Test
    fun `a wrong current password keeps the old token`() = runTest {
        val (repository, store) = repository()
        store.saveToken("token-old")
        server.enqueue(errorResponse(422, "invalid_password"))

        val result = repository.changePassword("wrongPass1", "newPass123")

        assertEquals(AuthResult.Failure(AuthError.WrongCurrentPassword), result)
        assertEquals("token-old", store.accessToken())
    }

    private fun TestScope.repository(): Pair<ApiAuthRepository, SessionStore> {
        val store = SessionStore(
            dataStore = PreferenceDataStoreFactory.create(scope = dataStoreScope) {
                tmp.root.resolve("session.preferences_pb")
            },
            cipher = FakeTokenCipher,
            scope = backgroundScope,
            ioDispatcher = StandardTestDispatcher(testScheduler),
        )
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(AuthApiService::class.java)
        val repository = ApiAuthRepository(
            authApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson)),
            sessionStore = store,
            localCache = localCache,
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

    private fun errorResponse(status: Int, code: String, fields: String = "[]") = MockResponse(
        code = status,
        body = """{"success":false,"message":"Failed","data":null,"error":{"code":"$code","fields":$fields}}""",
    )

    private fun json(raw: String): JsonObject = NetworkJson.parseToJsonElement(raw).jsonObject

    private fun RecordedRequest.jsonBody(): JsonObject = json(body!!.utf8())

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
