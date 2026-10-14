package com.djtech.monai.feature.reports.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakeMonthlyReportDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.categoryEntities
import com.djtech.monai.core.model.CategoryBreakdown
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.core.model.PreviousMonthTotals
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.reports.data.remote.ReportApiService
import com.djtech.monai.feature.reports.domain.model.ReportError
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
import java.time.YearMonth

class ReportRepositoryImplTest {

    private val errorLogger = RecordingErrorLogger()
    private val server = MockWebServer()
    private val dao = FakeMonthlyReportDao()

    @Before
    fun setUp() {
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
    }

    @Test
    fun `refresh asks for the month and caches the whole report in the server's order`() = runTest {
        server.enqueue(MockResponse(code = 200, body = reportBody(OCTOBER_JSON)))
        val repository = repository()

        val result = repository.refreshMonthlyReport(OCTOBER)

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("GET", request.method)
        assertEquals("/api/v1/reports/monthly", request.url.encodedPath)
        assertEquals("2026-10", request.url.queryParameter("month"))
        assertEquals(OCTOBER_REPORT, repository.observeMonthlyReport(OCTOBER).first())
    }

    @Test
    fun `refresh replaces the month's breakdown`() = runTest {
        cache(OCTOBER_REPORT.copy(categories = OCTOBER_REPORT.categories + STALE_CATEGORY))
        server.enqueue(MockResponse(code = 200, body = reportBody(OCTOBER_JSON)))
        val repository = repository()

        repository.refreshMonthlyReport(OCTOBER)

        assertEquals(OCTOBER_REPORT.categories, repository.observeMonthlyReport(OCTOBER).first()?.categories)
    }

    @Test
    fun `observeMonthlyReport emits null for a month that isn't cached`() = runTest {
        cache(OCTOBER_REPORT)

        assertNull(repository().observeMonthlyReport(YearMonth.of(2026, 9)).first())
    }

    @Test
    fun `observeCachedExpenseTotals lists the year's cached months only`() = runTest {
        cache(OCTOBER_REPORT)
        cache(OCTOBER_REPORT.copy(month = YearMonth.of(2026, 3), expenseTotal = 1_900_000))
        cache(OCTOBER_REPORT.copy(month = YearMonth.of(2025, 12), expenseTotal = 1_800_000))

        val totals = repository().observeCachedExpenseTotals(2026).first()

        assertEquals(
            mapOf(YearMonth.of(2026, 3) to 1_900_000L, OCTOBER to OCTOBER_REPORT.expenseTotal),
            totals,
        )
    }

    @Test
    fun `refresh offline fails with a network error and keeps the cache`() = runTest {
        cache(OCTOBER_REPORT)
        val repository = repository()
        server.close()

        val result = repository.refreshMonthlyReport(OCTOBER)

        assertEquals(Outcome.Failure(ReportError.Network), result)
        assertEquals(OCTOBER_REPORT, repository.observeMonthlyReport(OCTOBER).first())
    }

    @Test
    fun `refresh fails as unexpected on a server error and keeps the cache`() = runTest {
        cache(OCTOBER_REPORT)
        server.enqueue(
            MockResponse(
                code = 500,
                body = """{"success":false,"message":"Failed","data":null,"error":{"code":"internal_error"}}""",
            ),
        )
        val repository = repository()

        val result = repository.refreshMonthlyReport(OCTOBER)

        assertEquals(Outcome.Failure(ReportError.Unexpected), result)
        assertEquals(OCTOBER_REPORT, repository.observeMonthlyReport(OCTOBER).first())
    }

    @Test
    fun `refresh fails as unexpected when the body does not parse and keeps the cache`() = runTest {
        cache(OCTOBER_REPORT)
        server.enqueue(MockResponse(code = 200, body = reportBody("""{"month":"2026-10"}""")))
        val repository = repository()

        val result = repository.refreshMonthlyReport(OCTOBER)

        assertEquals(Outcome.Failure(ReportError.Unexpected), result)
        assertEquals(OCTOBER_REPORT, repository.observeMonthlyReport(OCTOBER).first())
    }

    @Test
    fun `refresh fails as unexpected when a month does not parse and keeps the cache`() = runTest {
        cache(OCTOBER_REPORT)
        server.enqueue(MockResponse(code = 200, body = reportBody(OCTOBER_JSON.replace("\"2026-09\"", "\"Sept\""))))
        val repository = repository()

        val result = repository.refreshMonthlyReport(OCTOBER)

        assertEquals(Outcome.Failure(ReportError.Unexpected), result)
        assertEquals(OCTOBER_REPORT, repository.observeMonthlyReport(OCTOBER).first())
    }

    @Test
    fun `refresh fails as unexpected and logs when the cache cannot be written`() = runTest {
        val failure = IOException("disk full")
        dao.failure = failure
        server.enqueue(MockResponse(code = 200, body = reportBody(OCTOBER_JSON)))

        val result = repository().refreshMonthlyReport(OCTOBER)

        assertEquals(Outcome.Failure(ReportError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    private suspend fun cache(report: MonthlyReport) {
        dao.replace(report.asEntity(), report.categoryEntities())
    }

    private fun repository(): ReportRepositoryImpl {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(ReportApiService::class.java)
        return ReportRepositoryImpl(
            reportApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            monthlyReportDao = dao,
            errorLogger = errorLogger,
        )
    }

    private fun reportBody(report: String) = """{"success":true,"message":"OK","data":$report}"""

    private companion object {
        val OCTOBER: YearMonth = YearMonth.of(2026, 10)

        val OCTOBER_REPORT = MonthlyReport(
            month = OCTOBER,
            incomeTotal = 8_500_000,
            expenseTotal = 2_415_000,
            net = 6_085_000,
            previous = PreviousMonthTotals(
                month = YearMonth.of(2026, 9),
                incomeTotal = 8_500_000,
                expenseTotal = 2_683_000,
            ),
            expenseChangePercent = -9.99,
            categories = listOf(
                CategoryBreakdown(
                    categoryId = "food",
                    name = "Food",
                    icon = "restaurant",
                    color = "#F97316",
                    amount = 870_000,
                    sharePercent = 36.02,
                    previousAmount = 900_000,
                    changePercent = -3.33,
                ),
                CategoryBreakdown(
                    categoryId = "bills",
                    name = "Bills",
                    icon = null,
                    color = null,
                    amount = 604_000,
                    sharePercent = 25.01,
                    previousAmount = 0,
                    changePercent = null,
                ),
            ),
        )

        val STALE_CATEGORY = CategoryBreakdown(
            categoryId = "deleted",
            name = "Deleted",
            icon = null,
            color = null,
            amount = 1,
            sharePercent = 0.0,
            previousAmount = 0,
            changePercent = null,
        )

        val OCTOBER_JSON = """
            {
              "month": "2026-10",
              "income_total": 8500000,
              "expense_total": 2415000,
              "net": 6085000,
              "previous": {"month": "2026-09", "income_total": 8500000, "expense_total": 2683000},
              "expense_change_percent": -9.99,
              "categories": [
                {
                  "category_id": "food",
                  "name": "Food",
                  "icon": "restaurant",
                  "color": "#F97316",
                  "amount": 870000,
                  "share_percent": 36.02,
                  "previous_amount": 900000,
                  "change_percent": -3.33
                },
                {
                  "category_id": "bills",
                  "name": "Bills",
                  "icon": null,
                  "color": null,
                  "amount": 604000,
                  "share_percent": 25.01,
                  "previous_amount": 0,
                  "change_percent": null
                }
              ]
            }
        """.trimIndent()
    }
}
