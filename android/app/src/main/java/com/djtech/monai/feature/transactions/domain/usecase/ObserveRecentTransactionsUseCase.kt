package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth
import javax.inject.Inject

/** The newest [limit] cached transactions of [month], newest first. */
class ObserveRecentTransactionsUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    operator fun invoke(month: YearMonth, limit: Int): Flow<List<Transaction>> =
        transactionRepository.observeRecentTransactions(month, limit)
}
