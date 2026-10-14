package com.djtech.monai.feature.export.domain.usecase

import com.djtech.monai.core.common.coroutines.Dispatcher
import com.djtech.monai.core.common.coroutines.MonAIDispatcher
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
import com.djtech.monai.feature.export.domain.csv.TransactionCsvWriter
import com.djtech.monai.feature.export.domain.file.ExportFileWriter
import com.djtech.monai.feature.export.domain.model.CsvDelimiter
import com.djtech.monai.feature.export.domain.model.ExportError
import com.djtech.monai.feature.export.domain.model.ExportRange
import com.djtech.monai.feature.export.domain.model.ExportResult
import com.djtech.monai.feature.export.domain.model.ExportedCsv
import com.djtech.monai.feature.export.domain.model.MAX_EXPORT_MONTHS
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.withContext
import javax.inject.Inject

/**
 * Writes a CSV of every transaction in a range of months, ready to share. Each month is fetched
 * from the API (and cached on the way); offline, the cached ones are exported instead and the
 * result says it may be incomplete.
 */
class ExportTransactionsCsvUseCase @Inject constructor(
    private val transactionRepository: TransactionRepository,
    private val walletRepository: WalletRepository,
    private val categoryRepository: CategoryRepository,
    private val fileWriter: ExportFileWriter,
    private val clock: AppClock,
    @Dispatcher(MonAIDispatcher.Default) private val defaultDispatcher: CoroutineDispatcher,
) {
    suspend operator fun invoke(range: ExportRange, delimiter: CsvDelimiter): ExportResult<ExportedCsv> {
        if (range.monthCount !in 1..MAX_EXPORT_MONTHS || range.to > clock.currentMonth()) {
            return Outcome.Failure(ExportError.InvalidRange)
        }
        val (transactions, isComplete) = when (val fetched = fetchAll(range)) {
            is Outcome.Success -> fetched.data to true
            is Outcome.Failure -> when (fetched.error) {
                TransactionError.Network -> transactionRepository.cachedTransactions(range.from, range.to) to false
                else -> return Outcome.Failure(ExportError.Unexpected)
            }
        }
        if (transactions.isEmpty()) {
            return Outcome.Failure(if (isComplete) ExportError.NoTransactions else ExportError.Network)
        }

        // Archived wallets and hidden categories included: old transactions still use them.
        val walletNames = walletRepository.observeAllWallets().first().associate { it.id to it.name }
        val categoryNames = categoryRepository.observeCategories().first().associate { it.id to it.name }
        val csv = withContext(defaultDispatcher) {
            TransactionCsvWriter.write(
                transactions,
                walletNames,
                categoryNames,
                delimiter,
            )
        }
        val uri = fileWriter.write(range.fileName(), csv) ?: return Outcome.Failure(ExportError.Unexpected)
        return Outcome.Success(ExportedCsv(uri, transactions.size, isComplete))
    }

    /** Stops at the first failure, so an offline export makes one request, not one per month. */
    private suspend fun fetchAll(range: ExportRange): TransactionResult<List<Transaction>> {
        val all = mutableListOf<Transaction>()
        for (month in range.months) {
            when (val result = transactionRepository.fetchMonthTransactions(month)) {
                is Outcome.Success -> all += result.data
                is Outcome.Failure -> return result
            }
        }
        return Outcome.Success(all)
    }

    /** `monai-transactions-2026-10.csv`, or `monai-transactions-2026-08_2026-10.csv` for several months. */
    private fun ExportRange.fileName(): String {
        val months = if (from == to) from.toApiString() else "${from.toApiString()}_${to.toApiString()}"
        return "monai-transactions-$months.csv"
    }
}
