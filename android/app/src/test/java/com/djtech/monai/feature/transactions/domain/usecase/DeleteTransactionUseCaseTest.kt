package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class DeleteTransactionUseCaseTest {

    private val repository = FakeTransactionRepository(listOf(transaction("t1")))
    private val dependents = DependentRepositories()
    private val delete = DeleteTransactionUseCase(repository, dependents.refreshDependents)

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
}
