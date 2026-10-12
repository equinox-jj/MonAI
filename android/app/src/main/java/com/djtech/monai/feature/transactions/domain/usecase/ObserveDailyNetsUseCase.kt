package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import java.time.LocalDate
import java.time.YearMonth
import javax.inject.Inject

/** Income minus expenses of each cached day of [month] matching the filter, for the list's day headers. */
class ObserveDailyNetsUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    operator fun invoke(month: YearMonth, filter: TransactionFilter): Flow<Map<LocalDate, Long>> =
        transactionRepository.observeDailyNets(month, filter)
}
