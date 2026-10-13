package com.djtech.monai.core.database

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.database.dao.TransactionDao
import com.djtech.monai.core.database.entity.DailyAmount
import com.djtech.monai.core.database.entity.TransactionRemoteKeyEntity
import com.djtech.monai.core.model.TransactionType
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import java.time.Instant
import java.time.LocalDate

@RunWith(AndroidJUnit4::class)
class TransactionDaoTest {

    private lateinit var database: MonAIDatabase
    private lateinit var dao: TransactionDao

    private val october = LocalDate.of(2026, 10, 1) to LocalDate.of(2026, 10, 31)

    @Before
    fun setUp() {
        database = inMemoryDatabase()
        dao = database.transactionDao()
    }

    @After
    fun tearDown() {
        database.close()
    }

    @Test
    fun listsOneMonthNewestFirstThenById() = runTest {
        dao.upsertAll(
            listOf(
                transaction("a", date = LocalDate.of(2026, 10, 5)),
                transaction("c", date = LocalDate.of(2026, 10, 5)),
                transaction("b", date = LocalDate.of(2026, 10, 31)),
                transaction("d", date = LocalDate.of(2026, 10, 1)),
                transaction("sept", date = LocalDate.of(2026, 9, 30)),
                transaction("nov", date = LocalDate.of(2026, 11, 1)),
            ),
        )

        assertEquals(
            listOf(
                "b",
                "c",
                "a",
                "d",
            ),
            list().map { it.id },
        )
    }

    @Test
    fun walletFilterMatchesSourceOrDestination() = runTest {
        dao.upsertAll(
            listOf(
                transaction("spent", walletId = "bca"),
                transaction(
                    "received",
                    type = TransactionType.TRANSFER,
                    walletId = "cash",
                    toWalletId = "bca",
                    categoryId = null,
                ),
                transaction("other", walletId = "cash"),
            ),
        )

        assertEquals(setOf("spent", "received"), list(walletId = "bca").map { it.id }.toSet())
    }

    @Test
    fun dailyOutflowsSumExpensesAndTransfersOutOfOneWallet() = runTest {
        dao.upsertAll(
            listOf(
                transaction("lunch", date = LocalDate.of(2026, 10, 5), amount = 35_000),
                transaction(
                    "top-up",
                    date = LocalDate.of(2026, 10, 5),
                    type = TransactionType.TRANSFER,
                    toWalletId = "gopay",
                    categoryId = null,
                    amount = 500_000,
                ),
                transaction("salary", date = LocalDate.of(2026, 10, 5), type = TransactionType.INCOME),
                transaction(
                    "received",
                    date = LocalDate.of(2026, 10, 6),
                    type = TransactionType.TRANSFER,
                    walletId = "bca",
                    toWalletId = "cash",
                    categoryId = null,
                ),
                transaction("other-wallet", date = LocalDate.of(2026, 10, 6), walletId = "bca"),
                transaction("sept", date = LocalDate.of(2026, 9, 30)),
            ),
        )

        val outflows = dao.observeDailyOutflows(october.first, october.second, walletId = "cash").first()

        assertEquals(listOf(DailyAmount(LocalDate.of(2026, 10, 5), 535_000)), outflows)
    }

    @Test
    fun filtersByCategoryAndType() = runTest {
        dao.upsertAll(
            listOf(
                transaction("food", categoryId = "food"),
                transaction("bills", categoryId = "bills"),
                transaction("salary", type = TransactionType.INCOME, categoryId = "salary"),
            ),
        )

        assertEquals(listOf("food"), list(categoryId = "food").map { it.id })
        assertEquals(listOf("salary"), list(type = TransactionType.INCOME).map { it.id })
    }

    @Test
    fun searchFindsNoteOrMerchantIgnoringCase() = runTest {
        dao.upsertAll(
            listOf(
                transaction("merchant", merchant = "Kopi Kenangan"),
                transaction("note", note = "KOPI susu pagi"),
                transaction("other", note = "Parkir"),
            ),
        )

        assertEquals(setOf("merchant", "note"), search("kopi").map { it.id }.toSet())
        assertEquals(listOf("merchant"), search("ken").map { it.id })
    }

    @Test
    fun searchFollowsUpdatesAndDeletes() = runTest {
        dao.upsertAll(listOf(transaction("t1", note = "kopi"), transaction("t2", note = "kopi")))

        dao.upsertAll(listOf(transaction("t1", note = "teh")))
        dao.delete("t2")

        assertEquals(emptyList<String>(), search("kopi").map { it.id })
        assertEquals(listOf("t1"), search("teh").map { it.id })
    }

    @Test
    fun searchKeepsTheOtherFilters() = runTest {
        dao.upsertAll(
            listOf(
                transaction("oct", note = "kopi"),
                transaction("sept", date = LocalDate.of(2026, 9, 30), note = "kopi"),
                transaction("income", type = TransactionType.INCOME, note = "kopi"),
            ),
        )

        assertEquals(listOf("oct"), search("kopi", type = TransactionType.EXPENSE).map { it.id })
    }

    @Test
    fun deleteInRangeLeavesOtherMonths() = runTest {
        dao.upsertAll(
            listOf(
                transaction("oct"),
                transaction("sept", date = LocalDate.of(2026, 9, 30)),
            ),
        )

        dao.deleteInRange(october.first, october.second)

        assertEquals(emptyList<String>(), list().map { it.id })
        assertEquals(
            listOf("sept"),
            dao.pagingSource(
                from = LocalDate.of(2026, 9, 1),
                to = LocalDate.of(2026, 9, 30),
                walletId = null,
                categoryId = null,
                type = null,
            ).loadAll().map { it.id },
        )
    }

    @Test
    fun observeRecentListsTheNewestOfOneMonth() = runTest {
        dao.upsertAll(
            listOf(
                transaction("a", date = LocalDate.of(2026, 10, 5)),
                transaction("c", date = LocalDate.of(2026, 10, 5)),
                transaction("b", date = LocalDate.of(2026, 10, 31)),
                transaction("d", date = LocalDate.of(2026, 10, 1)),
                transaction("nov", date = LocalDate.of(2026, 11, 1)),
            ),
        )

        val recent = dao.observeRecent(october.first, october.second, limit = 3).first()

        assertEquals(listOf("b", "c", "a"), recent.map { it.id })
    }

    @Test
    fun replaceRecentWithTheWholeMonthDropsWhatTheServerNoLongerHas() = runTest {
        dao.upsertAll(
            listOf(
                transaction("deleted", date = LocalDate.of(2026, 10, 2)),
                transaction("kept", date = LocalDate.of(2026, 10, 3)),
                transaction("sept", date = LocalDate.of(2026, 9, 30)),
            ),
        )

        dao.replaceRecent(
            october.first,
            october.second,
            listOf(transaction("kept", date = LocalDate.of(2026, 10, 3))),
            hasMore = false,
        )

        assertEquals(listOf("kept"), list().map { it.id })
        assertEquals(listOf("sept"), september().map { it.id })
    }

    @Test
    fun replaceRecentWithAPartialPageOnlyReplacesWhatThePageCovers() = runTest {
        dao.upsertAll(
            listOf(
                transaction("deleted-newer", date = LocalDate.of(2026, 10, 20)),
                transaction("x", date = LocalDate.of(2026, 10, 10)),
                // Same day as the page's oldest row but sorts after it, so the page didn't cover it.
                transaction("a-older", date = LocalDate.of(2026, 10, 10)),
                transaction("older", date = LocalDate.of(2026, 10, 2)),
            ),
        )

        dao.replaceRecent(
            october.first,
            october.second,
            listOf(
                transaction("new", date = LocalDate.of(2026, 10, 25)),
                transaction("x", date = LocalDate.of(2026, 10, 10)),
            ),
            hasMore = true,
        )

        assertEquals(listOf("new", "x", "a-older", "older"), list().map { it.id })
    }

    @Test
    fun replaceRecentWithAnEmptyMonthClearsIt() = runTest {
        dao.upsertAll(listOf(transaction("deleted"), transaction("sept", date = LocalDate.of(2026, 9, 30))))

        dao.replaceRecent(october.first, october.second, emptyList(), hasMore = false)

        assertEquals(emptyList<String>(), list().map { it.id })
        assertEquals(listOf("sept"), september().map { it.id })
    }

    @Test
    fun replaceQueryPageOnlyReplacesTheRowsTheFilteredListShowsAndSavesTheCursor() = runTest {
        dao.upsertAll(
            listOf(
                transaction("stale-bca", walletId = "bca"),
                transaction("cash", walletId = "cash"),
                transaction("sept-bca", walletId = "bca", date = LocalDate.of(2026, 9, 30)),
            ),
        )
        val key = TransactionRemoteKeyEntity("2026-10|bca||", "next", Instant.EPOCH)

        dao.replaceQueryPage(
            from = october.first,
            to = october.second,
            walletId = "bca",
            categoryId = null,
            type = null,
            transactions = listOf(transaction("fresh-bca", walletId = "bca")),
            key = key,
        )

        assertEquals(setOf("fresh-bca", "cash"), list().map { it.id }.toSet())
        assertEquals(listOf("sept-bca"), september().map { it.id })
        assertEquals(key, dao.remoteKey(key.queryKey))
    }

    @Test
    fun appendQueryPageAddsRowsAndMovesTheCursor() = runTest {
        dao.upsertRemoteKey(TransactionRemoteKeyEntity("k", "c1", Instant.EPOCH))

        dao.appendQueryPage(listOf(transaction("older")), TransactionRemoteKeyEntity("k", null, Instant.EPOCH))

        assertEquals(listOf("older"), list().map { it.id })
        assertEquals(null, dao.remoteKey("k")?.nextCursor)
    }

    private suspend fun september() = dao.pagingSource(
        from = LocalDate.of(2026, 9, 1),
        to = LocalDate.of(2026, 9, 30),
        walletId = null,
        categoryId = null,
        type = null,
    ).loadAll()

    private suspend fun list(
        walletId: String? = null,
        categoryId: String? = null,
        type: TransactionType? = null,
    ) = dao.pagingSource(
        from = october.first,
        to = october.second,
        walletId = walletId,
        categoryId = categoryId,
        type = type,
    ).loadAll()

    private suspend fun search(
        text: String,
        type: TransactionType? = null,
    ) = dao.searchPagingSource(
        match = requireNotNull(toFtsMatchQuery(text)),
        from = october.first,
        to = october.second,
        walletId = null,
        categoryId = null,
        type = type,
    ).loadAll()
}
