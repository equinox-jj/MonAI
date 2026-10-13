package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.event.TransactionDeletionEvents
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class DeleteTransactionUseCaseTest {

    private val repository = FakeTransactionRepository(listOf(transaction("t1")))
    private val dependents = DependentRepositories()
    private val deletionEvents = TransactionDeletionEvents()
    private val delete = DeleteTransactionUseCase(repository, deletionEvents, dependents.refreshDependents)

    @Test
    fun `deletes and refreshes the totals of its month`() = runTest {
        assertEquals(Outcome.Success(Unit), delete("t1"))
        assertEquals(listOf("t1"), repository.deletedIds)
        assertEquals(listOf(OCTOBER), dependents.reports.refreshedMonths)
        assertEquals(1, dependents.wallets.refreshCount)
    }

    @Test
    fun `a failed delete refreshes nothing`() = runTest {
        repository.deleteResult = Outcome.Failure(TransactionError.Network)

        assertEquals(Outcome.Failure(TransactionError.Network), delete("t1"))
        assertEquals(0, dependents.wallets.refreshCount)
    }

    @Test
    fun `announces the deleted transaction for undo`() = runTest {
        val deleted = collectDeletions()

        delete("t1")

        assertEquals(listOf(transaction("t1")), deleted)
    }

    @Test
    fun `a failed delete announces nothing`() = runTest {
        val deleted = collectDeletions()
        repository.deleteResult = Outcome.Failure(TransactionError.Network)

        delete("t1")

        assertEquals(emptyList<Transaction>(), deleted)
    }

    @Test
    fun `a delete of an uncached transaction announces nothing`() = runTest {
        val deleted = collectDeletions()

        assertEquals(Outcome.Success(Unit), delete("missing"))
        assertEquals(emptyList<Transaction>(), deleted)
    }

    private fun TestScope.collectDeletions(): List<Transaction> {
        val deleted = mutableListOf<Transaction>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { deletionEvents.deletions.toList(deleted) }
        return deleted
    }
}
