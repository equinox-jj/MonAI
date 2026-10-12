package com.djtech.monai.feature.transactions.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakeTransactionDao
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.transactions.data.remote.TransactionApiService
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertSame
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.io.IOException
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth

class ApiTransactionRepositoryTest {

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
    fun `refreshRecent asks for the month's first page and caches every field`() = runTest {
        val dao = FakeTransactionDao()
        server.enqueue(MockResponse(code = 200, body = transactionsBody(LUNCH_JSON, TOP_UP_JSON, hasMore = false)))

        val result = repository(dao).refreshRecentTransactions(OCTOBER, limit = 5)

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("GET", request.method)
        assertEquals("/api/v1/transactions", request.url.encodedPath)
        assertEquals("2026-10", request.url.queryParameter("month"))
        assertEquals("5", request.url.queryParameter("limit"))
        assertEquals(listOf(LUNCH, TOP_UP), dao.transactions.map { it.asModel() })
    }

    @Test
    fun `refreshRecent drops the month's transactions the server no longer has when it sent them all`() = runTest {
        val dao = FakeTransactionDao(
            listOf(
                entity(id = "deleted", date = LocalDate.of(2026, 10, 1)),
                entity(id = "sept", date = LocalDate.of(2026, 9, 30)),
            ),
        )
        server.enqueue(MockResponse(code = 200, body = transactionsBody(LUNCH_JSON, hasMore = false)))

        repository(dao).refreshRecentTransactions(OCTOBER, limit = 5)

        assertEquals(listOf(LUNCH.id, "sept"), dao.transactions.map { it.id })
    }

    @Test
    fun `refreshRecent keeps older transactions the page did not reach`() = runTest {
        val dao = FakeTransactionDao(
            listOf(
                // Between the page's newest and oldest rows, so the page shows it is gone.
                entity(id = "deleted", date = LocalDate.of(2026, 10, 11)),
                entity(id = "older", date = LocalDate.of(2026, 10, 1)),
            ),
        )
        server.enqueue(MockResponse(code = 200, body = transactionsBody(LUNCH_JSON, TOP_UP_JSON, hasMore = true)))

        repository(dao).refreshRecentTransactions(OCTOBER, limit = 2)

        assertEquals(listOf(LUNCH.id, TOP_UP.id, "older"), dao.transactions.map { it.id })
    }

    @Test
    fun `observeRecent lists the newest transactions of the month`() = runTest {
        val dao = FakeTransactionDao(
            listOf(
                entity(id = "a", date = LocalDate.of(2026, 10, 3)),
                entity(id = "b", date = LocalDate.of(2026, 10, 12)),
                entity(id = "c", date = LocalDate.of(2026, 10, 7)),
                entity(id = "nov", date = LocalDate.of(2026, 11, 1)),
            ),
        )

        val recent = repository(dao).observeRecentTransactions(OCTOBER, limit = 2).first()

        assertEquals(listOf("b", "c"), recent.map(Transaction::id))
    }

    @Test
    fun `refreshRecent offline fails with a network error and keeps the cache`() = runTest {
        val cached = entity(id = "a", date = LocalDate.of(2026, 10, 3))
        val dao = FakeTransactionDao(listOf(cached))
        val repository = repository(dao)
        server.close()

        val result = repository.refreshRecentTransactions(OCTOBER, limit = 5)

        assertEquals(Outcome.Failure(TransactionError.Network), result)
        assertEquals(listOf(cached), dao.transactions)
    }

    @Test
    fun `refreshRecent fails as unexpected on a server error and keeps the cache`() = runTest {
        val cached = entity(id = "a", date = LocalDate.of(2026, 10, 3))
        val dao = FakeTransactionDao(listOf(cached))
        server.enqueue(
            MockResponse(
                code = 500,
                body = """{"success":false,"message":"Failed","data":null,"error":{"code":"internal_error"}}""",
            ),
        )

        val result = repository(dao).refreshRecentTransactions(OCTOBER, limit = 5)

        assertEquals(Outcome.Failure(TransactionError.Unexpected), result)
        assertEquals(listOf(cached), dao.transactions)
    }

    @Test
    fun `refreshRecent fails as unexpected when the body does not parse and keeps the cache`() = runTest {
        val cached = entity(id = "a", date = LocalDate.of(2026, 10, 3))
        val dao = FakeTransactionDao(listOf(cached))
        server.enqueue(
            MockResponse(
                code = 200,
                body = """{"success":true,"message":"OK","data":[{"id":"x"}],"meta":{"has_more":false,"limit":5}}""",
            ),
        )

        val result = repository(dao).refreshRecentTransactions(OCTOBER, limit = 5)

        assertEquals(Outcome.Failure(TransactionError.Unexpected), result)
        assertEquals(listOf(cached), dao.transactions)
    }

    @Test
    fun `refreshRecent fails as unexpected when a date does not parse and keeps the cache`() = runTest {
        val cached = entity(id = "a", date = LocalDate.of(2026, 10, 3))
        val dao = FakeTransactionDao(listOf(cached))
        val badDate = LUNCH_JSON.replace("\"2026-10-12\"", "\"12/10/2026\"")
        server.enqueue(MockResponse(code = 200, body = transactionsBody(badDate, hasMore = false)))

        val result = repository(dao).refreshRecentTransactions(OCTOBER, limit = 5)

        assertEquals(Outcome.Failure(TransactionError.Unexpected), result)
        assertEquals(listOf(cached), dao.transactions)
    }

    @Test
    fun `refreshRecent fails as unexpected and logs when the cache cannot be written`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeTransactionDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 200, body = transactionsBody(LUNCH_JSON, hasMore = false)))

        val result = repository(dao).refreshRecentTransactions(OCTOBER, limit = 5)

        assertEquals(Outcome.Failure(TransactionError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    private fun repository(dao: FakeTransactionDao): ApiTransactionRepository {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(TransactionApiService::class.java)
        return ApiTransactionRepository(
            transactionApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            transactionDao = dao,
            errorLogger = errorLogger,
        )
    }

    private fun transactionsBody(vararg transactions: String, hasMore: Boolean): String {
        val cursor = if (hasMore) "\"eyJkIjoiMjAyNi0xMC0xMCJ9\"" else "null"
        return """
            {
              "success": true,
              "message": "OK",
              "data": [${transactions.joinToString(",")}],
              "meta": {"next_cursor": $cursor, "has_more": $hasMore, "limit": ${transactions.size}}
            }
        """.trimIndent()
    }

    private fun entity(id: String, date: LocalDate) = TransactionEntity(
        id = id,
        type = TransactionType.EXPENSE,
        amount = 10_000,
        walletId = "cash",
        toWalletId = null,
        categoryId = "food",
        date = date,
        note = null,
        merchant = null,
        receiptUrl = null,
        source = TransactionSource.MANUAL,
        createdAt = CREATED_AT,
        updatedAt = CREATED_AT,
    )

    private companion object {
        val OCTOBER: YearMonth = YearMonth.of(2026, 10)
        val CREATED_AT: Instant = Instant.parse("2026-10-01T03:00:00Z")

        val LUNCH = Transaction(
            id = "8b2d4f0a-1c3e-4b5d-9f7a-0e1d2c3b4a59",
            type = TransactionType.EXPENSE,
            amount = 35_000,
            walletId = "5f3c9a1e-8b2d-4c7a-9e1f-2a6b8c4d0e17",
            toWalletId = null,
            categoryId = "0c9e8d7b-6a5f-4e3d-8c2b-1a0f9e8d7c6b",
            date = LocalDate.of(2026, 10, 12),
            note = "Makan siang",
            merchant = "Warteg Bahari",
            receiptUrl = "https://cdn.example.com/receipts/lunch.jpg",
            source = TransactionSource.QUICK_ADD,
            createdAt = Instant.parse("2026-10-12T05:12:00Z"),
            updatedAt = Instant.parse("2026-10-12T05:20:00Z"),
        )

        val TOP_UP = Transaction(
            id = "1a2b3c4d-5e6f-4a7b-8c9d-0e1f2a3b4c5d",
            type = TransactionType.TRANSFER,
            amount = 500_000,
            walletId = "5f3c9a1e-8b2d-4c7a-9e1f-2a6b8c4d0e17",
            toWalletId = "9a8b7c6d-5e4f-4a3b-2c1d-0e9f8a7b6c5d",
            categoryId = null,
            date = LocalDate.of(2026, 10, 10),
            note = null,
            merchant = null,
            receiptUrl = null,
            source = TransactionSource.MANUAL,
            createdAt = CREATED_AT,
            updatedAt = CREATED_AT,
        )

        val LUNCH_JSON = """
            {
              "id": "8b2d4f0a-1c3e-4b5d-9f7a-0e1d2c3b4a59",
              "type": "EXPENSE",
              "amount": 35000,
              "wallet_id": "5f3c9a1e-8b2d-4c7a-9e1f-2a6b8c4d0e17",
              "to_wallet_id": null,
              "category_id": "0c9e8d7b-6a5f-4e3d-8c2b-1a0f9e8d7c6b",
              "date": "2026-10-12",
              "note": "Makan siang",
              "merchant": "Warteg Bahari",
              "receipt_url": "https://cdn.example.com/receipts/lunch.jpg",
              "source": "QUICK_ADD",
              "created_at": "2026-10-12T05:12:00Z",
              "updated_at": "2026-10-12T05:20:00Z"
            }
        """.trimIndent()

        val TOP_UP_JSON = """
            {
              "id": "1a2b3c4d-5e6f-4a7b-8c9d-0e1f2a3b4c5d",
              "type": "TRANSFER",
              "amount": 500000,
              "wallet_id": "5f3c9a1e-8b2d-4c7a-9e1f-2a6b8c4d0e17",
              "to_wallet_id": "9a8b7c6d-5e4f-4a3b-2c1d-0e9f8a7b6c5d",
              "category_id": null,
              "date": "2026-10-10",
              "note": null,
              "merchant": null,
              "receipt_url": null,
              "source": "MANUAL",
              "created_at": "2026-10-01T03:00:00Z",
              "updated_at": "2026-10-01T03:00:00Z"
            }
        """.trimIndent()
    }
}
