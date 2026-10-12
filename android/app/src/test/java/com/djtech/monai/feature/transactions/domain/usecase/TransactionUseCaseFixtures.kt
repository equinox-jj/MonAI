package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import java.time.LocalDate

/** The repositories a transaction write refreshes afterwards, and the use case over them. */
class DependentRepositories {
    val wallets = FakeWalletRepository()
    val reports = FakeReportRepository()
    val budgets = FakeBudgetRepository()
    val refreshDependents = RefreshTransactionDependentsUseCase(wallets, reports, budgets)
}

/** 10 October 2026 in Jakarta. */
fun testClock() = FixedAppClock(NOW)

fun expenseInput(
    amount: Long = 35_000,
    date: LocalDate = LocalDate.of(2026, 10, 10),
    note: String? = "Makan siang",
) = TransactionInput(
    type = TransactionType.EXPENSE,
    amount = amount,
    walletId = "bca",
    toWalletId = null,
    categoryId = "food",
    date = date,
    note = note,
)
