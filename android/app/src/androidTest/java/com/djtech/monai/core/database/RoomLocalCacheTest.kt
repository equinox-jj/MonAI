package com.djtech.monai.core.database

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.database.entity.PaymentProviderCatalogEntity
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import java.time.LocalDate
import java.time.YearMonth

@RunWith(AndroidJUnit4::class)
class RoomLocalCacheTest {

    private lateinit var database: MonAIDatabase

    @Before
    fun setUp() {
        database = inMemoryDatabase()
    }

    @After
    fun tearDown() {
        database.close()
    }

    @Test
    fun clearEmptiesEveryTableIncludingTheSearchIndex() = runTest {
        val october = YearMonth.of(2026, 10)
        database.walletDao().upsertAll(listOf(wallet("cash")))
        database.categoryDao().upsertAll(listOf(category("food")))
        database.transactionDao().upsertAll(listOf(transaction("t1", note = "kopi")))
        database.budgetDao().upsert(budget(october))
        database.paymentProviderDao()
            .replaceCatalog(PaymentProviderCatalogEntity(version = 1, etag = null), emptyList())

        RoomLocalCache(database).clear()

        assertEquals(0, database.walletDao().observeAll().first().size)
        assertEquals(0, database.categoryDao().observeAll().first().size)
        assertNull(database.budgetDao().observe(october).first())
        assertNull(database.paymentProviderDao().catalogMeta())
        val transactions = database.transactionDao().searchPagingSource(
            match = "kopi*",
            from = LocalDate.of(2026, 10, 1),
            to = LocalDate.of(2026, 10, 31),
            walletId = null,
            categoryId = null,
            type = null,
        ).loadAll()
        assertEquals(0, transactions.size)
    }
}
