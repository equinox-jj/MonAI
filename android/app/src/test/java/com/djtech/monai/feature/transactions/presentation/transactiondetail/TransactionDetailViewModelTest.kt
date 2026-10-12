package com.djtech.monai.feature.transactions.presentation.transactiondetail

import com.djtech.monai.R
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.DeleteTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionDependentsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionUseCase
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
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

class TransactionDetailViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val lunch = transaction("lunch", receiptUrl = "https://example.com/r.jpg")
    private val transactions = FakeTransactionRepository(listOf(lunch))
    private val wallets = FakeWalletRepository(listOf(wallet("bca")))
    private val categories = FakeCategoryRepository(listOf(category("food")))

    private fun viewModel(id: String = "lunch") = TransactionDetailViewModel(
        transactionId = id,
        observeTransaction = ObserveTransactionUseCase(transactions),
        refreshTransaction = RefreshTransactionUseCase(transactions),
        deleteTransaction = DeleteTransactionUseCase(
            transactions,
            RefreshTransactionDependentsUseCase(wallets, FakeReportRepository(), FakeBudgetRepository()),
        ),
        observeCategories = ObserveCategoriesUseCase(categories),
        observeAllWallets = ObserveAllWalletsUseCase(wallets),
        clock = FixedAppClock(NOW),
    )

    private fun runDetailTest(
        viewModel: TransactionDetailViewModel,
        block: suspend TestScope.(MutableList<TransactionDetailEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val effects = mutableListOf<TransactionDetailEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        block(effects)
    }

    @Test
    fun `shows the cached transaction with its names and refetches it for a fresh receipt link`() {
        val viewModel = viewModel()
        runDetailTest(viewModel) {
            advanceUntilIdle()

            val state = viewModel.state.value
            assertEquals(lunch, state.transaction)
            assertEquals("food", state.lookups.category("food")?.id)
            assertFalse(state.isLoading)
            assertEquals(listOf("lunch"), transactions.refreshedIds)
        }
    }

    @Test
    fun `a transaction that isn't cached and fails to load shows the error`() {
        transactions.refreshTransactionResult = Outcome.Failure(TransactionError.NotFound)
        val viewModel = viewModel("gone")
        runDetailTest(viewModel) {
            advanceUntilIdle()

            assertNull(viewModel.state.value.transaction)
            assertEquals(UiText.Resource(R.string.transaction_error_not_found), viewModel.state.value.loadError)
        }
    }

    @Test
    fun `delete removes it and goes back`() {
        val viewModel = viewModel()
        runDetailTest(viewModel) { effects ->
            viewModel.onIntent(TransactionDetailIntent.Delete)
            advanceUntilIdle()

            assertEquals(listOf("lunch"), transactions.deletedIds)
            assertEquals(listOf<TransactionDetailEffect>(TransactionDetailEffect.NavigateBack), effects)
        }
    }

    @Test
    fun `a failed delete stays and says why`() {
        transactions.deleteResult = Outcome.Failure(TransactionError.Network)
        val viewModel = viewModel()
        runDetailTest(viewModel) { effects ->
            viewModel.onIntent(TransactionDetailIntent.Delete)
            advanceUntilIdle()

            assertEquals(
                listOf(TransactionDetailEffect.ShowMessage(UiText.Resource(R.string.transaction_error_network))),
                effects,
            )
            assertFalse(viewModel.state.value.isDeleting)
        }
    }

    @Test
    fun `edit opens the form and the receipt opens full screen`() {
        val viewModel = viewModel()
        runDetailTest(viewModel) { effects ->
            viewModel.onIntent(TransactionDetailIntent.Edit)
            viewModel.onIntent(TransactionDetailIntent.OpenReceipt)
            advanceUntilIdle()

            assertEquals(listOf<TransactionDetailEffect>(TransactionDetailEffect.OpenEdit("lunch")), effects)
            assertTrue(viewModel.state.value.isReceiptOpen)

            viewModel.onIntent(TransactionDetailIntent.CloseReceipt)
            advanceUntilIdle()
            assertFalse(viewModel.state.value.isReceiptOpen)
        }
    }
}
