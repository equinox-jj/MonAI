package com.djtech.monai.feature.settings.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.settings.data.remote.AdminProviderApiService
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.AliasIssue
import com.djtech.monai.feature.settings.domain.model.ProviderChanges
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import kotlinx.coroutines.test.runTest
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.time.Instant

class ApiAdminProviderRepositoryTest {

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
    fun `listProviders reads every page of every status and sorts them`() = runTest {
        server.enqueue(MockResponse(code = 200, body = page(1, 2, providerJson("bca", sortOrder = 20))))
        server.enqueue(MockResponse(code = 200, body = page(2, 2, providerJson("cash", sortOrder = 0))))

        val result = repository().listProviders()

        assertEquals(listOf("cash", "bca"), (result as Outcome.Success).data.map { it.id })
        val first = server.takeRequest()
        assertEquals("/api/v1/admin/payment-providers", first.url.encodedPath)
        assertEquals("1", first.url.queryParameter("page"))
        assertEquals("100", first.url.queryParameter("per_page"))
        assertEquals("ALL", first.url.queryParameter("status"))
        assertEquals("2", server.takeRequest().url.queryParameter("page"))
    }

    @Test
    fun `getProvider maps every field`() = runTest {
        server.enqueue(MockResponse(code = 200, body = single(providerJson("ovo", sortOrder = 70, isActive = false))))

        val result = repository().getProvider("ovo")

        assertEquals(Outcome.Success(OVO), result)
    }

    @Test
    fun `createProvider sends the form without a slug`() = runTest {
        server.enqueue(MockResponse(code = 201, body = single(providerJson("ovo", sortOrder = 70, isActive = false))))
        val input = ProviderInput(
            "OVO",
            WalletType.E_WALLET,
            listOf("ovo"),
            sortOrder = 70,
            isActive = true,
        )

        repository().createProvider(input)

        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals(
            """{"name":"OVO","type":"E_WALLET","aliases":["ovo"],"sort_order":70}""",
            request.body?.utf8(),
        )
    }

    @Test
    fun `updateProvider sends only the changes`() = runTest {
        server.enqueue(MockResponse(code = 200, body = single(providerJson("ovo", sortOrder = 70, isActive = false))))

        repository().updateProvider("ovo", ProviderChanges(sortOrder = 5))

        val request = server.takeRequest()
        assertEquals("PATCH", request.method)
        assertEquals("/api/v1/admin/payment-providers/ovo", request.url.encodedPath)
        assertEquals("""{"sort_order":5}""", request.body?.utf8())
    }

    @Test
    fun `setActive patches the status`() = runTest {
        server.enqueue(MockResponse(code = 200, body = single(providerJson("ovo", sortOrder = 70, isActive = false))))

        repository().setActive("ovo", active = false)

        val request = server.takeRequest()
        assertEquals("/api/v1/admin/payment-providers/ovo/status", request.url.encodedPath)
        assertEquals("""{"is_active":false}""", request.body?.utf8())
    }

    @Test
    fun `uploadLogo sends the file part`() = runTest {
        server.enqueue(MockResponse(code = 200, body = single(providerJson("ovo", sortOrder = 70, isActive = false))))

        repository().uploadLogo("ovo", EncodedImage(byteArrayOf(1, 2, 3), "image/webp"))

        val request = server.takeRequest()
        assertEquals("PUT", request.method)
        assertEquals("/api/v1/admin/payment-providers/ovo/logo", request.url.encodedPath)
        assertTrue(request.body?.utf8().orEmpty().contains("name=\"file\"; filename=\"file.webp\""))
    }

    @Test
    fun `deleteProvider maps business errors`() = runTest {
        server.enqueue(error(422, "system_provider_locked"))
        server.enqueue(error(403, "forbidden"))
        server.enqueue(error(409, "conflict"))

        val repository = repository()

        assertEquals(Outcome.Failure(AdminProviderError.Locked), repository.deleteProvider("cash"))
        assertEquals(Outcome.Failure(AdminProviderError.Forbidden), repository.deleteProvider("cash"))
        assertEquals(Outcome.Failure(AdminProviderError.Conflict), repository.deleteProvider("cash"))
    }

    @Test
    fun `alias field errors are decoded`() = runTest {
        server.enqueue(validationFailed("aliases[1]", "max_length"))
        server.enqueue(validationFailed("aliases", "max_length"))

        val repository = repository()
        val changes = ProviderChanges(aliases = listOf("a"))

        assertEquals(
            Outcome.Failure(AdminProviderError.InvalidAliases(AliasIssue.TOO_LONG)),
            repository.updateProvider("ovo", changes),
        )
        assertEquals(
            Outcome.Failure(AdminProviderError.InvalidAliases(AliasIssue.TOO_MANY)),
            repository.updateProvider("ovo", changes),
        )
    }

    @Test
    fun `an unreachable server is a network error`() = runTest {
        val repository = repository()
        server.close()

        assertEquals(Outcome.Failure(AdminProviderError.Network), repository.listProviders())
    }

    private fun repository(): ApiAdminProviderRepository {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(AdminProviderApiService::class.java)
        return ApiAdminProviderRepository(api, ApiCaller(ApiErrorMapper(NetworkJson), errorLogger))
    }

    private fun providerJson(id: String, sortOrder: Int, isActive: Boolean = true) = """
        {
          "id": "$id",
          "slug": "$id",
          "name": "${id.uppercase()}",
          "type": "E_WALLET",
          "logo_url": null,
          "aliases": ["$id"],
          "sort_order": $sortOrder,
          "is_active": $isActive,
          "is_system": false,
          "created_by": null,
          "updated_by": null,
          "created_at": "2026-09-01T00:00:00Z",
          "updated_at": "2026-10-02T09:00:00Z"
        }
    """.trimIndent()

    private fun single(provider: String) = """{"success":true,"message":"OK","data":$provider}"""

    private fun page(page: Int, totalPages: Int, vararg providers: String) = """
        {"success":true,"message":"OK","data":[${providers.joinToString(",")}],
         "meta":{"page":$page,"per_page":100,"total":2,"total_pages":$totalPages}}
    """.trimIndent()

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

    private companion object {
        val OVO = AdminPaymentProvider(
            id = "ovo",
            slug = "ovo",
            name = "OVO",
            type = WalletType.E_WALLET,
            logoUrl = null,
            aliases = listOf("ovo"),
            sortOrder = 70,
            isActive = false,
            isSystem = false,
            updatedAt = Instant.parse("2026-10-02T09:00:00Z"),
        )
    }
}
