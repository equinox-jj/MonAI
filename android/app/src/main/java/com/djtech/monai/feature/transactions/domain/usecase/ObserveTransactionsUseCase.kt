package com.djtech.monai.feature.transactions.domain.usecase

import androidx.paging.PagingData
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import java.time.YearMonth
import javax.inject.Inject

/** [month]'s transactions matching [filter], newest first, paged from the cache as the API fills it. */
class ObserveTransactionsUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    operator fun invoke(month: YearMonth, filter: TransactionFilter): Flow<PagingData<Transaction>> =
        transactionRepository.pagedTransactions(month, filter)
}
