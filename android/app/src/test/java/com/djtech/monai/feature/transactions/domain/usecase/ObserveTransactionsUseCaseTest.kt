package com.djtech.monai.feature.transactions.domain.usecase

import androidx.paging.testing.asSnapshot
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class ObserveTransactionsUseCaseTest {

    @Test
    fun `pages the month's transactions matching the filter`() = runTest {
        val repository = FakeTransactionRepository(
            listOf(transaction("expense"), transaction("income", type = TransactionType.INCOME)),
        )
        val filter = TransactionFilter(type = TransactionType.INCOME)

        val results = ObserveTransactionsUseCase(repository)(OCTOBER, filter).asSnapshot()

        assertEquals(listOf("income"), results.map(Transaction::id))
        assertEquals(listOf(OCTOBER to filter), repository.pagedQueries)
    }
}
