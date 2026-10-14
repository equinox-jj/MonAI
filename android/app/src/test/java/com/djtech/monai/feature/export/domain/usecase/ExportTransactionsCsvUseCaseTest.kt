package com.djtech.monai.feature.export.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.export.domain.file.FakeExportFileWriter
import com.djtech.monai.feature.export.domain.model.CsvDelimiter
import com.djtech.monai.feature.export.domain.model.ExportError
import com.djtech.monai.feature.export.domain.model.ExportRange
import com.djtech.monai.feature.export.domain.model.ExportedCsv
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.LocalDate
import java.time.YearMonth

class ExportTransactionsCsvUseCaseTest {

    private val august = YearMonth.of(2026, 8)
    private val september = YearMonth.of(2026, 9)

    private val transactions = FakeTransactionRepository(
        listOf(
            transaction("aug", date = LocalDate.of(2026, 8, 20), note = "aug"),
            transaction("oct", date = LocalDate.of(2026, 10, 5), note = "oct"),
            transaction("sept", date = LocalDate.of(2026, 9, 14), note = "sept"),
        ),
    )
    private val wallets = FakeWalletRepository(listOf(wallet("bca", name = "BCA", isArchived = true)))
    private val categories = FakeCategoryRepository(listOf(category("food", name = "Makanan", isHidden = true)))
    private val files = FakeExportFileWriter()

    private suspend fun TestScope.export(range: ExportRange, delimiter: CsvDelimiter = CsvDelimiter.COMMA) =
        ExportTransactionsCsvUseCase(
            transactionRepository = transactions,
            walletRepository = wallets,
            categoryRepository = categories,
            fileWriter = files,
            clock = FixedAppClock(NOW),
            defaultDispatcher = UnconfinedTestDispatcher(testScheduler),
        )(range, delimiter)

    @Test
    fun `fetches every month of the range and writes them oldest first`() = runTest {
        val result = export(ExportRange(august, OCTOBER))

        assertEquals(
            Outcome.Success(
                ExportedCsv(
                    uri = "content://com.djtech.monai.fileprovider/exports/monai-transactions-2026-08_2026-10.csv",
                    rowCount = 3,
                    isComplete = true,
                ),
            ),
            result,
        )
        assertEquals(listOf(august, september, OCTOBER), transactions.fetchedMonths)
        val (name, content) = files.written.single()
        assertEquals("monai-transactions-2026-08_2026-10.csv", name)
        val notes = content.lines().drop(1).filter(String::isNotBlank).map { it.split(",")[7] }
        assertEquals(listOf("aug", "sept", "oct"), notes)
    }

    @Test
    fun `names a single month's file after that month and uses the picked delimiter`() = runTest {
        export(ExportRange(OCTOBER, OCTOBER), CsvDelimiter.SEMICOLON)

        val (name, content) = files.written.single()
        assertEquals("monai-transactions-2026-10.csv", name)
        assertTrue(content.contains("2026-10-05;EXPENSE;35000;BCA;;Makanan;;oct;MANUAL"))
    }

    @Test
    fun `offline exports what is cached and says it may be incomplete`() = runTest {
        transactions.fetchResults[september] = Outcome.Failure(TransactionError.Network)

        val result = export(ExportRange(august, OCTOBER))

        val exported = (result as Outcome.Success).data
        assertFalse(exported.isComplete)
        assertEquals(3, exported.rowCount)
        // Stops asking once it knows it is offline.
        assertEquals(listOf(august, september), transactions.fetchedMonths)
    }

    @Test
    fun `fails as unexpected when the server fails for another reason`() = runTest {
        transactions.fetchResults[september] = Outcome.Failure(TransactionError.Unexpected)

        assertEquals(Outcome.Failure(ExportError.Unexpected), export(ExportRange(august, OCTOBER)))
        assertTrue(files.written.isEmpty())
    }

    @Test
    fun `a range without transactions writes nothing`() = runTest {
        val july = YearMonth.of(2026, 7)

        assertEquals(Outcome.Failure(ExportError.NoTransactions), export(ExportRange(july, july)))
        assertTrue(files.written.isEmpty())
    }

    @Test
    fun `offline with nothing cached fails as a network error`() = runTest {
        val july = YearMonth.of(2026, 7)
        transactions.fetchResults[july] = Outcome.Failure(TransactionError.Network)

        assertEquals(Outcome.Failure(ExportError.Network), export(ExportRange(july, july)))
    }

    @Test
    fun `rejects a range that is reversed, reaches past this month or is over a year`() = runTest {
        val invalid = listOf(
            ExportRange(OCTOBER, september),
            ExportRange(OCTOBER, OCTOBER.plusMonths(1)),
            ExportRange(OCTOBER.minusMonths(12), OCTOBER),
        )

        invalid.forEach { range -> assertEquals(Outcome.Failure(ExportError.InvalidRange), export(range)) }
        assertTrue(transactions.fetchedMonths.isEmpty())
    }

    @Test
    fun `allows a whole year ending this month`() = runTest {
        val result = export(ExportRange(OCTOBER.minusMonths(11), OCTOBER))

        assertTrue(result is Outcome.Success)
        assertEquals(12, transactions.fetchedMonths.size)
    }

    @Test
    fun `fails as unexpected when the file cannot be written`() = runTest {
        files.fails = true

        assertEquals(Outcome.Failure(ExportError.Unexpected), export(ExportRange(OCTOBER, OCTOBER)))
    }
}
