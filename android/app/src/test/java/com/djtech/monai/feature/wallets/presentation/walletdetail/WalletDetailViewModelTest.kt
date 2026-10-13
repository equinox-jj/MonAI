package com.djtech.monai.feature.wallets.presentation.walletdetail

import androidx.paging.testing.asSnapshot
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveWalletDailyOutflowsUseCase
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ArchiveWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.DeleteWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.SetDefaultWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.UnarchiveWalletUseCase
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.OutflowDay
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletDetailDialog
import kotlinx.coroutines.flow.take
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

class WalletDetailViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val clock = FixedAppClock(NOW)
    private val bca = wallet("bca", name = "BCA", balance = 8_250_000, isDefault = true)
    private val gopay = wallet("gopay", name = "GoPay", balance = 1_185_000)
    private val wallets = FakeWalletRepository(listOf(bca, gopay))
    private val categories = FakeCategoryRepository(listOf(category("food", name = "Food")))
    private val transactions = FakeTransactionRepository(
        listOf(
            transaction("lunch", LocalDate.of(2026, 10, 9), walletId = "gopay", amount = 35_000),
            transaction(
                "top-up",
                LocalDate.of(2026, 10, 9),
                type = TransactionType.TRANSFER,
                walletId = "bca",
                toWalletId = "gopay",
                categoryId = null,
                amount = 500_000,
            ),
            transaction("bus", LocalDate.of(2026, 10, 10), walletId = "gopay", amount = 28_000),
            transaction("sept", LocalDate.of(2026, 9, 30), walletId = "gopay"),
        ),
    )

    private fun viewModel(id: String) = WalletDetailViewModel(
        walletId = id,
        observeWallet = ObserveWalletUseCase(wallets),
        refreshWallet = RefreshWalletUseCase(wallets),
        observeAllWallets = ObserveAllWalletsUseCase(wallets),
        observeCategories = ObserveCategoriesUseCase(categories),
        observeTransactions = ObserveTransactionsUseCase(transactions),
        observeDailyOutflows = ObserveWalletDailyOutflowsUseCase(transactions),
        setDefaultWallet = SetDefaultWalletUseCase(wallets),
        archiveWallet = ArchiveWalletUseCase(wallets),
        unarchiveWallet = UnarchiveWalletUseCase(wallets),
        deleteWallet = DeleteWalletUseCase(wallets),
        clock = clock,
    )

    private fun runDetailTest(
        id: String = "gopay",
        block: suspend TestScope.(WalletDetailViewModel, MutableList<WalletDetailEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = viewModel(id)
        val effects = mutableListOf<WalletDetailEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: WalletDetailViewModel, vararg intents: WalletDetailIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `shows the cached wallet and refreshes it`() = runDetailTest { vm, _ ->
        val state = vm.state.value

        assertFalse(state.isLoading)
        assertEquals(gopay, state.wallet)
        assertEquals(OCTOBER, state.month)
        assertEquals(listOf("gopay"), wallets.refreshedIds)
        assertEquals(mapOf("bca" to "BCA", "gopay" to "GoPay"), state.lookups.walletNames)
    }

    @Test
    fun `money out covers each day of the month up to today`() = runDetailTest("bca") { vm, _ ->
        val outflows = vm.state.value.outflows

        assertEquals(10, outflows.size)
        assertEquals(OutflowDay(LocalDate.of(2026, 10, 9), 500_000), outflows[8])
        assertEquals(500_000L, vm.state.value.outflowTotal)
    }

    @Test
    fun `lists this month's transactions in or out of the wallet`() = runDetailTest { vm, _ ->
        val rows = vm.transactions.take(1).asSnapshot()

        assertEquals(setOf("lunch", "top-up", "bus"), rows.map { it.id }.toSet())
    }

    @Test
    fun `a wallet that isn't cached loads, and one that is gone says so`() = runTest(mainDispatcherRule.dispatcher) {
        wallets.refreshWalletResult = Outcome.Failure(WalletError.NotFound)
        val vm = viewModel("gone")
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.state.collect {} }
        advanceUntilIdle()

        assertFalse(vm.state.value.isLoading)
        assertEquals(UiText.Resource(R.string.wallets_error_not_found), vm.state.value.loadError)

        wallets.refreshWalletResult = Outcome.Success(Unit)
        vm.onIntent(WalletDetailIntent.Retry)
        advanceUntilIdle()
        assertEquals(listOf("gone", "gone"), wallets.refreshedIds)
    }

    @Test
    fun `the default wallet can't be archived or deleted, but others can`() = runDetailTest("bca") { vm, _ ->
        assertFalse(vm.state.value.canArchive)
        assertFalse(vm.state.value.canDelete)
        assertFalse(vm.state.value.canSetDefault)
        assertTrue(vm.state.value.canTransfer)
    }

    @Test
    fun `edit, transfer and a transaction navigate`() = runDetailTest { vm, effects ->
        send(
            vm,
            WalletDetailIntent.Edit,
            WalletDetailIntent.Transfer,
            WalletDetailIntent.OpenTransaction("lunch"),
            WalletDetailIntent.Back,
        )

        assertEquals(
            listOf(
                WalletDetailEffect.Navigate(WalletDetailDestination.Edit("gopay")),
                WalletDetailEffect.Navigate(WalletDetailDestination.Transfer("gopay")),
                WalletDetailEffect.Navigate(WalletDetailDestination.Transaction("lunch")),
                WalletDetailEffect.NavigateBack,
            ),
            effects,
        )
    }

    @Test
    fun `making it the default says so`() = runDetailTest { vm, effects ->
        send(vm, WalletDetailIntent.SetDefault)

        assertEquals(listOf("gopay" to WalletChanges(isDefault = true)), wallets.updates)
        assertEquals(
            listOf(WalletDetailEffect.ShowMessage(UiText.Resource(R.string.wallet_detail_now_default, "GoPay"))),
            effects,
        )
    }

    @Test
    fun `archiving and unarchiving say so`() = runDetailTest { vm, effects ->
        send(vm, WalletDetailIntent.Archive)
        wallets.wallets.value = listOf(bca, gopay.copy(isArchived = true))
        advanceUntilIdle()
        assertTrue(vm.state.value.canUnarchive)
        assertFalse(vm.state.value.canTransfer)

        send(vm, WalletDetailIntent.Unarchive)

        assertEquals(
            listOf("gopay" to WalletChanges(isArchived = true), "gopay" to WalletChanges(isArchived = false)),
            wallets.updates,
        )
        assertEquals(
            listOf(
                WalletDetailEffect.ShowMessage(UiText.Resource(R.string.wallet_detail_archived, "GoPay")),
                WalletDetailEffect.ShowMessage(UiText.Resource(R.string.wallet_detail_unarchived, "GoPay")),
            ),
            effects,
        )
    }

    @Test
    fun `delete asks first, then closes the wallet`() = runDetailTest { vm, effects ->
        send(vm, WalletDetailIntent.Delete)
        assertEquals(WalletDetailDialog.ConfirmDelete, vm.state.value.dialog)

        send(vm, WalletDetailIntent.ConfirmDelete)

        assertNull(vm.state.value.dialog)
        assertEquals(listOf("gopay"), wallets.deleted)
        assertEquals(listOf<WalletDetailEffect>(WalletDetailEffect.Deleted("gopay")), effects)
    }

    @Test
    fun `deleting a wallet with transactions offers to archive it instead`() = runDetailTest { vm, effects ->
        wallets.deleteResult = Outcome.Failure(WalletError.HasTransactions)

        send(vm, WalletDetailIntent.Delete, WalletDetailIntent.ConfirmDelete)
        assertEquals(WalletDetailDialog.ArchiveInstead, vm.state.value.dialog)
        assertEquals(emptyList<WalletDetailEffect>(), effects)

        send(vm, WalletDetailIntent.ConfirmArchive)

        assertNull(vm.state.value.dialog)
        assertEquals(listOf("gopay" to WalletChanges(isArchived = true)), wallets.updates)
    }

    @Test
    fun `dismissing a dialog keeps the wallet`() = runDetailTest { vm, _ ->
        send(vm, WalletDetailIntent.Delete, WalletDetailIntent.DismissDialog)

        assertNull(vm.state.value.dialog)
        assertEquals(emptyList<String>(), wallets.deleted)
    }

    @Test
    fun `a failed action says why`() = runDetailTest { vm, effects ->
        wallets.updateResult = Outcome.Failure(WalletError.Network)

        send(vm, WalletDetailIntent.SetDefault)

        assertFalse(vm.state.value.isWorking)
        assertEquals(
            listOf(WalletDetailEffect.ShowMessage(UiText.Resource(R.string.wallets_error_network))),
            effects,
        )
    }
}
