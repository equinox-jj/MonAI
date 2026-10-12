package com.djtech.monai.feature.profile.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakeUserDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Role
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.profile.data.remote.ProfileApiService
import com.djtech.monai.feature.profile.domain.model.ProfileError
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertSame
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.io.IOException
import java.time.Instant

class ApiProfileRepositoryTest {

    private val errorLogger = RecordingErrorLogger()
    private val server = MockWebServer()

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

    private fun repository(dao: FakeUserDao): ApiProfileRepository {
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
            errorLogger = errorLogger,
        )
    }

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
    }
}
