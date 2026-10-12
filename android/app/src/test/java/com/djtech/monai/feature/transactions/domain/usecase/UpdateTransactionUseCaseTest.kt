package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.LocalDate

class UpdateTransactionUseCaseTest {

    private val repository = FakeTransactionRepository(
        listOf(transaction("t1", date = LocalDate.of(2026, 9, 30))),
    )
    private val dependents = DependentRepositories()
    private val update = UpdateTransactionUseCase(repository, dependents.refreshDependents, testClock())

    @Test
    fun `saves the edit and refreshes both months when the date moved`() = runTest {
        val result = update("t1", expenseInput())

        assertTrue(result is Outcome.Success)
        assertEquals(listOf("t1" to expenseInput()), repository.updated)
        assertEquals(setOf(OCTOBER.minusMonths(1), OCTOBER), dependents.reports.refreshedMonths.toSet())
        assertEquals(setOf(OCTOBER.minusMonths(1), OCTOBER), dependents.budgets.refreshedMonths.toSet())
        assertEquals(1, dependents.wallets.refreshCount)
    }

    @Test
    fun `invalid input fails without reaching the repository`() = runTest {
        val result = update("t1", expenseInput().copy(categoryId = null))

        assertEquals(
            Outcome.Failure(
                TransactionError.InvalidFields(
                    listOf(TransactionFieldError(TransactionField.CATEGORY, TransactionFieldIssue.REQUIRED)),
                ),
            ),
            result,
        )
        assertEquals(emptyList<Any>(), repository.updated)
    }
}
