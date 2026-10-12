package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class RefreshRecentTransactionsUseCaseTest {

    private val repository = FakeTransactionRepository()
    private val refreshRecent = RefreshRecentTransactionsUseCase(repository)

    @Test
    fun `refreshes the month through the repository and returns its result`() = runTest {
        repository.refreshResult = Outcome.Failure(TransactionError.Network)

        assertEquals(Outcome.Failure(TransactionError.Network), refreshRecent(OCTOBER, limit = 5))
        assertEquals(listOf(OCTOBER to 5), repository.refreshes)
    }
}
