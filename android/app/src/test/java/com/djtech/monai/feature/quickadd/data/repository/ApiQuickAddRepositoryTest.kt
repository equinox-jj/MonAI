package com.djtech.monai.feature.quickadd.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.draftConfidence
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.quickadd.data.remote.QuickAddApiService
import com.djtech.monai.feature.quickadd.domain.model.QuickAddError
import kotlinx.coroutines.test.runTest
import mockwebserver3.MockResponse
import mockwebserver3.MockWebServer
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import java.time.LocalDate
import java.time.ZoneId

class ApiQuickAddRepositoryTest {

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
    fun `parse sends the text with today and the timezone and maps the drafts`() = runTest {
        server.enqueue(
            MockResponse(
                code = 200,
                body = """
                    {"success":true,"message":"Drafts generated successfully.","data":{"drafts":[
                      {"type":"EXPENSE","amount":35000,"wallet_id":"bca","to_wallet_id":null,"category_id":"food",
                       "date":"2026-10-10","note":"Makan siang","merchant":null,
                       "confidence":{"type":0.95,"amount":0.95,"wallet":0.95,"category":0.95,"date":0.95}},
                      {"type":null,"amount":null,"wallet_id":null,"to_wallet_id":null,"category_id":null,
                       "date":null,"note":"Parkir","merchant":null,"confidence":{"amount":0.2}}
                    ]}}
                """.trimIndent(),
            ),
        )

        val result = repository().parse("makan siang 35rb", LocalDate.of(2026, 10, 10), ZoneId.of("Asia/Jakarta"))

        assertEquals(
            Outcome.Success(
                listOf(
                    draft(),
                    draft(
                        amount = null,
                        type = null,
                        walletId = null,
                        categoryId = null,
                        date = null,
                        note = "Parkir",
                        confidence = draftConfidence(sure = 0.0, amount = 0.2),
                    ),
                ),
            ),
            result,
        )
        val request = server.takeRequest()
        assertEquals("POST", request.method)
        assertEquals("/api/v1/ai/parse-transaction", request.url.encodedPath)
        assertEquals(
            """{"text":"makan siang 35rb","today":"2026-10-10","timezone":"Asia/Jakarta"}""",
            request.body?.utf8(),
        )
    }

    @Test
    fun `maps the rate limit and an unavailable AI`() = runTest {
        server.enqueue(MockResponse(code = 429, body = errorBody("rate_limited")))
        server.enqueue(MockResponse(code = 503, body = errorBody("ai_unavailable")))
        val repository = repository()
        val today = LocalDate.of(2026, 10, 10)
        val zone = ZoneId.of("Asia/Jakarta")

        assertEquals(Outcome.Failure(QuickAddError.RateLimited), repository.parse("x", today, zone))
        assertEquals(Outcome.Failure(QuickAddError.AiUnavailable), repository.parse("x", today, zone))
    }

    private fun errorBody(code: String) =
        """{"success":false,"message":"Failed","data":null,"error":{"code":"$code"}}"""

    private fun repository(): ApiQuickAddRepository {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(QuickAddApiService::class.java)
        return ApiQuickAddRepository(api, ApiCaller(ApiErrorMapper(NetworkJson), RecordingErrorLogger()))
    }
}
