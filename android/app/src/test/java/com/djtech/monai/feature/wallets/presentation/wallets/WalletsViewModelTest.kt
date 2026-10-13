package com.djtech.monai.feature.wallets.presentation.wallets

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletTypeShare
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletsUseCase
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

class WalletsViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val bca = wallet("bca", balance = 8_000_000, isDefault = true)
    private val gopay = wallet("gopay", balance = 2_000_000, type = WalletType.E_WALLET)
    private val ovo = wallet("ovo", balance = 15_000, type = WalletType.E_WALLET, isArchived = true)
    private val repository = FakeWalletRepository(listOf(bca, gopay, ovo))

    private fun runWalletsTest(
        block: suspend TestScope.(WalletsViewModel, MutableList<WalletsEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = WalletsViewModel(ObserveAllWalletsUseCase(repository), RefreshWalletsUseCase(repository))
        val effects = mutableListOf<WalletsEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    @Test
    fun `shows the active wallets with their total, type split and archived count`() = runWalletsTest { vm, _ ->
        val state = vm.state.value

        assertFalse(state.isLoading)
        assertEquals(listOf("bca", "gopay"), state.wallets.map { it.id })
        assertEquals(10_000_000L, state.totalBalance)
        assertEquals(listOf(WalletType.BANK, WalletType.E_WALLET), state.shares.map(WalletTypeShare::type))
        assertEquals(1, state.archivedCount)
        assertEquals(1, repository.refreshCount)
    }

    @Test
    fun `shows the skeleton while the first load runs with nothing cached`() = runTest(mainDispatcherRule.dispatcher) {
        repository.wallets.value = emptyList()
        val gate = CompletableDeferred<Unit>().also { repository.gate = it }
        val vm = WalletsViewModel(ObserveAllWalletsUseCase(repository), RefreshWalletsUseCase(repository))
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.state.collect {} }
        advanceUntilIdle()

        assertTrue(vm.state.value.isLoading)

        repository.wallets.value = listOf(bca)
        gate.complete(Unit)
        advanceUntilIdle()

        assertFalse(vm.state.value.isLoading)
        assertEquals(listOf("bca"), vm.state.value.wallets.map { it.id })
    }

    @Test
    fun `a failed first load with nothing cached shows the error, and retry loads again`() =
        runTest(mainDispatcherRule.dispatcher) {
            repository.wallets.value = emptyList()
            repository.refreshResult = Outcome.Failure(WalletError.Network)
            val vm = WalletsViewModel(ObserveAllWalletsUseCase(repository), RefreshWalletsUseCase(repository))
            val effects = mutableListOf<WalletsEffect>()
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.state.collect {} }
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.effects.toList(effects) }
            advanceUntilIdle()

            assertFalse(vm.state.value.isLoading)
            assertEquals(UiText.Resource(R.string.wallets_load_failed_network), vm.state.value.loadError)
            assertEquals(emptyList<WalletsEffect>(), effects)

            repository.refreshResult = Outcome.Success(Unit)
            repository.wallets.value = listOf(bca)
            vm.onIntent(WalletsIntent.Refresh)
            advanceUntilIdle()

            assertNull(vm.state.value.loadError)
            assertEquals(2, repository.refreshCount)
        }

    @Test
    fun `a failed refresh over cached wallets keeps them and says why`() = runTest(mainDispatcherRule.dispatcher) {
        repository.refreshResult = Outcome.Failure(WalletError.Network)
        val vm = WalletsViewModel(ObserveAllWalletsUseCase(repository), RefreshWalletsUseCase(repository))
        val effects = mutableListOf<WalletsEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.effects.toList(effects) }
        advanceUntilIdle()

        assertNull(vm.state.value.loadError)
        assertEquals(2, vm.state.value.wallets.size)
        assertEquals(
            listOf(
                WalletsEffect.ShowMessage(UiText.Resource(R.string.wallets_refresh_failed_network), isOffline = true),
            ),
            effects,
        )
    }

    @Test
    fun `pull to refresh shows the indicator while it runs`() = runWalletsTest { vm, _ ->
        val gate = CompletableDeferred<Unit>().also { repository.gate = it }

        vm.onIntent(WalletsIntent.Refresh)
        advanceUntilIdle()
        assertTrue(vm.state.value.isRefreshing)

        gate.complete(Unit)
        advanceUntilIdle()
        assertFalse(vm.state.value.isRefreshing)
    }

    @Test
    fun `opening a destination navigates`() = runWalletsTest { vm, effects ->
        vm.onIntent(WalletsIntent.Open(WalletsDestination.Detail("gopay")))
        vm.onIntent(WalletsIntent.Open(WalletsDestination.Add))
        advanceUntilIdle()

        assertEquals(
            listOf(
                WalletsEffect.Navigate(WalletsDestination.Detail("gopay")),
                WalletsEffect.Navigate(WalletsDestination.Add),
            ),
            effects,
        )
    }

    @Test
    fun `the detail pane shows the first wallet until one is picked`() = runWalletsTest { vm, _ ->
        assertEquals("bca", vm.state.value.selectedId)

        vm.onIntent(WalletsIntent.Select("gopay"))
        advanceUntilIdle()
        assertEquals("gopay", vm.state.value.selectedId)

        // Archived from the pane: the selection falls back to the first wallet.
        repository.wallets.value = listOf(bca, gopay.copy(isArchived = true))
        advanceUntilIdle()
        assertEquals("bca", vm.state.value.selectedId)
    }
}
