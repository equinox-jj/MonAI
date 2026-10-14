package com.djtech.monai.feature.wallets.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakeWalletDao
import com.djtech.monai.core.database.entity.WalletEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.wallets.data.remote.WalletApiService
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue
import com.djtech.monai.feature.wallets.domain.model.WalletInput
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

class WalletRepositoryImplTest {

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
    fun `observeAllWallets keeps archived wallets in the same order`() = runTest {
        val dao = FakeWalletDao(
            listOf(
                entity(id = "a", name = "Cash"),
                entity(id = "b", name = "BCA", isDefault = true),
                entity(id = "c", name = "Dana", isArchived = true),
            ),
        )

        val wallets = repository(dao).observeAllWallets().first()

        assertEquals(listOf("b", "a", "c"), wallets.map(Wallet::id))
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

    @Test
    fun `createWallet posts the form and caches the new wallet`() = runTest {
        val dao = FakeWalletDao()
        server.enqueue(MockResponse(code = 201, body = walletBody(GOPAY_JSON)))

        val result = repository(dao).createWallet(
            WalletInput(name = "GoPay", type = WalletType.E_WALLET, initialBalance = 0),
        )

        assertEquals(Outcome.Success(GOPAY), result)
        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals("/api/v1/wallets", request.url.encodedPath)
        assertEquals(
            """{"name":"GoPay","type":"E_WALLET","initial_balance":0,"is_default":false}""",
            request.body?.utf8(),
        )
        assertEquals(listOf(GOPAY), dao.wallets.map { it.asModel() })
    }

    @Test
    fun `a new default wallet clears the old default in the cache`() = runTest {
        val dao = FakeWalletDao(listOf(entity(id = "cash", name = "Cash", isDefault = true)))
        server.enqueue(MockResponse(code = 201, body = walletBody(BCA_JSON)))

        repository(dao).createWallet(WalletInput(name = "BCA Tabungan", type = WalletType.BANK, isDefault = true))

        assertEquals(listOf(BCA.id to true, "cash" to false), dao.wallets.map { it.id to it.isDefault })
    }

    @Test
    fun `createWallet with a taken name fails on the name field`() = runTest {
        val dao = FakeWalletDao()
        server.enqueue(
            MockResponse(
                code = 409,
                body = """{"success":false,"message":"Taken","data":null,"error":{"code":"conflict"}}""",
            ),
        )

        val result = repository(dao).createWallet(WalletInput(name = "Cash", type = WalletType.CASH))

        assertEquals(
            Outcome.Failure(
                WalletError.InvalidFields(listOf(WalletFieldError(WalletField.NAME, WalletFieldIssue.ALREADY_EXISTS))),
            ),
            result,
        )
        assertEquals(emptyList<WalletEntity>(), dao.wallets)
    }

    @Test
    fun `updateWallet patches only the changed fields and caches the result`() = runTest {
        val dao = FakeWalletDao(listOf(BCA.copy(name = "BCA").asEntity()))
        server.enqueue(MockResponse(code = 200, body = walletBody(BCA_JSON)))

        val result = repository(dao).updateWallet(BCA.id, WalletChanges(name = "BCA Tabungan"))

        assertEquals(Outcome.Success(BCA), result)
        val request = server.takeRequest()
        assertEquals("PATCH", request.method)
        assertEquals("/api/v1/wallets/${BCA.id}", request.url.encodedPath)
        assertEquals("""{"name":"BCA Tabungan"}""", request.body?.utf8())
        assertEquals(listOf(BCA), dao.wallets.map { it.asModel() })
    }

    @Test
    fun `setting a default through update clears the old default in the cache`() = runTest {
        val dao = FakeWalletDao(
            listOf(entity(id = "cash", name = "Cash", isDefault = true), BCA.copy(isDefault = false).asEntity()),
        )
        server.enqueue(MockResponse(code = 200, body = walletBody(BCA_JSON)))

        repository(dao).updateWallet(BCA.id, WalletChanges(isDefault = true))

        assertEquals(listOf(BCA.id to true, "cash" to false), dao.wallets.map { it.id to it.isDefault })
    }

    @Test
    fun `archiving the default wallet fails with the business rule`() = runTest {
        val dao = FakeWalletDao(listOf(BCA.asEntity()))
        server.enqueue(
            MockResponse(
                code = 422,
                body = """{"success":false,"message":"No","data":null,"error":{"code":"default_wallet_required"}}""",
            ),
        )

        val result = repository(dao).updateWallet(BCA.id, WalletChanges(isArchived = true))

        assertEquals(Outcome.Failure(WalletError.DefaultRequired), result)
        assertEquals(listOf(BCA), dao.wallets.map { it.asModel() })
    }

    @Test
    fun `deleteWallet removes the wallet from the cache`() = runTest {
        val dao = FakeWalletDao(listOf(GOPAY.asEntity(), BCA.asEntity()))
        server.enqueue(MockResponse(code = 200, body = """{"success":true,"message":"Deleted","data":null}"""))

        val result = repository(dao).deleteWallet(GOPAY.id)

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("DELETE", request.method)
        assertEquals("/api/v1/wallets/${GOPAY.id}", request.url.encodedPath)
        assertEquals(listOf(BCA.id), dao.wallets.map { it.id })
    }

    @Test
    fun `deleting a wallet with transactions keeps it and says so`() = runTest {
        val dao = FakeWalletDao(listOf(GOPAY.asEntity()))
        server.enqueue(
            MockResponse(
                code = 422,
                body = """{"success":false,"message":"No","data":null,"error":{"code":"wallet_has_transactions"}}""",
            ),
        )

        assertEquals(Outcome.Failure(WalletError.HasTransactions), repository(dao).deleteWallet(GOPAY.id))
        assertEquals(listOf(GOPAY.id), dao.wallets.map { it.id })
    }

    @Test
    fun `refreshWallet caches the server's copy`() = runTest {
        val dao = FakeWalletDao(listOf(BCA.copy(currentBalance = 1).asEntity()))
        server.enqueue(MockResponse(code = 200, body = walletBody(BCA_JSON)))

        assertEquals(Outcome.Success(Unit), repository(dao).refreshWallet(BCA.id))
        assertEquals("/api/v1/wallets/${BCA.id}", server.takeRequest().url.encodedPath)
        assertEquals(listOf(BCA), dao.wallets.map { it.asModel() })
    }

    @Test
    fun `refreshWallet drops a wallet the server no longer has`() = runTest {
        val dao = FakeWalletDao(listOf(BCA.asEntity()))
        server.enqueue(
            MockResponse(
                code = 404,
                body = """{"success":false,"message":"Not found","data":null,"error":{"code":"not_found"}}""",
            ),
        )

        assertEquals(Outcome.Failure(WalletError.NotFound), repository(dao).refreshWallet(BCA.id))
        assertEquals(emptyList<WalletEntity>(), dao.wallets)
    }

    @Test
    fun `a write that can't be cached fails as unexpected and logs`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeWalletDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 201, body = walletBody(GOPAY_JSON)))

        val result = repository(dao).createWallet(WalletInput(name = "GoPay", type = WalletType.E_WALLET))

        assertEquals(Outcome.Failure(WalletError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    private fun repository(dao: FakeWalletDao): WalletRepositoryImpl {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(WalletApiService::class.java)
        return WalletRepositoryImpl(
            walletApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            walletDao = dao,
            errorLogger = errorLogger,
        )
    }

    private fun walletBody(wallet: String) = """{"success":true,"message":"OK","data":$wallet}"""

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
