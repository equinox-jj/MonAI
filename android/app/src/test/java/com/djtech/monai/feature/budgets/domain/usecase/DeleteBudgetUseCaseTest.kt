package com.djtech.monai.feature.budgets.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class DeleteBudgetUseCaseTest {

    private val repository = FakeBudgetRepository()
    private val deleteBudget = DeleteBudgetUseCase(repository)

    @Test
    fun `deletes the month's budget through the repository and returns its result`() = runTest {
        repository.deleteResult = Outcome.Failure(BudgetError.Unexpected)

        assertEquals(Outcome.Failure(BudgetError.Unexpected), deleteBudget(OCTOBER))
        assertEquals(listOf(OCTOBER), repository.deletedMonths)
    }
}
