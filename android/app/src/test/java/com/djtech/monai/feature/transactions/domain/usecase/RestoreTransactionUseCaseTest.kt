package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RestoreTransactionUseCaseTest {

    private val repository = FakeTransactionRepository()
    private val dependents = DependentRepositories()
    private val restore = RestoreTransactionUseCase(repository, dependents.refreshDependents)

    @Test
    fun `restores and refreshes the totals of its month`() = runTest {
        repository.restoreResult = Outcome.Success(transaction("t1"))

        assertEquals(Outcome.Success(transaction("t1")), restore("t1"))
        assertEquals(listOf("t1"), repository.restoredIds)
        assertEquals(listOf(OCTOBER), dependents.budgets.refreshedMonths)
    }

    @Test
    fun `a failed restore refreshes nothing`() = runTest {
        repository.restoreResult = Outcome.Failure(TransactionError.WalletArchived)

        assertEquals(Outcome.Failure(TransactionError.WalletArchived), restore("t1"))
        assertEquals(0, dependents.wallets.refreshCount)
    }
}
