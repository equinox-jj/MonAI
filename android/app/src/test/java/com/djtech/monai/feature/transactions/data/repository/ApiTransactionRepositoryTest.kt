package com.djtech.monai.feature.transactions.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import androidx.paging.testing.asSnapshot
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.database.FakeTransactionDao
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.transactions.data.remote.TransactionApiService
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.UnconfinedTestDispatcher
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

    @Test
    fun `observeDailyNets sums each day's income minus expenses, ignoring transfers`() = runTest {
        val dao = FakeTransactionDao(
            listOf(
                entity(id = "lunch", date = LocalDate.of(2026, 10, 5)),
                entity(id = "salary", date = LocalDate.of(2026, 10, 5))
                    .copy(type = TransactionType.INCOME, amount = 50_000),
                entity(id = "top-up", date = LocalDate.of(2026, 10, 5)).copy(type = TransactionType.TRANSFER),
                entity(id = "coffee", date = LocalDate.of(2026, 10, 6)),
                entity(id = "sept", date = LocalDate.of(2026, 9, 30)),
            ),
        )

        val nets = repository(dao).observeDailyNets(OCTOBER, TransactionFilter()).first()

        assertEquals(mapOf(LocalDate.of(2026, 10, 5) to 40_000L, LocalDate.of(2026, 10, 6) to -10_000L), nets)
    }

    @Test
    fun `observeDailyOutflows sums each day's expenses and transfers out of the wallet`() = runTest {
        val dao = FakeTransactionDao(
            listOf(
                entity(id = "lunch", date = LocalDate.of(2026, 10, 5)),
                entity(id = "top-up", date = LocalDate.of(2026, 10, 5))
                    .copy(type = TransactionType.TRANSFER, amount = 500_000, toWalletId = "gopay", categoryId = null),
                entity(id = "salary", date = LocalDate.of(2026, 10, 5)).copy(type = TransactionType.INCOME),
                entity(id = "received", date = LocalDate.of(2026, 10, 6))
                    .copy(type = TransactionType.TRANSFER, walletId = "bca", toWalletId = "cash", categoryId = null),
                entity(id = "other-wallet", date = LocalDate.of(2026, 10, 6)).copy(walletId = "bca"),
                entity(id = "sept", date = LocalDate.of(2026, 9, 30)),
            ),
        )

        val outflows = repository(dao).observeDailyOutflows(OCTOBER, walletId = "cash").first()

        assertEquals(mapOf(LocalDate.of(2026, 10, 5) to 510_000L), outflows)
    }

    @Test
    fun `createTransaction posts the input and caches what the server returns`() = runTest {
        val dao = FakeTransactionDao()
        server.enqueue(MockResponse(code = 201, body = envelope(LUNCH_JSON)))

        val result = repository(dao).createTransaction(
            TransactionInput(
                type = TransactionType.EXPENSE,
                amount = 35_000,
                walletId = "w1",
                toWalletId = null,
                categoryId = "c1",
                date = LocalDate.of(2026, 10, 12),
                note = "Makan siang",
            ),
        )

        assertEquals(Outcome.Success(LUNCH), result)
        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals("/api/v1/transactions", request.url.encodedPath)
        assertEquals(
            """{"type":"EXPENSE","amount":35000,"wallet_id":"w1","category_id":"c1","date":"2026-10-12",""" +
                """"note":"Makan siang","source":"MANUAL"}""",
            request.body?.utf8(),
        )
        assertEquals(listOf(LUNCH), dao.transactions.map { it.asModel() })
    }

    @Test
    fun `createTransaction maps the server's field errors`() = runTest {
        server.enqueue(
            MockResponse(
                code = 422,
                body = """
                    {"success":false,"message":"Invalid","data":null,"error":{"code":"validation_failed","fields":[
                      {"field":"date","code":"future_date","message":"must not be in the future"},
                      {"field":"to_wallet_id","code":"not_equal","message":"must differ",
                       "params":{"other":"wallet_id"}},
                      {"field":"category_id","code":"something_new","message":"?"}
                    ]}}
                """.trimIndent(),
            ),
        )

        val result = repository(FakeTransactionDao()).createTransaction(TRANSFER_INPUT)

        assertEquals(
            Outcome.Failure(
                TransactionError.InvalidFields(
                    listOf(
                        TransactionFieldError(TransactionField.DATE, TransactionFieldIssue.FUTURE_DATE),
                        TransactionFieldError(TransactionField.TO_WALLET, TransactionFieldIssue.SAME_WALLET),
                        TransactionFieldError(TransactionField.CATEGORY, TransactionFieldIssue.INVALID),
                    ),
                ),
            ),
            result,
        )
    }

    @Test
    fun `createTransaction still succeeds and logs when the cache cannot be written`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeTransactionDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 201, body = envelope(LUNCH_JSON)))

        val result = repository(dao).createTransaction(TRANSFER_INPUT)

        assertEquals(Outcome.Success(LUNCH), result)
        assertSame(failure, errorLogger.errors.single())
    }

    @Test
    fun `updateTransaction patches every field and sends nulls so cleared fields are cleared`() = runTest {
        val dao = FakeTransactionDao()
        server.enqueue(MockResponse(code = 200, body = envelope(TOP_UP_JSON)))

        val result = repository(dao).updateTransaction(TOP_UP.id, TRANSFER_INPUT)

        assertEquals(Outcome.Success(TOP_UP), result)
        val request = server.takeRequest()
        assertEquals("PATCH", request.method)
        assertEquals("/api/v1/transactions/${TOP_UP.id}", request.url.encodedPath)
        assertEquals("application/json", request.headers["Content-Type"]?.substringBefore(';'))
        assertEquals(
            """{"type":"TRANSFER","amount":500000,"wallet_id":"bca","to_wallet_id":"gopay","category_id":null,""" +
                """"date":"2026-10-10","note":null,"merchant":null}""",
            request.body?.utf8(),
        )
        assertEquals(listOf(TOP_UP), dao.transactions.map { it.asModel() })
    }

    @Test
    fun `deleteTransaction drops it from the cache and announces it for undo`() = runTest {
        val dao = FakeTransactionDao(listOf(LUNCH.asEntity()))
        val repository = repository(dao)
        val deleted = mutableListOf<Transaction>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { repository.deletions.toList(deleted) }
        server.enqueue(MockResponse(code = 200, body = DELETED_BODY))

        val result = repository.deleteTransaction(LUNCH.id)

        assertEquals(Outcome.Success(LUNCH), result)
        val request = server.takeRequest()
        assertEquals("DELETE", request.method)
        assertEquals("/api/v1/transactions/${LUNCH.id}", request.url.encodedPath)
        assertEquals(emptyList<TransactionEntity>(), dao.transactions)
        assertEquals(listOf(LUNCH), deleted)
    }

    @Test
    fun `deleteTransaction treats one the server no longer has as deleted`() = runTest {
        val dao = FakeTransactionDao(listOf(LUNCH.asEntity()))
        server.enqueue(MockResponse(code = 404, body = errorBody("not_found")))

        val result = repository(dao).deleteTransaction(LUNCH.id)

        assertEquals(Outcome.Success(LUNCH), result)
        assertEquals(emptyList<TransactionEntity>(), dao.transactions)
    }

    @Test
    fun `deleteTransaction offline fails and keeps the cache`() = runTest {
        val dao = FakeTransactionDao(listOf(LUNCH.asEntity()))
        val repository = repository(dao)
        server.close()

        val result = repository.deleteTransaction(LUNCH.id)

        assertEquals(Outcome.Failure(TransactionError.Network), result)
        assertEquals(listOf(LUNCH), dao.transactions.map { it.asModel() })
    }

    @Test
    fun `restoreTransaction caches the restored transaction`() = runTest {
        val dao = FakeTransactionDao()
        server.enqueue(MockResponse(code = 200, body = envelope(LUNCH_JSON)))

        val result = repository(dao).restoreTransaction(LUNCH.id)

        assertEquals(Outcome.Success(LUNCH), result)
        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals("/api/v1/transactions/${LUNCH.id}/restore", request.url.encodedPath)
        assertEquals(listOf(LUNCH), dao.transactions.map { it.asModel() })
    }

    @Test
    fun `restoreTransaction fails as wallet archived when a wallet was archived after the delete`() = runTest {
        server.enqueue(MockResponse(code = 422, body = errorBody("wallet_archived")))

        val result = repository(FakeTransactionDao()).restoreTransaction(LUNCH.id)

        assertEquals(Outcome.Failure(TransactionError.WalletArchived), result)
    }

    @Test
    fun `refreshTransaction caches the transaction`() = runTest {
        val dao = FakeTransactionDao()
        server.enqueue(MockResponse(code = 200, body = envelope(LUNCH_JSON)))

        val result = repository(dao).refreshTransaction(LUNCH.id)

        assertEquals(Outcome.Success(Unit), result)
        assertEquals("/api/v1/transactions/${LUNCH.id}", server.takeRequest().url.encodedPath)
        assertEquals(LUNCH, repository(dao).observeTransaction(LUNCH.id).first())
    }

    @Test
    fun `refreshTransaction drops a transaction the server no longer has`() = runTest {
        val dao = FakeTransactionDao(listOf(LUNCH.asEntity()))
        server.enqueue(MockResponse(code = 404, body = errorBody("not_found")))

        val result = repository(dao).refreshTransaction(LUNCH.id)

        assertEquals(Outcome.Failure(TransactionError.NotFound), result)
        assertEquals(emptyList<TransactionEntity>(), dao.transactions)
    }

    @Test
    fun `searchTransactions pages the month's matches from the API with the filters and caches them`() = runTest {
        val dao = FakeTransactionDao()
        server.enqueue(MockResponse(code = 200, body = transactionsBody(LUNCH_JSON, hasMore = true)))
        server.enqueue(MockResponse(code = 200, body = transactionsBody(TOP_UP_JSON, hasMore = false)))
        val filter = TransactionFilter(walletId = "w1", type = TransactionType.EXPENSE)

        val results = repository(dao).searchTransactions("makan", OCTOBER, filter).asSnapshot {
            scrollTo(index = 1)
        }

        assertEquals(listOf(LUNCH, TOP_UP), results)
        val first = server.takeRequest().url
        assertEquals("makan", first.queryParameter("q"))
        assertEquals("2026-10", first.queryParameter("month"))
        assertEquals("w1", first.queryParameter("wallet_id"))
        assertEquals("EXPENSE", first.queryParameter("type"))
        assertEquals(null, first.queryParameter("category_id"))
        assertEquals(null, first.queryParameter("cursor"))
        assertEquals("eyJkIjoiMjAyNi0xMC0xMCJ9", server.takeRequest().url.queryParameter("cursor"))
        assertEquals(listOf(LUNCH, TOP_UP), dao.transactions.map { it.asModel() })
    }

    @Test
    fun `searchCachedTransactions finds nothing without searchable words`() = runTest {
        val results = repository(FakeTransactionDao())
            .searchCachedTransactions(" -* ", TransactionFilter())
            .asSnapshot()

        assertEquals(emptyList<Transaction>(), results)
    }

    private fun envelope(data: String) = """{"success":true,"message":"OK","data":$data}"""

    private fun errorBody(code: String) =
        """{"success":false,"message":"Failed","data":null,"error":{"code":"$code"}}"""

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
            clock = FixedAppClock(Instant.parse("2026-10-12T06:00:00Z")),
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

        const val DELETED_BODY = """{"success":true,"message":"Deleted successfully.","data":null}"""

        val TRANSFER_INPUT = TransactionInput(
            type = TransactionType.TRANSFER,
            amount = 500_000,
            walletId = "bca",
            toWalletId = "gopay",
            categoryId = null,
            date = LocalDate.of(2026, 10, 10),
            note = null,
        )

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
