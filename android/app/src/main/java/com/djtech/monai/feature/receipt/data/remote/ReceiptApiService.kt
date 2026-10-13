package com.djtech.monai.feature.receipt.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.feature.receipt.data.dto.ParseReceiptRequestDto
import com.djtech.monai.feature.receipt.data.dto.ParsedReceiptDto
import retrofit2.http.Body
import retrofit2.http.POST

interface ReceiptApiService {

    /** Asks the AI to read the receipt's OCR text. Nothing is saved; rate-limited per user. */
    @POST("ai/parse-receipt")
    suspend fun parseReceipt(@Body request: ParseReceiptRequestDto): ApiResponse<ParsedReceiptDto>
}
