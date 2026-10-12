package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.feature.budgets.domain.repository.BudgetRepository
import com.djtech.monai.feature.reports.domain.repository.ReportRepository
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import java.time.YearMonth
import javax.inject.Inject

/**
 * After a transaction changes, the server recalculates wallet balances and the budget and report
 * of its month. This refetches them so Home and Wallets don't show old totals. Best effort: the
 * write already succeeded, and a later refresh catches up on any failure here.
 */
class RefreshTransactionDependentsUseCase @Inject constructor(
    private val walletRepository: WalletRepository,
    private val reportRepository: ReportRepository,
    private val budgetRepository: BudgetRepository,
) {
    suspend operator fun invoke(months: Set<YearMonth>) = coroutineScope {
        launch { walletRepository.refresh() }
        months.forEach { month ->
            launch { reportRepository.refreshMonthlyReport(month) }
            launch { budgetRepository.refreshBudget(month) }
        }
    }
}
