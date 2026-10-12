package com.djtech.monai.feature.transactions.presentation.common.mapper

import androidx.paging.PagingData
import androidx.paging.testing.asSnapshot
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionListItem
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class TransactionListMappingTest {

    @Test
    fun `a header goes above the first transaction of each day`() = runTest {
        val tenth = LocalDate.of(2026, 10, 10)
        val ninth = LocalDate.of(2026, 10, 9)
        val transactions = listOf(transaction("a", tenth), transaction("b", tenth), transaction("c", ninth))

        val items = flowOf(PagingData.from(transactions).withDayHeaders()).asSnapshot()

        assertEquals(
            listOf(
                TransactionListItem.Day(tenth),
                TransactionListItem.Entry(transactions[0]),
                TransactionListItem.Entry(transactions[1]),
                TransactionListItem.Day(ninth),
                TransactionListItem.Entry(transactions[2]),
            ),
            items,
        )
    }
}
