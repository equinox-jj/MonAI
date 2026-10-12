package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import java.time.YearMonth
import javax.inject.Inject

/** Fetches the first [limit] (1–100) transactions of [month] into the cache. */
class RefreshRecentTransactionsUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    suspend operator fun invoke(month: YearMonth, limit: Int): TransactionResult<Unit> =
        transactionRepository.refreshRecentTransactions(month, limit)
}
