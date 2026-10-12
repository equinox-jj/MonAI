package com.djtech.monai.feature.budgets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RefreshBudgetUseCaseTest {

    private val repository = FakeBudgetRepository()
    private val refreshBudget = RefreshBudgetUseCase(repository)

    @Test
    fun `refreshes the month through the repository and returns its result`() = runTest {
        repository.refreshResult = Outcome.Failure(BudgetError.Unexpected)

        assertEquals(Outcome.Failure(BudgetError.Unexpected), refreshBudget(OCTOBER))
        assertEquals(listOf(OCTOBER), repository.refreshedMonths)
    }
}
