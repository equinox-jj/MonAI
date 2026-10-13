package com.djtech.monai.feature.budgets.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.log.runLogged
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.flatMap
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.database.dao.BudgetDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.budgets.data.mapper.asModel
import com.djtech.monai.feature.budgets.data.mapper.isNoBudgetSet
import com.djtech.monai.feature.budgets.data.mapper.toBudgetError
import com.djtech.monai.feature.budgets.data.remote.BudgetApiService
import com.djtech.monai.feature.budgets.data.remote.SetBudgetRequestDto
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.model.BudgetResult
import com.djtech.monai.feature.budgets.domain.repository.BudgetRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.time.YearMonth
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ApiBudgetRepository @Inject constructor(
    private val budgetApiService: BudgetApiService,
    private val apiCaller: ApiCaller,
    private val budgetDao: BudgetDao,
    private val errorLogger: ErrorLogger,
) : BudgetRepository {

    override fun observeBudget(month: YearMonth): Flow<Budget?> = budgetDao.observe(month).map { it?.asModel() }

    override suspend fun refreshBudget(month: YearMonth): BudgetResult<Unit> {
        // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
        val result = apiCaller.callRaw { budgetApiService.getBudget(month.toApiString()).data.asModel() }
        return when (result) {
            is Outcome.Success -> cache { budgetDao.upsert(result.data.asEntity()) }
            // The budget was never set or was removed, maybe on another device.
            is Outcome.Failure if result.error.isNoBudgetSet() -> cache { budgetDao.delete(month) }
            is Outcome.Failure -> Outcome.Failure(result.error.toBudgetError())
        }
    }

    override suspend fun setBudget(month: YearMonth, limitAmount: Long): BudgetResult<Unit> {
        val body = SetBudgetRequestDto(limitAmount)
        return apiCaller.callRaw { budgetApiService.setBudget(month.toApiString(), body).data.asModel() }
            .mapError(ApiError::toBudgetError)
            .flatMap { budget -> cache { budgetDao.upsert(budget.asEntity()) } }
    }

    override suspend fun deleteBudget(month: YearMonth): BudgetResult<Unit> =
        when (val result = apiCaller.callRaw { budgetApiService.deleteBudget(month.toApiString()) }) {
            is Outcome.Success -> cache { budgetDao.delete(month) }
            // Removed already, maybe on another device.
            is Outcome.Failure if result.error.isNoBudgetSet() -> cache { budgetDao.delete(month) }
            is Outcome.Failure -> Outcome.Failure(result.error.toBudgetError())
        }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private inline fun cache(write: () -> Unit): BudgetResult<Unit> =
        errorLogger.runLogged("Caching the budget failed", BudgetError.Unexpected, write)
}
