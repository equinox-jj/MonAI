package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class ObserveRecentTransactionsUseCaseTest {

    @Test
    fun `emits the month's newest transactions up to the limit`() = runTest {
        val repository = FakeTransactionRepository(
            listOf(
                transaction("t1", date = LocalDate.of(2026, 10, 1)),
                transaction("t2", date = LocalDate.of(2026, 10, 2)),
                transaction("t3", date = LocalDate.of(2026, 9, 30)),
            ),
        )
        val observeRecent = ObserveRecentTransactionsUseCase(repository)

        assertEquals(listOf("t2"), observeRecent(OCTOBER, limit = 1).first().map { it.id })
    }
}
