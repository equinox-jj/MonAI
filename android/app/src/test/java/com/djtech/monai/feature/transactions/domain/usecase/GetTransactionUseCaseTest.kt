package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class GetTransactionUseCaseTest {

    @Test
    fun `returns the cached transaction without fetching it`() = runTest {
        val repository = FakeTransactionRepository(listOf(transaction("t1")))

        assertEquals(Outcome.Success(transaction("t1")), GetTransactionUseCase(repository)("t1"))
        assertEquals(emptyList<String>(), repository.refreshedIds)
    }

    @Test
    fun `fetches a transaction that isn't cached`() = runTest {
        val repository = FakeTransactionRepository()
        repository.remoteTransactions = listOf(transaction("t1"))

        assertEquals(Outcome.Success(transaction("t1")), GetTransactionUseCase(repository)("t1"))
        assertEquals(listOf("t1"), repository.refreshedIds)
    }

    @Test
    fun `fails like the fetch when it fails`() = runTest {
        val repository = FakeTransactionRepository()
        repository.refreshTransactionResult = Outcome.Failure(TransactionError.Network)

        assertEquals(Outcome.Failure(TransactionError.Network), GetTransactionUseCase(repository)("t1"))
    }

    @Test
    fun `fails with NotFound when the fetch leaves nothing cached`() = runTest {
        assertEquals(
            Outcome.Failure(TransactionError.NotFound),
            GetTransactionUseCase(FakeTransactionRepository())("t1"),
        )
    }
}
