package com.djtech.monai.feature.quickadd.data.repository

import com.djtech.monai.core.common.result.map
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.model.TransactionDraftDto
import com.djtech.monai.core.network.model.asModel
import com.djtech.monai.feature.quickadd.data.dto.ParseTransactionRequestDto
import com.djtech.monai.feature.quickadd.data.mapper.toQuickAddError
import com.djtech.monai.feature.quickadd.data.remote.QuickAddApiService
import com.djtech.monai.feature.quickadd.domain.model.QuickAddResult
import com.djtech.monai.feature.quickadd.domain.repository.QuickAddRepository
import java.time.LocalDate
import java.time.ZoneId
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class QuickAddRepositoryImpl @Inject constructor(
    private val quickAddApiService: QuickAddApiService,
    private val apiCaller: ApiCaller,
) : QuickAddRepository {

    override suspend fun parse(text: String, today: LocalDate, zone: ZoneId): QuickAddResult<List<TransactionDraft>> =
        apiCaller
            .call { quickAddApiService.parseTransaction(ParseTransactionRequestDto(text, today.toString(), zone.id)) }
            .map { it.drafts.map(TransactionDraftDto::asModel) }
            .mapError { it.toQuickAddError() }
}
