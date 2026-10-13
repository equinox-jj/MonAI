package com.djtech.monai.feature.wallets.presentation.archivedwallets

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveArchivedWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.UnarchiveWalletUseCase
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Rule
import org.junit.Test

class ArchivedWalletsViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val repository = FakeWalletRepository(
        listOf(
            wallet("bca", isDefault = true),
            wallet("mandiri", name = "Mandiri", isArchived = true),
            wallet("ovo", name = "OVO", isArchived = true),
        ),
    )

    private fun runArchivedTest(
        block: suspend TestScope.(ArchivedWalletsViewModel, MutableList<ArchivedWalletsEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = ArchivedWalletsViewModel(
            ObserveArchivedWalletsUseCase(repository),
            UnarchiveWalletUseCase(repository),
        )
        val effects = mutableListOf<ArchivedWalletsEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    @Test
    fun `lists the archived wallets`() = runArchivedTest { vm, _ ->
        assertEquals(listOf("mandiri", "ovo"), vm.state.value.wallets.map { it.id })
    }

    @Test
    fun `unarchiving says so and offers to view the wallet`() = runArchivedTest { vm, effects ->
        vm.onIntent(ArchivedWalletsIntent.Unarchive("ovo"))
        advanceUntilIdle()

        assertEquals(listOf("ovo" to WalletChanges(isArchived = false)), repository.updates)
        assertEquals(
            listOf(ArchivedWalletsEffect.Restored("ovo", UiText.Resource(R.string.archived_wallets_restored, "OVO"))),
            effects,
        )
        assertNull(vm.state.value.restoringId)
    }

    @Test
    fun `a failed unarchive says why`() = runArchivedTest { vm, effects ->
        repository.updateResult = Outcome.Failure(WalletError.Network)

        vm.onIntent(ArchivedWalletsIntent.Unarchive("ovo"))
        advanceUntilIdle()

        assertEquals(
            listOf(ArchivedWalletsEffect.ShowMessage(UiText.Resource(R.string.wallets_error_network))),
            effects,
        )
    }

    @Test
    fun `back and view navigate`() = runArchivedTest { vm, effects ->
        vm.onIntent(ArchivedWalletsIntent.Back)
        vm.onIntent(ArchivedWalletsIntent.View("ovo"))
        advanceUntilIdle()

        assertEquals(
            listOf(ArchivedWalletsEffect.NavigateBack, ArchivedWalletsEffect.OpenWallet("ovo")),
            effects,
        )
    }
}
