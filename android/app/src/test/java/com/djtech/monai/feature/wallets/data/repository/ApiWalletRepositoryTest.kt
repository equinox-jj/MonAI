package com.djtech.monai.feature.wallets.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakeWalletDao
import com.djtech.monai.core.database.entity.WalletEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.wallets.data.remote.WalletApiService
import com.djtech.monai.feature.wallets.domain.model.WalletError
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

class ApiWalletRepositoryTest {

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
    fun `refresh asks for archived wallets too and caches every field`() = runTest {
        val dao = FakeWalletDao()
        server.enqueue(MockResponse(code = 200, body = walletsBody(BCA_JSON, GOPAY_JSON)))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("GET", request.method)
        assertEquals("/api/v1/wallets", request.url.encodedPath)
        assertEquals("true", request.url.queryParameter("include_archived"))
        assertEquals(listOf(BCA, GOPAY), dao.wallets.map { it.asModel() })
    }

    @Test
    fun `refresh drops wallets the server no longer returns`() = runTest {
        val dao = FakeWalletDao(listOf(entity(id = "stale", name = "Old wallet")))
        server.enqueue(MockResponse(code = 200, body = walletsBody(GOPAY_JSON)))

        repository(dao).refresh()

        assertEquals(listOf(GOPAY.id), dao.wallets.map { it.id })
    }

    @Test
    fun `observeWallets hides archived wallets and lists the default first`() = runTest {
        val dao = FakeWalletDao(
            listOf(
                entity(id = "a", name = "Cash"),
                entity(id = "b", name = "BCA", isDefault = true),
                entity(id = "c", name = "Dana", isArchived = true),
            ),
        )

        val wallets = repository(dao).observeWallets().first()

        assertEquals(listOf("b", "a"), wallets.map(Wallet::id))
    }

    @Test
    fun `observeWallet finds an archived wallet by id`() = runTest {
        val dao = FakeWalletDao(listOf(entity(id = "c", name = "Dana", isArchived = true)))

        val wallet = repository(dao).observeWallet("c").first()

        assertEquals("c", wallet?.id)
    }

    @Test
    fun `observeWallet emits null for an unknown id`() = runTest {
        assertNull(repository(FakeWalletDao()).observeWallet("missing").first())
    }

    @Test
    fun `refresh offline fails with a network error and keeps the cache`() = runTest {
        val cached = entity(id = "a", name = "Cash")
        val dao = FakeWalletDao(listOf(cached))
        val repository = repository(dao)
        server.close()

        val result = repository.refresh()

        assertEquals(Outcome.Failure(WalletError.Network), result)
        assertEquals(listOf(cached), dao.wallets)
    }

    @Test
    fun `refresh fails as unexpected on a server error and keeps the cache`() = runTest {
        val cached = entity(id = "a", name = "Cash")
        val dao = FakeWalletDao(listOf(cached))
        server.enqueue(
            MockResponse(
                code = 500,
                body = """{"success":false,"message":"Failed","data":null,"error":{"code":"internal_error"}}""",
            ),
        )

        val result = repository(dao).refresh()

        assertEquals(Outcome.Failure(WalletError.Unexpected), result)
        assertEquals(listOf(cached), dao.wallets)
    }

    @Test
    fun `refresh fails as unexpected when the body does not parse and keeps the cache`() = runTest {
        val cached = entity(id = "a", name = "Cash")
        val dao = FakeWalletDao(listOf(cached))
        server.enqueue(MockResponse(code = 200, body = """{"success":true,"message":"OK","data":[{"id":"x"}]}"""))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Failure(WalletError.Unexpected), result)
        assertEquals(listOf(cached), dao.wallets)
    }

    @Test
    fun `refresh fails as unexpected when a date does not parse and keeps the cache`() = runTest {
        val cached = entity(id = "a", name = "Cash")
        val dao = FakeWalletDao(listOf(cached))
        val badDate = BCA_JSON.replace("2026-10-11T08:15:30Z", "yesterday")
        server.enqueue(MockResponse(code = 200, body = walletsBody(badDate)))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Failure(WalletError.Unexpected), result)
        assertEquals(listOf(cached), dao.wallets)
    }

    @Test
    fun `refresh fails as unexpected and logs when the cache cannot be written`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeWalletDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 200, body = walletsBody(BCA_JSON)))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Failure(WalletError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    private fun repository(dao: FakeWalletDao): ApiWalletRepository {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(WalletApiService::class.java)
        return ApiWalletRepository(
            walletApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            walletDao = dao,
            errorLogger = errorLogger,
        )
    }

    // `meta` is sent like the real API, though the repository doesn't read it.
    private fun walletsBody(vararg wallets: String) =
        """{"success":true,"message":"OK","data":[${wallets.joinToString(",")}],"meta":{"total_balance":0}}"""

    private fun entity(
        id: String,
        name: String,
        isDefault: Boolean = false,
        isArchived: Boolean = false,
    ) = WalletEntity(
        id = id,
        providerId = null,
        name = name,
        type = WalletType.CASH,
        logoUrl = null,
        initialBalance = 0,
        currentBalance = 0,
        icon = null,
        color = null,
        isDefault = isDefault,
        isArchived = isArchived,
        createdAt = CREATED_AT,
        updatedAt = CREATED_AT,
    )

    private companion object {
        val CREATED_AT: Instant = Instant.parse("2026-10-01T03:00:00Z")

        val BCA = Wallet(
            id = "5f3c9a1e-8b2d-4c7a-9e1f-2a6b8c4d0e17",
            providerId = "0b6e2f4a-1c3d-4e5f-8a9b-7c6d5e4f3a21",
            name = "BCA Tabungan",
            type = WalletType.BANK,
            logoUrl = "https://cdn.example.com/bca.png",
            initialBalance = 5_000_000,
            currentBalance = 8_250_000,
            icon = null,
            color = "#3C36B3",
            isDefault = true,
            isArchived = false,
            createdAt = CREATED_AT,
            updatedAt = Instant.parse("2026-10-11T08:15:30Z"),
        )

        val GOPAY = Wallet(
            id = "9a8b7c6d-5e4f-4a3b-2c1d-0e9f8a7b6c5d",
            providerId = null,
            name = "GoPay",
            type = WalletType.E_WALLET,
            logoUrl = null,
            initialBalance = 0,
            currentBalance = 1_185_000,
            icon = "wallet",
            color = null,
            isDefault = false,
            isArchived = true,
            createdAt = CREATED_AT,
            updatedAt = CREATED_AT,
        )

        val BCA_JSON = """
            {
              "id": "5f3c9a1e-8b2d-4c7a-9e1f-2a6b8c4d0e17",
              "provider_id": "0b6e2f4a-1c3d-4e5f-8a9b-7c6d5e4f3a21",
              "name": "BCA Tabungan",
              "type": "BANK",
              "logo_url": "https://cdn.example.com/bca.png",
              "initial_balance": 5000000,
              "current_balance": 8250000,
              "icon": null,
              "color": "#3C36B3",
              "is_default": true,
              "is_archived": false,
              "created_at": "2026-10-01T03:00:00Z",
              "updated_at": "2026-10-11T08:15:30Z"
            }
        """.trimIndent()

        val GOPAY_JSON = """
            {
              "id": "9a8b7c6d-5e4f-4a3b-2c1d-0e9f8a7b6c5d",
              "provider_id": null,
              "name": "GoPay",
              "type": "E_WALLET",
              "logo_url": null,
              "initial_balance": 0,
              "current_balance": 1185000,
              "icon": "wallet",
              "color": null,
              "is_default": false,
              "is_archived": true,
              "created_at": "2026-10-01T03:00:00Z",
              "updated_at": "2026-10-01T03:00:00Z"
            }
        """.trimIndent()
    }
}
