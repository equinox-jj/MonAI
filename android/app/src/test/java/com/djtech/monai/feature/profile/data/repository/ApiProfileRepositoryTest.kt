package com.djtech.monai.feature.profile.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakeLocalCache
import com.djtech.monai.core.database.FakeUserDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.datastore.FakeTokenCipher
import com.djtech.monai.core.datastore.InMemoryPreferencesDataStore
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.core.model.Role
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.profile.data.remote.ProfileApiService
import com.djtech.monai.feature.profile.domain.model.AvatarUpload
import com.djtech.monai.feature.profile.domain.model.NameIssue
import com.djtech.monai.feature.profile.domain.model.ProfileChanges
import com.djtech.monai.feature.profile.domain.model.ProfileError
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runTest
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertSame
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.io.IOException
import java.time.Instant

class ApiProfileRepositoryTest {

    private val errorLogger = RecordingErrorLogger()
    private val server = MockWebServer()
    private val localCache = FakeLocalCache()

    @Before
    fun setUp() {
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
    }

    @Test
    fun `refreshUser asks for me and caches every field`() = runTest {
        val dao = FakeUserDao()
        server.enqueue(MockResponse(code = 200, body = meBody(JOSHUA_JSON)))

        val result = repository(dao).refreshUser()

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("GET", request.method)
        assertEquals("/api/v1/me", request.url.encodedPath)
        assertEquals(JOSHUA, dao.user?.asModel())
    }

    @Test
    fun `refreshUser replaces a previously cached user`() = runTest {
        val dao = FakeUserDao(JOSHUA.copy(id = "previous", name = "Someone else").asEntity())
        server.enqueue(MockResponse(code = 200, body = meBody(JOSHUA_JSON)))

        repository(dao).refreshUser()

        assertEquals(JOSHUA, dao.user?.asModel())
    }

    @Test
    fun `observeUser emits the cached user, or null before the first fetch`() = runTest {
        assertNull(repository(FakeUserDao()).observeUser().first())
        assertEquals(JOSHUA, repository(FakeUserDao(JOSHUA.asEntity())).observeUser().first())
    }

    @Test
    fun `refreshUser offline fails with a network error and keeps the cache`() = runTest {
        val dao = FakeUserDao(JOSHUA.asEntity())
        val repository = repository(dao)
        server.close()

        val result = repository.refreshUser()

        assertEquals(Outcome.Failure(ProfileError.Network), result)
        assertEquals(JOSHUA, dao.user?.asModel())
    }

    @Test
    fun `refreshUser fails as unexpected on a server error and keeps the cache`() = runTest {
        val dao = FakeUserDao(JOSHUA.asEntity())
        server.enqueue(
            MockResponse(
                code = 500,
                body = """{"success":false,"message":"Failed","data":null,"error":{"code":"internal_error"}}""",
            ),
        )

        val result = repository(dao).refreshUser()

        assertEquals(Outcome.Failure(ProfileError.Unexpected), result)
        assertEquals(JOSHUA, dao.user?.asModel())
    }

    @Test
    fun `refreshUser fails as unexpected when a date does not parse and keeps the cache`() = runTest {
        val dao = FakeUserDao(JOSHUA.asEntity())
        val badDate = JOSHUA_JSON.replace("2026-10-08T12:30:00Z", "today")
        server.enqueue(MockResponse(code = 200, body = meBody(badDate)))

        val result = repository(dao).refreshUser()

        assertEquals(Outcome.Failure(ProfileError.Unexpected), result)
        assertEquals(JOSHUA, dao.user?.asModel())
    }

    @Test
    fun `refreshUser fails as unexpected and logs when the cache cannot be written`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeUserDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 200, body = meBody(JOSHUA_JSON)))

        val result = repository(dao).refreshUser()

        assertEquals(Outcome.Failure(ProfileError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    @Test
    fun `updateProfile patches only the given fields and caches the user`() = runTest {
        val dao = FakeUserDao(JOSHUA.asEntity())
        server.enqueue(MockResponse(code = 200, body = meBody(JOSHUA_JSON.replace("\"Joshua\"", "\"Josh\""))))

        val result = repository(dao).updateProfile(ProfileChanges(name = "Josh"))

        assertEquals(Outcome.Success(JOSHUA.copy(name = "Josh")), result)
        val request = server.takeRequest()
        assertEquals("PATCH", request.method)
        assertEquals("/api/v1/me", request.url.encodedPath)
        assertEquals("""{"name":"Josh"}""", request.body?.utf8())
        assertEquals("Josh", dao.user?.name)
    }

    @Test
    fun `updateProfile maps field errors`() = runTest {
        server.enqueue(validationFailed("timezone", "invalid_format"))
        server.enqueue(validationFailed("name", "max_length"))

        val repository = repository()

        assertEquals(
            Outcome.Failure(ProfileError.InvalidTimezone),
            repository.updateProfile(ProfileChanges(timezone = "Mars/Olympus")),
        )
        assertEquals(
            Outcome.Failure(ProfileError.InvalidName(NameIssue.TOO_LONG)),
            repository.updateProfile(ProfileChanges(name = "a".repeat(101))),
        )
    }

    @Test
    fun `uploadAvatar sends the image as the file part, reports progress and caches the user`() = runTest {
        val dao = FakeUserDao(JOSHUA.copy(avatarUrl = null).asEntity())
        server.enqueue(MockResponse(code = 200, body = meBody(JOSHUA_JSON)))
        val image = EncodedImage(ByteArray(20_000) { 7 }, "image/webp")

        val steps = repository(dao).uploadAvatar(image).toList()

        val request = server.takeRequest()
        assertEquals("PUT", request.method)
        assertEquals("/api/v1/me/avatar", request.url.encodedPath)
        val body = request.body?.utf8().orEmpty()
        assertTrue(body.contains("name=\"file\"; filename=\"file.webp\""))
        assertTrue(body.contains("Content-Type: image/webp"))
        assertEquals(AvatarUpload.Done(Outcome.Success(Unit)), steps.last())
        assertEquals(AvatarUpload.Progress(1f), steps[steps.size - 2])
        assertEquals(JOSHUA.avatarUrl, dao.user?.avatarUrl)
    }

    @Test
    fun `uploadAvatar maps a file that is too large`() = runTest {
        server.enqueue(validationFailed("file", "max_size"))

        val steps = repository().uploadAvatar(EncodedImage(byteArrayOf(1), "image/webp")).toList()

        assertEquals(AvatarUpload.Done(Outcome.Failure(ProfileError.PhotoTooLarge)), steps.last())
    }

    @Test
    fun `removeAvatar deletes it and clears the cached url`() = runTest {
        val dao = FakeUserDao(JOSHUA.asEntity())
        server.enqueue(MockResponse(code = 200, body = DELETED))

        val result = repository(dao).removeAvatar()

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("DELETE", request.method)
        assertEquals("/api/v1/me/avatar", request.url.encodedPath)
        assertNull(dao.user?.avatarUrl)
        assertEquals(JOSHUA.name, dao.user?.name)
    }

    @Test
    fun `deleteAccount sends the password, then signs out and clears the cache`() = runTest {
        val repository = repository(FakeUserDao(JOSHUA.asEntity()))
        sessionStore().saveToken("token-1")
        server.enqueue(MockResponse(code = 200, body = DELETED))

        val result = repository.deleteAccount("secret")

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("DELETE", request.method)
        assertEquals("/api/v1/me", request.url.encodedPath)
        assertEquals("""{"password":"secret"}""", request.body?.utf8())
        assertNull(sessionStore().accessToken())
        assertEquals(1, localCache.clearCount)
    }

    @Test
    fun `deleteAccount with a wrong password keeps the session`() = runTest {
        val repository = repository()
        sessionStore().saveToken("token-1")
        server.enqueue(error(422, "invalid_password"))

        assertEquals(Outcome.Failure(ProfileError.WrongPassword), repository.deleteAccount("nope"))
        assertEquals("token-1", sessionStore().accessToken())
        assertEquals(0, localCache.clearCount)
    }

    @Test
    fun `deleteAccount refuses to delete the last admin`() = runTest {
        server.enqueue(error(422, "last_admin"))

        assertEquals(Outcome.Failure(ProfileError.LastAdmin), repository().deleteAccount("secret"))
    }

    private fun error(status: Int, code: String) = MockResponse(
        code = status,
        body = """{"success":false,"message":"Failed","data":null,"error":{"code":"$code"}}""",
    )

    private fun validationFailed(field: String, code: String) = MockResponse(
        code = 422,
        body = """
            {"success":false,"message":"Failed","data":null,
             "error":{"code":"validation_failed","fields":[{"field":"$field","code":"$code","message":"bad"}]}}
        """.trimIndent(),
    )

    private fun TestScope.repository(dao: FakeUserDao = FakeUserDao()): ApiProfileRepository {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(ProfileApiService::class.java)
        return ApiProfileRepository(
            profileApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            userDao = dao,
            sessionStore = sessionStore(),
            localCache = localCache,
            errorLogger = errorLogger,
        )
    }

    private var sessionStore: SessionStore? = null

    // One store per test, so a test can sign in before calling the repository and check it after.
    private fun TestScope.sessionStore(): SessionStore = sessionStore ?: SessionStore(
        dataStore = InMemoryPreferencesDataStore(),
        cipher = FakeTokenCipher,
        scope = backgroundScope,
        ioDispatcher = StandardTestDispatcher(testScheduler),
        errorLogger = errorLogger,
    ).also { sessionStore = it }

    private fun meBody(user: String) = """{"success":true,"message":"OK","data":$user}"""

    private companion object {
        val JOSHUA = User(
            id = "2b1f6c1e-4a7d-4c1b-9a43-1f7e0c9d2a11",
            name = "Joshua",
            email = "joshua@example.com",
            avatarUrl = "https://cdn.example.com/avatars/joshua.png",
            timezone = "Asia/Makassar",
            role = Role(slug = "admin", name = "Admin"),
            permissions = setOf("payment_provider.view", "payment_provider.create"),
            createdAt = Instant.parse("2026-10-08T12:30:00Z"),
        )

        val JOSHUA_JSON = """
            {
              "id": "2b1f6c1e-4a7d-4c1b-9a43-1f7e0c9d2a11",
              "name": "Joshua",
              "email": "joshua@example.com",
              "avatar_url": "https://cdn.example.com/avatars/joshua.png",
              "timezone": "Asia/Makassar",
              "role": {"slug": "admin", "name": "Admin"},
              "permissions": ["payment_provider.view", "payment_provider.create"],
              "created_at": "2026-10-08T12:30:00Z"
            }
        """.trimIndent()

        const val DELETED = """{"success":true,"message":"Deleted","data":null}"""
    }
}
