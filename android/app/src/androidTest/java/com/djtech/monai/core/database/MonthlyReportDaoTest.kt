package com.djtech.monai.core.database

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.database.dao.MonthlyReportDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.database.entity.categoryEntities
import com.djtech.monai.core.model.CategoryBreakdown
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.core.model.PreviousMonthTotals
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import java.time.YearMonth

@RunWith(AndroidJUnit4::class)
class MonthlyReportDaoTest {

    private lateinit var database: MonAIDatabase
    private lateinit var dao: MonthlyReportDao

    private val october = YearMonth.of(2026, 10)

    @Before
    fun setUp() {
        database = inMemoryDatabase()
        dao = database.monthlyReportDao()
    }

    @After
    fun tearDown() {
        database.close()
    }

    @Test
    fun roundTripsAReportKeepingTheBreakdownOrder() = runTest {
        // "transport" sorts before "food" by id; the server order must win.
        val report = report(breakdown("food", 300_000), breakdown("transport", 100_000))

        dao.save(report)

        assertEquals(report, dao.observe(october).first()?.asModel())
    }

    @Test
    fun replaceDropsCategoriesNoLongerInTheReport() = runTest {
        dao.save(report(breakdown("food", 300_000), breakdown("bills", 200_000)))

        val updated = report(breakdown("bills", 250_000))
        dao.save(updated)

        assertEquals(updated, dao.observe(october).first()?.asModel())
    }

    @Test
    fun deletingAReportDeletesItsCategories() = runTest {
        dao.save(report(breakdown("food", 300_000)))

        dao.delete(october)

        assertNull(dao.observe(october).first())
        // Re-adding the month without categories proves no orphan rows were left behind.
        dao.save(report())
        val categories = dao.observe(october).first()?.asModel()?.categories
        assertEquals(emptyList<CategoryBreakdown>(), categories)
    }

    private suspend fun MonthlyReportDao.save(report: MonthlyReport) =
        replace(report.asEntity(), report.categoryEntities())

    private fun report(vararg categories: CategoryBreakdown) = MonthlyReport(
        month = october,
        incomeTotal = 10_000_000,
        expenseTotal = categories.sumOf { it.amount },
        net = 10_000_000 - categories.sumOf { it.amount },
        previous = PreviousMonthTotals(YearMonth.of(2026, 9), 9_000_000, 500_000),
        expenseChangePercent = null,
        categories = categories.toList(),
    )

    private fun breakdown(id: String, amount: Long) = CategoryBreakdown(
        categoryId = id,
        name = id,
        icon = null,
        color = "#FF8800",
        amount = amount,
        sharePercent = 50.0,
        previousAmount = 0,
        changePercent = null,
    )
}
