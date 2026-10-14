package com.djtech.monai.feature.receipt.data.repository

import com.djtech.monai.core.common.result.map
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.feature.receipt.data.dto.ParseReceiptRequestDto
import com.djtech.monai.feature.receipt.data.mapper.asModel
import com.djtech.monai.feature.receipt.data.mapper.toReceiptError
import com.djtech.monai.feature.receipt.data.remote.ReceiptApiService
import com.djtech.monai.feature.receipt.domain.model.ReceiptResult
import com.djtech.monai.feature.receipt.domain.repository.ReceiptRepository
import java.time.LocalDate
import java.time.ZoneId
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ReceiptRepositoryImpl @Inject constructor(
    private val receiptApiService: ReceiptApiService,
    private val apiCaller: ApiCaller,
) : ReceiptRepository {

    override suspend fun parse(ocrText: String, today: LocalDate, zone: ZoneId): ReceiptResult<ReceiptDraft> =
        apiCaller
            .call { receiptApiService.parseReceipt(ParseReceiptRequestDto(ocrText, today.toString(), zone.id)) }
            .map { it.draft.asModel() }
            .mapError { it.toReceiptError() }
}
