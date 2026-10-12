package com.djtech.monai.core.database

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.database.entity.PaymentProviderCatalogEntity
import com.djtech.monai.core.database.entity.PaymentProviderEntity
import com.djtech.monai.core.database.entity.TransactionRemoteKeyEntity
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.WalletType
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import java.time.Instant
import java.time.YearMonth

/** Wallets, categories, budgets, the provider catalog and remote keys. */
@RunWith(AndroidJUnit4::class)
class CacheDaoTest {

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
    fun walletsListDefaultFirstThenByName() = runTest {
        val dao = database.walletDao()
        dao.upsertAll(
            listOf(
                wallet("1", name = "ovo"),
                wallet("2", name = "BCA"),
                wallet("3", name = "Cash", isDefault = true),
            ),
        )

        assertEquals(listOf("Cash", "BCA", "ovo"), dao.observeAll().first().map { it.name })
    }

    @Test
    fun replaceAllWalletsDropsOnesTheServerNoLongerReturns() = runTest {
        val dao = database.walletDao()
        dao.upsertAll(listOf(wallet("old"), wallet("kept", name = "before")))

        dao.replaceAll(listOf(wallet("kept", name = "after"), wallet("new")))

        assertEquals(
            listOf("after", "new"),
            dao.observeAll().first().map { it.name },
        )
    }

    @Test
    fun categoriesFilterByType() = runTest {
        val dao = database.categoryDao()
        dao.replaceAll(
            listOf(
                category("food", name = "Food"),
                category("salary", name = "Salary", type = CategoryType.INCOME),
                category("bills", name = "Bills"),
            ),
        )

        assertEquals(
            listOf("Bills", "Food"),
            dao.observeByType(CategoryType.EXPENSE).first().map { it.name },
        )
    }

    @Test
    fun budgetIsStoredPerMonth() = runTest {
        val dao = database.budgetDao()
        val october = YearMonth.of(2026, 10)
        dao.upsert(budget(october))

        assertEquals(budget(october), dao.observe(october).first())
        assertNull(dao.observe(YearMonth.of(2026, 11)).first())

        dao.delete(october)

        assertNull(dao.observe(october).first())
    }

    @Test
    fun replaceCatalogSwapsProvidersAndMeta() = runTest {
        val dao = database.paymentProviderDao()
        assertNull(dao.catalogMeta())
        dao.replaceCatalog(
            PaymentProviderCatalogEntity(version = 1, etag = "\"v1\""),
            listOf(provider("gone", sortOrder = 1)),
        )

        dao.replaceCatalog(
            PaymentProviderCatalogEntity(version = 2, etag = "\"v2\""),
            listOf(provider("gopay", sortOrder = 2), provider("bca", sortOrder = 1)),
        )

        assertEquals(listOf("bca", "gopay"), dao.observeAll().first().map { it.id })
        assertEquals(listOf("bca-alias"), dao.observeAll().first().first().aliases)
        assertEquals(PaymentProviderCatalogEntity(version = 2, etag = "\"v2\""), dao.catalogMeta())
    }

    @Test
    fun remoteKeysAreStoredPerQuery() = runTest {
        val dao = database.transactionRemoteKeyDao()
        val key = TransactionRemoteKeyEntity(
            queryKey = "2026-10",
            nextCursor = "cursor-1",
            updatedAt = Instant.parse("2026-10-12T00:00:00Z"),
        )

        dao.upsert(key)

        assertEquals(key, dao.get("2026-10"))
        assertNull(dao.get("2026-10|wallet=bca"))

        dao.delete("2026-10")

        assertNull(dao.get("2026-10"))
    }

    private fun provider(id: String, sortOrder: Int) = PaymentProviderEntity(
        id = id,
        slug = id,
        name = id.uppercase(),
        type = WalletType.E_WALLET,
        logoUrl = null,
        aliases = listOf("$id-alias"),
        sortOrder = sortOrder,
    )
}
