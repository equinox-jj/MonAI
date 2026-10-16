package com.djtech.monai.feature.wallets.presentation.walletform

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.WalletColor
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.paymentProvider
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.wallets.domain.model.WalletChanges
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.domain.model.WalletFieldError
import com.djtech.monai.feature.wallets.domain.model.WalletFieldIssue
import com.djtech.monai.feature.wallets.domain.model.WalletInput
import com.djtech.monai.feature.wallets.domain.repository.FakePaymentProviderRepository
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ArchiveWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.CreateWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.DeleteWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.GetWalletUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObservePaymentProvidersUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshPaymentProvidersUseCase
import com.djtech.monai.feature.wallets.domain.usecase.UpdateWalletUseCase
import com.djtech.monai.feature.wallets.presentation.walletform.model.BalanceShift
import com.djtech.monai.feature.wallets.presentation.walletform.model.WalletFormDialog
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

class WalletFormViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val bca = wallet("bca", name = "BCA Tabungan", balance = 8_250_000, isDefault = true)
    private val mandiri = wallet(
        "mandiri",
        name = "Mandiri",
        balance = 2_565_000,
        providerId = "p-mandiri",
        initialBalance = 2_000_000,
    )
    private val wallets = FakeWalletRepository(listOf(bca, mandiri))
    private val providers = FakePaymentProviderRepository(
        listOf(
            paymentProvider("cash", id = "", name = "Cash", type = WalletType.CASH),
            paymentProvider("bca", id = "", name = "BCA"),
            paymentProvider("gopay", id = "", name = "GoPay", type = WalletType.E_WALLET),
        ),
    ).apply {
        catalogAfterRefresh = listOf(
            paymentProvider("cash", name = "Cash", type = WalletType.CASH),
            paymentProvider("bca", name = "BCA"),
            paymentProvider("gopay", name = "GoPay", type = WalletType.E_WALLET),
        )
    }

    private fun viewModel(id: String?) = WalletFormViewModel(
        walletId = id,
        observeProviders = ObservePaymentProvidersUseCase(providers),
        refreshProviders = RefreshPaymentProvidersUseCase(providers),
        getWallet = GetWalletUseCase(wallets),
        observeWallets = ObserveWalletsUseCase(wallets),
        createWallet = CreateWalletUseCase(wallets, providers),
        updateWallet = UpdateWalletUseCase(wallets),
        archiveWallet = ArchiveWalletUseCase(wallets),
        deleteWallet = DeleteWalletUseCase(wallets),
    )

    private fun runFormTest(
        id: String? = null,
        block: suspend TestScope.(WalletFormViewModel, MutableList<WalletFormEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = viewModel(id)
        val effects = mutableListOf<WalletFormEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: WalletFormViewModel, vararg intents: WalletFormIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `a new wallet starts custom, with the provider catalog refreshed`() = runFormTest { vm, _ ->
        val state = vm.state.value

        assertFalse(state.isEdit)
        assertNull(state.providerSlug)
        assertEquals(listOf("cash", "bca", "gopay"), state.providers.map { it.slug })
        assertFalse(state.isTypeLocked)
        assertEquals("BCA Tabungan", state.defaultWalletName)
        assertEquals(1, providers.refreshCount)
    }

    @Test
    fun `picking a provider fills its name and locks its type`() = runFormTest { vm, _ ->
        send(vm, WalletFormIntent.PickProvider("bca"))

        assertEquals("bca", vm.state.value.providerSlug)
        assertEquals("BCA", vm.state.value.name)
        assertEquals(WalletType.BANK, vm.state.value.type)
        assertTrue(vm.state.value.isTypeLocked)
    }

    @Test
    fun `a renamed wallet keeps its name when another provider is picked`() = runFormTest { vm, _ ->
        send(
            vm,
            WalletFormIntent.PickProvider("bca"),
            WalletFormIntent.NameChanged("BCA Bisnis"),
            WalletFormIntent.PickProvider("gopay"),
        )

        assertEquals("BCA Bisnis", vm.state.value.name)
        assertEquals(WalletType.E_WALLET, vm.state.value.type)
    }

    @Test
    fun `going back to custom clears the provider's name and unlocks the type`() = runFormTest { vm, _ ->
        send(vm, WalletFormIntent.PickProvider("gopay"), WalletFormIntent.PickCustom)

        assertNull(vm.state.value.providerSlug)
        assertEquals("", vm.state.value.name)
        assertFalse(vm.state.value.isTypeLocked)
    }

    @Test
    fun `the balance field keeps digits only`() = runFormTest { vm, _ ->
        send(vm, WalletFormIntent.BalanceChanged("1.250.000x"))

        assertEquals(1_250_000L, vm.state.value.initialBalance)

        send(vm, WalletFormIntent.BalanceChanged(""))
        assertEquals(0L, vm.state.value.initialBalance)
    }

    @Test
    fun `adding a provider wallet creates it by slug and closes`() = runFormTest { vm, effects ->
        send(
            vm,
            WalletFormIntent.PickProvider("bca"),
            WalletFormIntent.BalanceChanged("1250000"),
            WalletFormIntent.DefaultChanged(true),
            WalletFormIntent.Save,
        )

        assertEquals(
            listOf(
                WalletInput(
                    providerId = "p-bca",
                    name = "BCA",
                    type = WalletType.BANK,
                    initialBalance = 1_250_000,
                    isDefault = true,
                ),
            ),
            wallets.created,
        )
        assertEquals(listOf<WalletFormEffect>(WalletFormEffect.Close), effects)
    }

    @Test
    fun `saving an incomplete custom wallet marks its fields`() = runFormTest { vm, effects ->
        send(vm, WalletFormIntent.Save)

        assertEquals(
            mapOf(
                WalletField.NAME to UiText.Resource(R.string.wallet_form_error_name_required),
                WalletField.TYPE to UiText.Resource(R.string.wallet_form_error_type_required),
            ),
            vm.state.value.errors,
        )
        assertEquals(emptyList<WalletFormEffect>(), effects)

        send(vm, WalletFormIntent.NameChanged("Tabungan"))
        assertEquals(setOf(WalletField.TYPE), vm.state.value.errors.keys)
    }

    @Test
    fun `a name already in use lands on the name field`() = runFormTest { vm, _ ->
        wallets.createResult = Outcome.Failure(
            WalletError.InvalidFields(listOf(WalletFieldError(WalletField.NAME, WalletFieldIssue.ALREADY_EXISTS))),
        )

        send(
            vm,
            WalletFormIntent.NameChanged("Cash"),
            WalletFormIntent.SelectType(WalletType.CASH),
            WalletFormIntent.Save,
        )

        assertEquals(
            mapOf(WalletField.NAME to UiText.Resource(R.string.wallet_form_error_name_taken)),
            vm.state.value.errors,
        )
        assertFalse(vm.state.value.isSaving)
    }

    @Test
    fun `a failed save says why and keeps the form`() = runFormTest { vm, effects ->
        wallets.createResult = Outcome.Failure(WalletError.Network)

        send(
            vm,
            WalletFormIntent.NameChanged("Cash 2"),
            WalletFormIntent.SelectType(WalletType.CASH),
            WalletFormIntent.Save,
        )

        assertEquals(
            listOf(WalletFormEffect.ShowMessage(UiText.Resource(R.string.wallets_error_network))),
            effects,
        )
        assertEquals("Cash 2", vm.state.value.name)
    }

    @Test
    fun `editing fills the form from the wallet`() = runFormTest("mandiri") { vm, _ ->
        val state = vm.state.value

        assertTrue(state.isEdit)
        assertFalse(state.isLoading)
        assertEquals("Mandiri", state.name)
        assertEquals(2_000_000L, state.initialBalance)
        assertTrue(state.isTypeLocked)
        assertTrue(state.canArchive)
        assertNull(state.balanceShift)
    }

    @Test
    fun `changing the starting balance previews the new current balance`() = runFormTest("mandiri") { vm, _ ->
        send(vm, WalletFormIntent.BalanceChanged("2500000"))

        assertEquals(BalanceShift(from = 2_565_000, to = 3_065_000), vm.state.value.balanceShift)
    }

    @Test
    fun `saving an edit sends only what changed`() = runFormTest("mandiri") { vm, effects ->
        send(
            vm,
            WalletFormIntent.NameChanged("Mandiri Bisnis"),
            WalletFormIntent.PickColor(WalletColor.Teal),
            WalletFormIntent.Save,
        )

        assertEquals(
            listOf("mandiri" to WalletChanges(name = "Mandiri Bisnis", color = WalletColor.Teal.hex)),
            wallets.updates,
        )
        assertEquals(listOf<WalletFormEffect>(WalletFormEffect.Close), effects)
    }

    @Test
    fun `the default wallet can't be archived, deleted or unset`() = runFormTest("bca") { vm, _ ->
        assertFalse(vm.state.value.canArchive)
        assertFalse(vm.state.value.canDelete)
        assertFalse(vm.state.value.canChangeDefault)
    }

    @Test
    fun `an untouched form closes at once, an edited one asks first`() = runFormTest("mandiri") { vm, effects ->
        send(vm, WalletFormIntent.Close)
        assertEquals(listOf<WalletFormEffect>(WalletFormEffect.Close), effects)

        send(vm, WalletFormIntent.NameChanged("Mandiri 2"), WalletFormIntent.Close)
        assertEquals(WalletFormDialog.Discard, vm.state.value.dialog)

        send(vm, WalletFormIntent.KeepEditing)
        assertNull(vm.state.value.dialog)

        send(vm, WalletFormIntent.Close, WalletFormIntent.ConfirmDiscard)
        assertEquals(listOf<WalletFormEffect>(WalletFormEffect.Close, WalletFormEffect.Close), effects)
    }

    @Test
    fun `archiving from the form closes it`() = runFormTest("mandiri") { vm, effects ->
        send(vm, WalletFormIntent.Archive)

        assertEquals(listOf("mandiri" to WalletChanges(isArchived = true)), wallets.updates)
        assertEquals(listOf<WalletFormEffect>(WalletFormEffect.Close), effects)
    }

    @Test
    fun `deleting asks first, then closes the wallet's screens`() = runFormTest("mandiri") { vm, effects ->
        send(vm, WalletFormIntent.Delete)
        assertEquals(WalletFormDialog.ConfirmDelete, vm.state.value.dialog)

        send(vm, WalletFormIntent.ConfirmDelete)

        assertEquals(listOf("mandiri"), wallets.deleted)
        assertEquals(listOf<WalletFormEffect>(WalletFormEffect.Deleted("mandiri")), effects)
    }

    @Test
    fun `deleting a wallet with transactions offers to archive it`() = runFormTest("mandiri") { vm, effects ->
        wallets.deleteResult = Outcome.Failure(WalletError.HasTransactions)

        send(vm, WalletFormIntent.Delete, WalletFormIntent.ConfirmDelete)
        assertEquals(WalletFormDialog.ArchiveInstead, vm.state.value.dialog)

        send(vm, WalletFormIntent.ConfirmArchive)

        assertNull(vm.state.value.dialog)
        assertEquals(listOf("mandiri" to WalletChanges(isArchived = true)), wallets.updates)
        assertEquals(listOf<WalletFormEffect>(WalletFormEffect.Close), effects)
    }

    @Test
    fun `a wallet that can't be loaded shows the error`() = runTest(mainDispatcherRule.dispatcher) {
        wallets.refreshWalletResult = Outcome.Failure(WalletError.NotFound)
        val vm = viewModel("gone")
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { vm.state.collect {} }
        advanceUntilIdle()

        assertFalse(vm.state.value.isLoading)
        assertEquals(UiText.Resource(R.string.wallets_error_not_found), vm.state.value.loadError)
    }
}
