package com.djtech.monai.feature.budgets.domain.model

/** Why a budget action failed, in terms the budget screens can show. */
sealed interface BudgetError {
    data object Network : BudgetError

    data object Unexpected : BudgetError
}
