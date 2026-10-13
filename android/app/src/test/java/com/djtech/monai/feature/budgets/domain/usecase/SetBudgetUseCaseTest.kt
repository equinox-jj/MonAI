package com.djtech.monai.feature.budgets.domain.usecase

import com.djtech.monai.core.common.format.MAX_AMOUNT
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class SetBudgetUseCaseTest {

    private val repository = FakeBudgetRepository()
    private val setBudget = SetBudgetUseCase(repository)

    @Test
    fun `sets the month's limit through the repository and returns its result`() = runTest {
        repository.setResult = Outcome.Failure(BudgetError.Network)

        assertEquals(Outcome.Failure(BudgetError.Network), setBudget(OCTOBER, 3_000_000))
        assertEquals(listOf(OCTOBER to 3_000_000L), repository.setBudgets)
    }

    @Test
    fun `accepts the largest amount the app takes`() = runTest {
        assertEquals(Outcome.Success(Unit), setBudget(OCTOBER, MAX_AMOUNT))
    }

    @Test
    fun `rejects a zero limit without calling the repository`() = runTest {
        assertEquals(Outcome.Failure(BudgetError.InvalidLimit), setBudget(OCTOBER, 0))
        assertTrue(repository.setBudgets.isEmpty())
    }

    @Test
    fun `rejects a limit above the largest amount without calling the repository`() = runTest {
        assertEquals(Outcome.Failure(BudgetError.InvalidLimit), setBudget(OCTOBER, MAX_AMOUNT + 1))
        assertTrue(repository.setBudgets.isEmpty())
    }
}
