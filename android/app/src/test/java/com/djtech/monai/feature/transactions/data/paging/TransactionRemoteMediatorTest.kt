package com.djtech.monai.feature.transactions.data.paging

import androidx.paging.ExperimentalPagingApi
import androidx.paging.LoadType
import androidx.paging.PagingConfig
import androidx.paging.PagingState
import androidx.paging.RemoteMediator.MediatorResult
import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.database.FakeTransactionDao
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.TransactionRemoteKeyEntity
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.transactions.data.remote.TransactionApiService
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.model.TransactionLoadException
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
import java.time.LocalDate
import java.time.YearMonth

@OptIn(ExperimentalPagingApi::class)
class TransactionRemoteMediatorTest {

    private val server = MockWebServer()
    private val clock = FixedAppClock(Instant.parse("2026-10-12T06:00:00Z"))

    @Before
    fun setUp() {
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
    }

    @Test
    fun `refresh fetches the first page with the filters and replaces only the rows the list shows`() = runTest {
        val dao = FakeTransactionDao(
            listOf(
                entity("stale-bca", walletId = "bca"),
                entity("other-wallet", walletId = "gopay"),
                entity("september-bca", walletId = "bca", date = LocalDate.of(2026, 9, 30)),
            ),
        )
        server.enqueue(MockResponse(code = 200, body = page(json("fresh"), nextCursor = "c2")))

        val result = mediator(dao, BCA).load(LoadType.REFRESH, emptyState())

        assertEquals(false, (result as MediatorResult.Success).endOfPaginationReached)
        val url = server.takeRequest().url
        assertEquals("2026-10", url.queryParameter("month"))
        assertEquals("20", url.queryParameter("limit"))
        assertEquals("bca", url.queryParameter("wallet_id"))
        assertEquals("EXPENSE", url.queryParameter("type"))
        assertEquals(null, url.queryParameter("cursor"))
        assertEquals(listOf("other-wallet", "fresh", "september-bca"), dao.transactions.map { it.id })
        assertEquals(
            TransactionRemoteKeyEntity("2026-10|bca||EXPENSE", "c2", clock.instant),
            dao.remoteKeys.values.single(),
        )
    }

    @Test
    fun `append continues from the saved cursor`() = runTest {
        val dao = FakeTransactionDao()
        dao.remoteKeys[KEY] = TransactionRemoteKeyEntity(KEY, "c2", clock.instant)
        server.enqueue(MockResponse(code = 200, body = page(json("older"), nextCursor = null)))

        val result = mediator(dao, BCA).load(LoadType.APPEND, emptyState())

        assertEquals(true, (result as MediatorResult.Success).endOfPaginationReached)
        assertEquals("c2", server.takeRequest().url.queryParameter("cursor"))
        assertEquals(listOf("older"), dao.transactions.map { it.id })
        assertEquals(null, dao.remoteKeys.getValue(KEY).nextCursor)
    }

    @Test
    fun `append after the last page ends without a request`() = runTest {
        val dao = FakeTransactionDao()
        dao.remoteKeys[KEY] = TransactionRemoteKeyEntity(KEY, null, clock.instant)

        val result = mediator(dao, BCA).load(LoadType.APPEND, emptyState())

        assertEquals(true, (result as MediatorResult.Success).endOfPaginationReached)
        assertEquals(0, server.requestCount)
    }

    @Test
    fun `prepend ends at once because the list starts at the newest`() = runTest {
        val result = mediator(FakeTransactionDao(), BCA).load(LoadType.PREPEND, emptyState())

        assertTrue((result as MediatorResult.Success).endOfPaginationReached)
    }

    @Test
    fun `refresh offline fails with a network error and keeps the cache`() = runTest {
        val cached = entity("cached", walletId = "bca")
        val dao = FakeTransactionDao(listOf(cached))
        val mediator = mediator(dao, BCA)
        server.close()

        val result = mediator.load(LoadType.REFRESH, emptyState())

        val error = (result as MediatorResult.Error).throwable as TransactionLoadException
        assertEquals(TransactionError.Network, error.error)
        assertEquals(listOf(cached), dao.transactions)
    }

    private fun mediator(dao: FakeTransactionDao, filter: TransactionFilter): TransactionRemoteMediator {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(TransactionApiService::class.java)
        val logger = RecordingErrorLogger()
        return TransactionRemoteMediator(
            OCTOBER,
            filter,
            api,
            ApiCaller(ApiErrorMapper(NetworkJson), logger),
            dao,
            clock,
            logger,
        )
    }

    private fun emptyState() = PagingState<Int, TransactionEntity>(
        pages = emptyList(),
        anchorPosition = null,
        config = PagingConfig(pageSize = 20),
        leadingPlaceholderCount = 0,
    )

    private fun entity(id: String, walletId: String, date: LocalDate = LocalDate.of(2026, 10, 5)) =
        transaction(id, date = date, walletId = walletId).asEntity()

    private fun json(id: String) = """
        {"id":"$id","type":"EXPENSE","amount":10000,"wallet_id":"bca","category_id":"food","date":"2026-10-05",
         "source":"MANUAL","created_at":"2026-10-05T03:00:00Z","updated_at":"2026-10-05T03:00:00Z"}
    """.trimIndent()

    private fun page(vararg transactions: String, nextCursor: String?): String {
        val cursor = nextCursor?.let { "\"$it\"" } ?: "null"
        return """{"success":true,"message":"OK","data":[${transactions.joinToString(",")}],""" +
            """"meta":{"next_cursor":$cursor,"has_more":${nextCursor != null},"limit":20}}"""
    }

    private companion object {
        val OCTOBER: YearMonth = YearMonth.of(2026, 10)
        val BCA = TransactionFilter(walletId = "bca", type = TransactionType.EXPENSE)
        const val KEY = "2026-10|bca||EXPENSE"
    }
}
