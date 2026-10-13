package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import java.time.LocalDate
import java.time.YearMonth
import javax.inject.Inject

/** Money out of one wallet (expenses and transfers out) on each cached day of [month], for its detail chart. */
class ObserveWalletDailyOutflowsUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    operator fun invoke(month: YearMonth, walletId: String): Flow<Map<LocalDate, Long>> =
        transactionRepository.observeDailyOutflows(month, walletId)
}
