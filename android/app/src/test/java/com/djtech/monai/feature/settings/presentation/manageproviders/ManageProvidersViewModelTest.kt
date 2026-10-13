package com.djtech.monai.feature.settings.presentation.manageproviders

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Permissions
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.user
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.repository.FakeAdminProviderRepository
import com.djtech.monai.feature.settings.domain.repository.adminProvider
import com.djtech.monai.feature.settings.domain.usecase.DeleteProviderUseCase
import com.djtech.monai.feature.settings.domain.usecase.GetAdminProvidersUseCase
import com.djtech.monai.feature.settings.domain.usecase.ObserveProviderChangesUseCase
import com.djtech.monai.feature.settings.presentation.manageproviders.model.ProviderStatus
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

class ManageProvidersViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val admin = user(
        permissions = setOf(
            Permissions.PAYMENT_PROVIDER_VIEW,
            Permissions.PAYMENT_PROVIDER_CREATE,
            Permissions.PAYMENT_PROVIDER_UPDATE,
        ),
    )
    private val profiles = FakeProfileRepository(admin)
    private val providers = FakeAdminProviderRepository(
        listOf(
            adminProvider(
                "cash",
                name = "Cash",
                type = WalletType.CASH,
                sortOrder = 0,
                isSystem = true,
            ),
            adminProvider(
                "gopay",
                name = "GoPay",
                type = WalletType.E_WALLET,
                aliases = listOf("gopay", "gpay"),
            ),
            adminProvider(
                "ovo",
                name = "OVO",
                type = WalletType.E_WALLET,
                isActive = false,
            ),
        ),
    )
    private val events = ProviderChangeEvents()

    private fun runListTest(
        block: suspend TestScope.(ManageProvidersViewModel, MutableList<ManageProvidersEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = ManageProvidersViewModel(
            ObserveUserUseCase(profiles),
            GetAdminProvidersUseCase(providers),
            ObserveProviderChangesUseCase(events),
        )
        val effects = mutableListOf<ManageProvidersEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: ManageProvidersViewModel, vararg intents: ManageProvidersIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `lists every provider with its status`() = runListTest { vm, _ ->
        val state = vm.state.value

        assertFalse(state.isLoading)
        assertEquals(listOf("cash", "gopay", "ovo"), state.rows.map { it.id })
        assertEquals(
            listOf(ProviderStatus.SYSTEM, ProviderStatus.ACTIVE, ProviderStatus.INACTIVE),
            state.rows.map { it.status },
        )
        assertEquals("gopay, gpay", state.rows[1].aliases)
        assertTrue(state.canCreate)
        assertTrue(state.canEdit)
    }

    @Test
    fun `searches names and aliases`() = runListTest { vm, _ ->
        send(vm, ManageProvidersIntent.QueryChanged("gpay"))
        assertEquals(listOf("gopay"), vm.state.value.rows.map { it.id })

        send(vm, ManageProvidersIntent.QueryChanged("nothing"))
        assertTrue(vm.state.value.rows.isEmpty())
        assertEquals(3, vm.state.value.totalCount)
    }

    @Test
    fun `reloads when a provider changes elsewhere`() = runListTest { vm, _ ->
        DeleteProviderUseCase(providers, events)("ovo")
        advanceUntilIdle()

        assertEquals(listOf("cash", "gopay"), vm.state.value.rows.map { it.id })
    }

    @Test
    fun `a failed first load shows the error, and retry recovers`() = runTest(mainDispatcherRule.dispatcher) {
        providers.listError = AdminProviderError.Network

        runListTest { vm, _ ->
            assertEquals(UiText.Resource(R.string.provider_error_network), vm.state.value.loadError)

            providers.listError = null
            send(vm, ManageProvidersIntent.Refresh)
            assertNull(vm.state.value.loadError)
            assertEquals(3, vm.state.value.rows.size)
        }
    }

    @Test
    fun `add and open go to the form only with the permission`() = runListTest { vm, effects ->
        send(vm, ManageProvidersIntent.Add, ManageProvidersIntent.Open("gopay"))
        assertEquals(
            listOf(ManageProvidersEffect.OpenForm(null), ManageProvidersEffect.OpenForm("gopay")),
            effects,
        )

        profiles.user.value = user(permissions = setOf(Permissions.PAYMENT_PROVIDER_VIEW))
        advanceUntilIdle()
        send(vm, ManageProvidersIntent.Add, ManageProvidersIntent.Open("gopay"))
        assertEquals(2, effects.size)
    }
}
