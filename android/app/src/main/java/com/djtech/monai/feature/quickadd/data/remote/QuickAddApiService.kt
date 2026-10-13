package com.djtech.monai.feature.quickadd.data.remote

import com.djtech.monai.core.network.model.ApiResponse
import com.djtech.monai.feature.quickadd.data.dto.ParseTransactionRequestDto
import com.djtech.monai.feature.quickadd.data.dto.ParsedDraftsDto
import retrofit2.http.Body
import retrofit2.http.POST

interface QuickAddApiService {

    /** Asks the AI to turn a phrase into drafts. Nothing is saved; rate-limited per user. */
    @POST("ai/parse-transaction")
    suspend fun parseTransaction(@Body request: ParseTransactionRequestDto): ApiResponse<ParsedDraftsDto>
}
