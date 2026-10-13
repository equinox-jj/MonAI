package com.djtech.monai.feature.wallets.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakePaymentProviderDao
import com.djtech.monai.core.database.entity.PaymentProviderCatalogEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.wallets.data.remote.PaymentProviderApiService
import com.djtech.monai.feature.wallets.data.seed.PaymentProviderSeed
import com.djtech.monai.feature.wallets.domain.model.WalletError
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runTest
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.Headers.Companion.headersOf
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
import java.io.File
import java.io.IOException

class ApiPaymentProviderRepositoryTest {

    private val errorLogger = RecordingErrorLogger()
    private val server = MockWebServer()
    private val testScope = TestScope(StandardTestDispatcher())

    @Before
    fun setUp() {
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
    }

    @Test
    fun `before the first refresh the bundled seed is served by slug`() = testScope.runTest {
        val providers = repository(FakePaymentProviderDao()).observeProviders().first()

        assertEquals(listOf("cash", "bca"), providers.map(PaymentProvider::slug))
        assertEquals(listOf("", ""), providers.map(PaymentProvider::id))
        assertEquals(listOf("cash", "tunai"), providers.first().aliases)
    }

    @Test
    fun `the bundled seed asset parses and matches the server's seed providers`() = testScope.runTest {
        // Unit tests run from the module directory, so the asset is read straight from the sources.
        val asset = PaymentProviderSeed { File("src/main/assets/payment_providers_seed.json").readText() }

        val providers = repository(FakePaymentProviderDao(), seed = asset).observeProviders().first()

        assertEquals(
            listOf(
                "cash", "bca", "mandiri", "bri", "bni", "bsi", "jago", "seabank",
                "gopay", "ovo", "dana", "shopeepay", "linkaja",
            ),
            providers.map(PaymentProvider::slug),
        )
        assertEquals(emptyList<Throwable>(), errorLogger.errors)
    }

    @Test
    fun `a seed that can't be read leaves the grid empty and logs`() = testScope.runTest {
        val repository = repository(FakePaymentProviderDao(), seed = { throw IOException("missing asset") })

        assertEquals(emptyList<PaymentProvider>(), repository.observeProviders().first())
        assertEquals(1, errorLogger.errors.size)
    }

    @Test
    fun `the cached catalog replaces the seed`() = testScope.runTest {
        val dao = FakePaymentProviderDao(listOf(GOPAY.asEntity(), BCA.asEntity()))

        assertEquals(listOf(BCA, GOPAY), repository(dao).observeProviders().first())
    }

    @Test
    fun `refresh caches the catalog with its version and ETag`() = testScope.runTest {
        val dao = FakePaymentProviderDao()
        server.enqueue(MockResponse(code = 200, headers = headersOf("ETag", "\"v12\""), body = catalogBody(12)))

        val result = repository(dao).refresh()

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("/api/v1/payment-providers", request.url.encodedPath)
        assertNull(request.headers["If-None-Match"])
        assertEquals(listOf(BCA, GOPAY), dao.providers.map { it.asModel() })
        assertEquals(PaymentProviderCatalogEntity(version = 12, etag = "\"v12\""), dao.meta)
    }

    @Test
    fun `refresh sends the cached ETag and keeps the cache on 304`() = testScope.runTest {
        val meta = PaymentProviderCatalogEntity(version = 12, etag = "\"v12\"")
        val dao = FakePaymentProviderDao(listOf(BCA.asEntity()), meta)
        server.enqueue(MockResponse(code = 304))

        assertEquals(Outcome.Success(Unit), repository(dao).refresh())
        assertEquals("\"v12\"", server.takeRequest().headers["If-None-Match"])
        assertEquals(listOf(BCA), dao.providers.map { it.asModel() })
        assertEquals(meta, dao.meta)
    }

    @Test
    fun `refresh skips the ETag when no providers are cached`() = testScope.runTest {
        val dao = FakePaymentProviderDao(meta = PaymentProviderCatalogEntity(version = 12, etag = "\"v12\""))
        server.enqueue(MockResponse(code = 200, headers = headersOf("ETag", "\"v12\""), body = catalogBody(12)))

        repository(dao).refresh()

        assertNull(server.takeRequest().headers["If-None-Match"])
        assertEquals(2, dao.providers.size)
    }

    @Test
    fun `refresh offline fails with a network error`() = testScope.runTest {
        val repository = repository(FakePaymentProviderDao())
        server.close()

        assertEquals(Outcome.Failure(WalletError.Network), repository.refresh())
    }

    @Test
    fun `refresh fails as unexpected on a server error`() = testScope.runTest {
        server.enqueue(
            MockResponse(
                code = 500,
                body = """{"success":false,"message":"Failed","data":null,"error":{"code":"internal_error"}}""",
            ),
        )

        assertEquals(Outcome.Failure(WalletError.Unexpected), repository(FakePaymentProviderDao()).refresh())
    }

    @Test
    fun `refresh fails as unexpected and logs when the cache cannot be written`() = testScope.runTest {
        val failure = IOException("disk full")
        val dao = FakePaymentProviderDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 200, body = catalogBody(12)))

        assertEquals(Outcome.Failure(WalletError.Unexpected), repository(dao).refresh())
        assertSame(failure, errorLogger.errors.single())
    }

    private fun TestScope.repository(
        dao: FakePaymentProviderDao,
        seed: PaymentProviderSeed = PaymentProviderSeed { SEED_JSON },
    ): ApiPaymentProviderRepository {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(PaymentProviderApiService::class.java)
        return ApiPaymentProviderRepository(
            paymentProviderApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            paymentProviderDao = dao,
            seed = seed,
            errorLogger = errorLogger,
            ioDispatcher = StandardTestDispatcher(testScheduler),
        )
    }

    private fun catalogBody(version: Long) = """
        {"success":true,"message":"OK","data":{"version":$version,"providers":[
          {"id":"p-bca","slug":"bca","name":"BCA","type":"BANK","logo_url":"https://cdn.example.com/bca.png",
           "aliases":["bank central asia"],"sort_order":10},
          {"id":"p-gopay","slug":"gopay","name":"GoPay","type":"E_WALLET","logo_url":null,
           "aliases":["go-pay","gpay"],"sort_order":100}
        ]}}
    """.trimIndent()

    private companion object {
        val BCA = PaymentProvider(
            id = "p-bca",
            slug = "bca",
            name = "BCA",
            type = WalletType.BANK,
            logoUrl = "https://cdn.example.com/bca.png",
            aliases = listOf("bank central asia"),
            sortOrder = 10,
        )

        val GOPAY = PaymentProvider(
            id = "p-gopay",
            slug = "gopay",
            name = "GoPay",
            type = WalletType.E_WALLET,
            logoUrl = null,
            aliases = listOf("go-pay", "gpay"),
            sortOrder = 100,
        )

        // Out of order on purpose: the repository sorts the seed like the cache.
        val SEED_JSON = """
            [
              {"slug":"bca","name":"BCA","type":"BANK","aliases":["bank central asia"],"sort_order":10},
              {"slug":"cash","name":"Cash","type":"CASH","aliases":["cash","tunai"],"sort_order":0}
            ]
        """.trimIndent()
    }
}
