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

/** Wallets, categories, budgets, the signed-in user, the provider catalog and remote keys. */
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
    fun userKeepsEveryField() = runTest {
        val dao = database.userDao()
        val joshua = user("u1").copy(
            avatarUrl = "https://cdn.example.com/a.png",
            permissions = listOf("payment_provider.view", "payment_provider.create"),
        )

        dao.replace(joshua)

        assertEquals(joshua, dao.observe().first())
    }

    @Test
    fun replaceUserKeepsOnlyTheLatestOne() = runTest {
        val dao = database.userDao()
        dao.replace(user("previous-account"))

        dao.replace(user("u1", name = "Joshua P"))

        assertEquals(user("u1", name = "Joshua P"), dao.observe().first())
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
        val dao = database.transactionDao()
        val key = TransactionRemoteKeyEntity(
            queryKey = "2026-10",
            nextCursor = "cursor-1",
            updatedAt = Instant.parse("2026-10-12T00:00:00Z"),
        )

        dao.upsertRemoteKey(key)

        assertEquals(key, dao.remoteKey("2026-10"))
        assertNull(dao.remoteKey("2026-10|wallet=bca"))
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
