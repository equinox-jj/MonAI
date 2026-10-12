package com.djtech.monai.feature.transactions.domain.usecase

import androidx.paging.PagingData
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flowOf
import java.time.YearMonth
import javax.inject.Inject

/** The API caps search text at 100 characters. */
const val MAX_SEARCH_LENGTH = 100

/**
 * Searches notes and merchants. With a [month] the API searches it; with none, every cached month
 * is searched on the device, offline too. Blank text finds nothing.
 */
class SearchTransactionsUseCase @Inject constructor(private val transactionRepository: TransactionRepository) {
    operator fun invoke(
        query: String,
        month: YearMonth?,
        filter: TransactionFilter,
    ): Flow<PagingData<Transaction>> {
        val text = query.trim().take(MAX_SEARCH_LENGTH)
        return when {
            text.isEmpty() -> flowOf(PagingData.empty())
            month == null -> transactionRepository.searchCachedTransactions(text, filter)
            else -> transactionRepository.searchTransactions(text, month, filter)
        }
    }
}
