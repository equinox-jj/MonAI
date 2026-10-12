package com.djtech.monai.feature.budgets.domain.usecase

import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.budget
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ObserveBudgetUseCaseTest {

    private val observeBudget = ObserveBudgetUseCase(FakeBudgetRepository(budget()))

    @Test
    fun `emits the month's cached budget, or null without one`() = runTest {
        assertEquals(budget(), observeBudget(OCTOBER).first())
        assertNull(observeBudget(OCTOBER.plusMonths(1)).first())
    }
}
