package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class CreateTransactionUseCaseTest {

    private val repository = FakeTransactionRepository()
    private val dependents = DependentRepositories()
    private val create = CreateTransactionUseCase(repository, dependents.refreshDependents, testClock())

    @Test
    fun `saves the normalized input and refreshes the wallets, report and budget of its month`() = runTest {
        val result = create(expenseInput(note = "  Makan siang "))

        assertTrue(result is Outcome.Success)
        assertEquals(listOf(expenseInput(note = "Makan siang")), repository.created)
        assertEquals(1, dependents.wallets.refreshCount)
        assertEquals(listOf(OCTOBER), dependents.reports.refreshedMonths)
        assertEquals(listOf(OCTOBER), dependents.budgets.refreshedMonths)
    }

    @Test
    fun `invalid input fails without reaching the repository`() = runTest {
        val result = create(expenseInput(amount = 0, date = testClock().today().plusDays(1)))

        assertEquals(
            Outcome.Failure(
                TransactionError.InvalidFields(
                    listOf(
                        TransactionFieldError(TransactionField.AMOUNT, TransactionFieldIssue.REQUIRED),
                        TransactionFieldError(TransactionField.DATE, TransactionFieldIssue.FUTURE_DATE),
                    ),
                ),
            ),
            result,
        )
        assertEquals(emptyList<Any>(), repository.created)
    }

    @Test
    fun `a failed save refreshes nothing`() = runTest {
        repository.saveResult = Outcome.Failure(TransactionError.Network)

        assertEquals(Outcome.Failure(TransactionError.Network), create(expenseInput()))
        assertEquals(0, dependents.wallets.refreshCount)
    }
}
