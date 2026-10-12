package com.djtech.monai.feature.budgets.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias BudgetResult<T> = Outcome<T, BudgetError>
