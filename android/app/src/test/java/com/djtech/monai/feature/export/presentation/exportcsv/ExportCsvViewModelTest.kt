package com.djtech.monai.feature.export.presentation.exportcsv

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.export.domain.file.FakeExportFileWriter
import com.djtech.monai.feature.export.domain.model.CsvDelimiter
import com.djtech.monai.feature.export.domain.model.ExportRange
import com.djtech.monai.feature.export.domain.usecase.ExportTransactionsCsvUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import java.time.LocalDate

class ExportCsvViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val transactions = FakeTransactionRepository(listOf(transaction("oct", date = LocalDate.of(2026, 10, 5))))
    private val files = FakeExportFileWriter()

    private fun runExportTest(block: suspend TestScope.(ExportCsvViewModel, MutableList<ExportCsvEffect>) -> Unit) =
        runTest(mainDispatcherRule.dispatcher) {
            val clock = FixedAppClock(NOW)
            val viewModel = ExportCsvViewModel(
                exportTransactionsCsv = ExportTransactionsCsvUseCase(
                    transactionRepository = transactions,
                    walletRepository = FakeWalletRepository(),
                    categoryRepository = FakeCategoryRepository(),
                    fileWriter = files,
                    clock = clock,
                    defaultDispatcher = UnconfinedTestDispatcher(testScheduler),
                ),
                clock = clock,
            )
            val effects = mutableListOf<ExportCsvEffect>()
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
            block(viewModel, effects)
        }

    private fun TestScope.send(viewModel: ExportCsvViewModel, vararg intents: ExportCsvIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `starts on this month, separated by commas`() = runExportTest { vm, _ ->
        val state = vm.state.value

        assertEquals(ExportRange(OCTOBER, OCTOBER), state.range)
        assertEquals(CsvDelimiter.COMMA, state.delimiter)
        assertFalse(state.canMoveFromForward)
        assertFalse(state.canMoveToForward)
        assertFalse(state.isExporting)
        assertNull(state.error)
    }

    @Test
    fun `moving the start back widens the range, and the end can follow it forward`() = runExportTest { vm, _ ->
        send(vm, ExportCsvIntent.MoveFrom(-2))

        assertEquals(ExportRange(OCTOBER.minusMonths(2), OCTOBER), vm.state.value.range)
        assertTrue(vm.state.value.canMoveFromForward)

        send(vm, ExportCsvIntent.MoveTo(-1))

        assertEquals(ExportRange(OCTOBER.minusMonths(2), OCTOBER.minusMonths(1)), vm.state.value.range)
        assertTrue(vm.state.value.canMoveToForward)
    }

    @Test
    fun `moving one end past the other drags it along`() = runExportTest { vm, _ ->
        send(vm, ExportCsvIntent.MoveTo(-3))

        assertEquals(ExportRange(OCTOBER.minusMonths(3), OCTOBER.minusMonths(3)), vm.state.value.range)

        send(vm, ExportCsvIntent.MoveFrom(2))

        assertEquals(ExportRange(OCTOBER.minusMonths(1), OCTOBER.minusMonths(1)), vm.state.value.range)
    }

    @Test
    fun `keeps the range to a year by dragging the other end`() = runExportTest { vm, _ ->
        send(vm, ExportCsvIntent.MoveFrom(-12))

        assertEquals(ExportRange(OCTOBER.minusMonths(12), OCTOBER.minusMonths(1)), vm.state.value.range)

        send(vm, ExportCsvIntent.MoveTo(1))

        assertEquals(ExportRange(OCTOBER.minusMonths(11), OCTOBER), vm.state.value.range)
    }

    @Test
    fun `never moves past this month`() = runExportTest { vm, _ ->
        send(vm, ExportCsvIntent.MoveTo(1), ExportCsvIntent.MoveFrom(1))

        assertEquals(ExportRange(OCTOBER, OCTOBER), vm.state.value.range)
    }

    @Test
    fun `picks the delimiter`() = runExportTest { vm, _ ->
        send(vm, ExportCsvIntent.PickDelimiter(CsvDelimiter.SEMICOLON))

        assertEquals(CsvDelimiter.SEMICOLON, vm.state.value.delimiter)
    }

    @Test
    fun `export shares the written file`() = runExportTest { vm, effects ->
        send(vm, ExportCsvIntent.PickDelimiter(CsvDelimiter.SEMICOLON), ExportCsvIntent.Export)

        assertEquals(
            listOf(
                ExportCsvEffect.Share(
                    "content://com.djtech.monai.fileprovider/exports/monai-transactions-2026-10.csv",
                    isComplete = true,
                ),
            ),
            effects,
        )
        assertTrue(files.written.single().second.contains("2026-10-05;EXPENSE"))
        assertFalse(vm.state.value.isExporting)
    }

    @Test
    fun `shows that it is exporting and ignores a second tap`() = runExportTest { vm, _ ->
        val gate = CompletableDeferred<Unit>()
        transactions.gate = gate

        send(vm, ExportCsvIntent.Export, ExportCsvIntent.Export)

        assertTrue(vm.state.value.isExporting)
        gate.complete(Unit)
        advanceUntilIdle()
        assertFalse(vm.state.value.isExporting)
        assertEquals(listOf(OCTOBER), transactions.fetchedMonths)
    }

    @Test
    fun `a failed export shows why and shares nothing`() = runExportTest { vm, effects ->
        transactions.fetchResults[OCTOBER] = Outcome.Failure(TransactionError.Unexpected)

        send(vm, ExportCsvIntent.Export)

        assertEquals(UiText.Resource(R.string.export_error_unexpected), vm.state.value.error)
        assertTrue(effects.isEmpty())
    }

    @Test
    fun `changing the range clears the error`() = runExportTest { vm, _ ->
        transactions.transactions.value = emptyList()
        send(vm, ExportCsvIntent.Export)
        assertEquals(UiText.Resource(R.string.export_error_empty), vm.state.value.error)

        send(vm, ExportCsvIntent.MoveFrom(-1))

        assertNull(vm.state.value.error)
    }

    @Test
    fun `cancel stops a running export`() = runExportTest { vm, effects ->
        transactions.gate = CompletableDeferred()

        send(vm, ExportCsvIntent.Export, ExportCsvIntent.Cancel)

        assertFalse(vm.state.value.isExporting)
        assertTrue(effects.isEmpty())
        assertTrue(files.written.isEmpty())
    }
}
