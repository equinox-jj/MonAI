package com.djtech.monai.feature.transactions.presentation.undodelete

import com.djtech.monai.R
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.transaction
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionDeletionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionDependentsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RestoreTransactionUseCase
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runCurrent
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Rule
import org.junit.Test

class UndoDeleteViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val transactions = FakeTransactionRepository(listOf(transaction("lunch"), transaction("coffee")))
    private val wallets = FakeWalletRepository()

    private val viewModel by lazy {
        UndoDeleteViewModel(
            observeTransactionDeletions = ObserveTransactionDeletionsUseCase(transactions),
            restoreTransaction = RestoreTransactionUseCase(
                transactions,
                RefreshTransactionDependentsUseCase(wallets, FakeReportRepository(), FakeBudgetRepository()),
            ),
            observeCategories = ObserveCategoriesUseCase(FakeCategoryRepository(listOf(category("food")))),
            observeAllWallets = ObserveAllWalletsUseCase(wallets),
        )
    }

    private fun runUndoTest(block: suspend TestScope.(MutableList<UndoDeleteEffect>) -> Unit) =
        runTest(mainDispatcherRule.dispatcher) {
            val effects = mutableListOf<UndoDeleteEffect>()
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
            runCurrent()
            block(effects)
        }

    @Test
    fun `a delete anywhere is offered for undo for five seconds`() = runUndoTest {
        transactions.deleteTransaction("lunch")
        runCurrent()
        assertEquals("lunch", viewModel.state.value.deleted?.id)
        assertEquals("food", viewModel.state.value.lookups.category("food")?.id)

        advanceTimeBy(UNDO_WINDOW_MS - 1)
        runCurrent()
        assertEquals("lunch", viewModel.state.value.deleted?.id)

        advanceTimeBy(2)
        runCurrent()
        assertNull(viewModel.state.value.deleted)
    }

    @Test
    fun `a second delete replaces the offer and gets its own five seconds`() = runUndoTest {
        transactions.deleteTransaction("lunch")
        advanceTimeBy(4_000)
        transactions.deleteTransaction("coffee")
        advanceTimeBy(4_000)
        runCurrent()

        assertEquals("coffee", viewModel.state.value.deleted?.id)
    }

    @Test
    fun `undo restores the transaction and hides the bar`() = runUndoTest { effects ->
        transactions.restoreResult = Outcome.Success(transaction("lunch"))
        transactions.deleteTransaction("lunch")
        runCurrent()

        viewModel.onIntent(UndoDeleteIntent.Undo)
        advanceUntilIdle()

        assertEquals(listOf("lunch"), transactions.restoredIds)
        assertNull(viewModel.state.value.deleted)
        assertEquals(emptyList<UndoDeleteEffect>(), effects)
    }

    @Test
    fun `a failed undo says why`() = runUndoTest { effects ->
        transactions.restoreResult = Outcome.Failure(TransactionError.WalletArchived)
        transactions.deleteTransaction("lunch")
        runCurrent()

        viewModel.onIntent(UndoDeleteIntent.Undo)
        advanceUntilIdle()

        assertEquals(
            listOf(UndoDeleteEffect.ShowMessage(UiText.Resource(R.string.transaction_error_wallet_archived))),
            effects,
        )
        assertNull(viewModel.state.value.deleted)
    }
}
