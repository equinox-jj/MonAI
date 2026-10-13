package com.djtech.monai.feature.receipt.data.repository

import com.djtech.monai.core.common.log.RecordingErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.model.ReceiptItem
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.draftConfidence
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiErrorMapper
import com.djtech.monai.core.network.NetworkJson
import com.djtech.monai.feature.receipt.data.remote.ReceiptApiService
import com.djtech.monai.feature.receipt.domain.model.ReceiptError
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

class ApiReceiptRepositoryTest {

    private val server = MockWebServer()
    private val today = LocalDate.of(2026, 10, 10)
    private val zone = ZoneId.of("Asia/Jakarta")

    @Before
    fun setUp() {
        server.start()
    }

    @After
    fun tearDown() {
        server.close()
    }

    @Test
    fun `parse sends the OCR text and maps the draft with its items`() = runTest {
        server.enqueue(
            MockResponse(
                code = 200,
                body = """
                    {"success":true,"message":"OK","data":{"draft":{
                      "type":"EXPENSE","amount":187500,"wallet_id":null,"to_wallet_id":null,"category_id":"shopping",
                      "date":"2026-10-09","note":null,"merchant":"Toko Sumber Rejeki",
                      "confidence":{"type":0.9,"amount":0.9,"wallet":0.0,"category":0.9,"date":0.5},
                      "items":[{"name":"Beras 5 kg","quantity":1,"amount":74000},
                               {"name":"Diskon","quantity":null,"amount":null}]
                    }}}
                """.trimIndent(),
            ),
        )

        val result = repository().parse("TOKO SUMBER REJEKI", today, zone)

        assertEquals(
            Outcome.Success(
                ReceiptDraft(
                    draft = draft(
                        amount = 187_500,
                        type = TransactionType.EXPENSE,
                        walletId = null,
                        categoryId = "shopping",
                        date = LocalDate.of(2026, 10, 9),
                        note = null,
                        merchant = "Toko Sumber Rejeki",
                        confidence = draftConfidence(sure = 0.9, wallet = 0.0, date = 0.5),
                    ),
                    items = listOf(ReceiptItem("Beras 5 kg", 1.0, 74_000), ReceiptItem("Diskon", null, null)),
                ),
            ),
            result,
        )
        val request = server.takeRequest()
        assertEquals("/api/v1/ai/parse-receipt", request.url.encodedPath)
        assertEquals(
            """{"ocr_text":"TOKO SUMBER REJEKI","today":"2026-10-10","timezone":"Asia/Jakarta"}""",
            request.body?.utf8(),
        )
    }

    @Test
    fun `maps the rate limit and an unavailable AI`() = runTest {
        server.enqueue(MockResponse(code = 429, body = errorBody("rate_limited")))
        server.enqueue(MockResponse(code = 503, body = errorBody("ai_unavailable")))
        val repository = repository()

        assertEquals(Outcome.Failure(ReceiptError.RateLimited), repository.parse("x", today, zone))
        assertEquals(Outcome.Failure(ReceiptError.AiUnavailable), repository.parse("x", today, zone))
    }

    private fun errorBody(code: String) =
        """{"success":false,"message":"Failed","data":null,"error":{"code":"$code"}}"""

    private fun repository(): ApiReceiptRepository {
        val api = Retrofit.Builder()
            .baseUrl(server.url("/api/v1/"))
            .client(OkHttpClient())
            .addConverterFactory(NetworkJson.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(ReceiptApiService::class.java)
        return ApiReceiptRepository(api, ApiCaller(ApiErrorMapper(NetworkJson), RecordingErrorLogger()))
    }
}
