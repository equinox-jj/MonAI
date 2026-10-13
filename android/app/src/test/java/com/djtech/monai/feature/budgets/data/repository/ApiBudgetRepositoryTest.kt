package com.djtech.monai.feature.budgets.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.FakeBudgetDao
import com.djtech.monai.core.database.entity.BudgetEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.budgets.data.remote.BudgetApiService
import com.djtech.monai.feature.budgets.domain.model.BudgetError
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

class ApiBudgetRepositoryTest {

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
    fun `refreshBudget asks for the month and caches every field`() = runTest {
        val dao = FakeBudgetDao()
        server.enqueue(MockResponse(code = 200, body = budgetBody(OCTOBER_JSON)))

        val result = repository(dao).refreshBudget(OCTOBER)

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("GET", request.method)
        assertEquals("/api/v1/budgets/2026-10", request.url.encodedPath)
        assertEquals(listOf(OCTOBER_BUDGET), dao.budgets.map(BudgetEntity::asModel))
    }

    @Test
    fun `refreshBudget for a month without a budget clears it and succeeds`() = runTest {
        val september = entity(YearMonth.of(2026, 9))
        val dao = FakeBudgetDao(listOf(entity(OCTOBER), september))
        server.enqueue(errorResponse(status = 404, code = "not_found"))

        val result = repository(dao).refreshBudget(OCTOBER)

        assertEquals(Outcome.Success(Unit), result)
        assertEquals(listOf(september), dao.budgets)
    }

    @Test
    fun `observeBudget emits the cached budget of that month only`() = runTest {
        val dao = FakeBudgetDao(listOf(entity(OCTOBER)))
        val repository = repository(dao)

        assertEquals(OCTOBER, repository.observeBudget(OCTOBER).first()?.month)
        assertNull(repository.observeBudget(YearMonth.of(2026, 11)).first())
    }

    @Test
    fun `refreshBudget offline fails with a network error and keeps the cache`() = runTest {
        val cached = entity(OCTOBER)
        val dao = FakeBudgetDao(listOf(cached))
        val repository = repository(dao)
        server.close()

        val result = repository.refreshBudget(OCTOBER)

        assertEquals(Outcome.Failure(BudgetError.Network), result)
        assertEquals(listOf(cached), dao.budgets)
    }

    @Test
    fun `refreshBudget fails as unexpected on a server error and keeps the cache`() = runTest {
        val cached = entity(OCTOBER)
        val dao = FakeBudgetDao(listOf(cached))
        server.enqueue(errorResponse(status = 500, code = "internal_error"))

        val result = repository(dao).refreshBudget(OCTOBER)

        assertEquals(Outcome.Failure(BudgetError.Unexpected), result)
        assertEquals(listOf(cached), dao.budgets)
    }

    @Test
    fun `refreshBudget fails as unexpected when the body does not parse and keeps the cache`() = runTest {
        val cached = entity(OCTOBER)
        val dao = FakeBudgetDao(listOf(cached))
        server.enqueue(MockResponse(code = 200, body = budgetBody("""{"month":"2026-10"}""")))

        val result = repository(dao).refreshBudget(OCTOBER)

        assertEquals(Outcome.Failure(BudgetError.Unexpected), result)
        assertEquals(listOf(cached), dao.budgets)
    }

    @Test
    fun `refreshBudget fails as unexpected when the month does not parse and keeps the cache`() = runTest {
        val cached = entity(OCTOBER)
        val dao = FakeBudgetDao(listOf(cached))
        server.enqueue(MockResponse(code = 200, body = budgetBody(OCTOBER_JSON.replace("2026-10", "Oct"))))

        val result = repository(dao).refreshBudget(OCTOBER)

        assertEquals(Outcome.Failure(BudgetError.Unexpected), result)
        assertEquals(listOf(cached), dao.budgets)
    }

    @Test
    fun `refreshBudget fails as unexpected and logs when the budget cannot be cached`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeBudgetDao().apply { this.failure = failure }
        server.enqueue(MockResponse(code = 200, body = budgetBody(OCTOBER_JSON)))

        val result = repository(dao).refreshBudget(OCTOBER)

        assertEquals(Outcome.Failure(BudgetError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    @Test
    fun `refreshBudget fails as unexpected and logs when a removed budget cannot be cleared`() = runTest {
        val failure = IOException("disk full")
        val dao = FakeBudgetDao(listOf(entity(OCTOBER))).apply { this.failure = failure }
        server.enqueue(errorResponse(status = 404, code = "not_found"))

        val result = repository(dao).refreshBudget(OCTOBER)

        assertEquals(Outcome.Failure(BudgetError.Unexpected), result)
        assertSame(failure, errorLogger.errors.single())
    }

    @Test
    fun `setBudget puts the limit for the month and caches the returned budget`() = runTest {
        val dao = FakeBudgetDao()
        server.enqueue(MockResponse(code = 200, body = budgetBody(OCTOBER_JSON)))

        val result = repository(dao).setBudget(OCTOBER, 3_000_000)

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("PUT", request.method)
        assertEquals("/api/v1/budgets/2026-10", request.url.encodedPath)
        assertEquals("""{"limit_amount":3000000}""", request.body?.utf8())
        assertEquals(listOf(OCTOBER_BUDGET), dao.budgets.map(BudgetEntity::asModel))
    }

    @Test
    fun `setBudget fails with an invalid limit when the server rejects the amount`() = runTest {
        val dao = FakeBudgetDao()
        server.enqueue(
            MockResponse(
                code = 422,
                body = """{"success":false,"message":"Failed","data":null,"error":{"code":"validation_failed",""" +
                    """"fields":[{"field":"limit_amount","code":"min","message":"Too small"}]}}""",
            ),
        )

        val result = repository(dao).setBudget(OCTOBER, 3_000_000)

        assertEquals(Outcome.Failure(BudgetError.InvalidLimit), result)
        assertEquals(emptyList<BudgetEntity>(), dao.budgets)
    }

    @Test
    fun `setBudget offline fails with a network error and keeps the cache`() = runTest {
        val cached = entity(OCTOBER)
        val dao = FakeBudgetDao(listOf(cached))
        val repository = repository(dao)
        server.close()

        val result = repository.setBudget(OCTOBER, 3_000_000)

        assertEquals(Outcome.Failure(BudgetError.Network), result)
        assertEquals(listOf(cached), dao.budgets)
    }

    @Test
    fun `deleteBudget deletes the month and clears its cached budget`() = runTest {
        val september = entity(YearMonth.of(2026, 9))
        val dao = FakeBudgetDao(listOf(entity(OCTOBER), september))
        server.enqueue(MockResponse(code = 200, body = """{"success":true,"message":"Deleted","data":null}"""))

        val result = repository(dao).deleteBudget(OCTOBER)

        assertEquals(Outcome.Success(Unit), result)
        val request = server.takeRequest()
        assertEquals("DELETE", request.method)
        assertEquals("/api/v1/budgets/2026-10", request.url.encodedPath)
        assertEquals(listOf(september), dao.budgets)
    }

    @Test
    fun `deleteBudget of a budget already gone clears the cache and succeeds`() = runTest {
        val dao = FakeBudgetDao(listOf(entity(OCTOBER)))
        server.enqueue(errorResponse(status = 404, code = "not_found"))

        val result = repository(dao).deleteBudget(OCTOBER)

        assertEquals(Outcome.Success(Unit), result)
        assertEquals(emptyList<BudgetEntity>(), dao.budgets)
    }

    @Test
    fun `deleteBudget offline fails with a network error and keeps the cache`() = runTest {
        val cached = entity(OCTOBER)
        val dao = FakeBudgetDao(listOf(cached))
        val repository = repository(dao)
        server.close()

        val result = repository.deleteBudget(OCTOBER)

        assertEquals(Outcome.Failure(BudgetError.Network), result)
        assertEquals(listOf(cached), dao.budgets)
    }

    private fun repository(dao: FakeBudgetDao): ApiBudgetRepository {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(BudgetApiService::class.java)
        return ApiBudgetRepository(
            budgetApiService = api,
            apiCaller = ApiCaller(ApiErrorMapper(NetworkJson), errorLogger),
            budgetDao = dao,
            errorLogger = errorLogger,
        )
    }

    private fun budgetBody(budget: String) = """{"success":true,"message":"OK","data":$budget}"""

    private fun errorResponse(status: Int, code: String) = MockResponse(
        code = status,
        body = """{"success":false,"message":"Failed","data":null,"error":{"code":"$code"}}""",
    )

    private fun entity(month: YearMonth) = BudgetEntity(
        month = month,
        limitAmount = 1_000_000,
        spent = 0,
        remaining = 1_000_000,
        progressPercent = 0.0,
        status = BudgetStatus.OK,
    )

    private companion object {
        val OCTOBER: YearMonth = YearMonth.of(2026, 10)

        val OCTOBER_BUDGET = Budget(
            month = OCTOBER,
            limitAmount = 3_000_000,
            spent = 3_150_000,
            remaining = -150_000,
            progressPercent = 105.0,
            status = BudgetStatus.EXCEEDED,
        )

        val OCTOBER_JSON = """
            {
              "month": "2026-10",
              "limit_amount": 3000000,
              "spent": 3150000,
              "remaining": -150000,
              "progress_percent": 105.0,
              "status": "EXCEEDED"
            }
        """.trimIndent()
    }
}
