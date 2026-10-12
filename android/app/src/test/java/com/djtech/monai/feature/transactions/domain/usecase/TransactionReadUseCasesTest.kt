package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class TransactionReadUseCasesTest {

    private val repository = FakeTransactionRepository(listOf(transaction("t1")))

    @Test
    fun `observeTransaction emits the cached transaction, or null`() = runTest {
        val observe = ObserveTransactionUseCase(repository)

        assertEquals(transaction("t1"), observe("t1").first())
        assertEquals(null, observe("missing").first())
    }

    @Test
    fun `refreshTransaction refreshes through the repository and returns its result`() = runTest {
        repository.refreshTransactionResult = Outcome.Failure(TransactionError.NotFound)

        assertEquals(Outcome.Failure(TransactionError.NotFound), RefreshTransactionUseCase(repository)("t1"))
        assertEquals(listOf("t1"), repository.refreshedIds)
    }

    @Test
    fun `observeDailyNets emits the month's day nets`() = runTest {
        val nets = ObserveDailyNetsUseCase(repository)(OCTOBER, TransactionFilter()).first()

        assertEquals(mapOf(LocalDate.of(2026, 10, 10) to -35_000L), nets)
    }

    @Test
    fun `observeDeletions emits each deleted transaction`() = runTest {
        val deleted = mutableListOf<Transaction>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) {
            ObserveTransactionDeletionsUseCase(repository)().toList(deleted)
        }

        repository.deleteTransaction("t1")

        assertEquals(listOf(transaction("t1")), deleted)
    }
}
