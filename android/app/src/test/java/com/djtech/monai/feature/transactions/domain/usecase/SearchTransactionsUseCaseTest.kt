package com.djtech.monai.feature.transactions.domain.usecase

import androidx.paging.testing.asSnapshot
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class SearchTransactionsUseCaseTest {

    private val repository = FakeTransactionRepository(
        listOf(
            transaction("oct", note = "Kopi susu"),
            transaction("sep", date = LocalDate.of(2026, 9, 3), note = "Biji kopi"),
        ),
    )
    private val search = SearchTransactionsUseCase(repository)

    @Test
    fun `a month searches it on the server with the trimmed text`() = runTest {
        val results = search("  kopi ", OCTOBER, TransactionFilter()).asSnapshot()

        assertEquals(listOf("oct"), results.map(Transaction::id))
        assertEquals(Triple("kopi", OCTOBER, TransactionFilter()), repository.searches.single())
    }

    @Test
    fun `no month searches every cached month`() = runTest {
        val results = search("kopi", month = null, TransactionFilter()).asSnapshot()

        assertEquals(listOf("oct", "sep"), results.map(Transaction::id))
        assertEquals(null, repository.searches.single().second)
    }

    @Test
    fun `blank text finds nothing without searching`() = runTest {
        assertEquals(emptyList<Transaction>(), search("   ", OCTOBER, TransactionFilter()).asSnapshot())
        assertEquals(emptyList<Any>(), repository.searches)
    }

    @Test
    fun `text is cut to the API's 100 characters`() = runTest {
        search("k".repeat(150), OCTOBER, TransactionFilter()).asSnapshot()

        assertEquals(100, repository.searches.single().first.length)
    }
}
