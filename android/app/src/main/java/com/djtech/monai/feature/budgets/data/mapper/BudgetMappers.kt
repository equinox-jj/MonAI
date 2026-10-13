package com.djtech.monai.feature.budgets.data.mapper

import com.djtech.monai.core.common.time.toYearMonthOrNull
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.budgets.data.remote.BudgetDto
import com.djtech.monai.feature.budgets.domain.model.BudgetError

/** Throws on a malformed month; call it where the failure becomes a result. */
fun BudgetDto.asModel(): Budget = Budget(
    month = requireNotNull(month.toYearMonthOrNull()) { "Not a YYYY-MM month: $month" },
    limitAmount = limitAmount,
    spent = spent,
    remaining = remaining,
    progressPercent = progressPercent,
    status = status,
)

/** `GET /budgets/{month}` answers 404 when the month has no budget, which isn't a failure. */
fun ApiError.isNoBudgetSet(): Boolean = this is ApiError.Http && status == 404 && code == "not_found"

fun ApiError.toBudgetError(): BudgetError = when (this) {
    ApiError.Network -> BudgetError.Network
    is ApiError.Http if code == "validation_failed" && fields.any { it.field == "limit_amount" } ->
        BudgetError.InvalidLimit

    is ApiError.Http, is ApiError.Unknown -> BudgetError.Unexpected
}
