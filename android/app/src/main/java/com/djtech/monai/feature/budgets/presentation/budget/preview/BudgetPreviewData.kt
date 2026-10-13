package com.djtech.monai.feature.budgets.presentation.budget.preview

import com.djtech.monai.feature.budgets.presentation.budget.BudgetState
import java.time.YearMonth

internal object BudgetPreviewData {
    val state = BudgetState(
        month = YearMonth.of(2026, 10),
        limit = 3_000_000,
        spent = 2_415_000,
        hasBudget = true,
    )

    val empty = BudgetState(month = YearMonth.of(2026, 10), spent = 2_415_000)
}
