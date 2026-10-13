package com.djtech.monai.feature.budgets.domain.model

/** Why a budget action failed, in terms the budget screens can show. */
sealed interface BudgetError {
    data object Network : BudgetError

    /** The limit is zero or above the largest amount the API takes. */
    data object InvalidLimit : BudgetError

    data object Unexpected : BudgetError
}
