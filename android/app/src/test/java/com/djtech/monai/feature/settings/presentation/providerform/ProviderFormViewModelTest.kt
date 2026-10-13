package com.djtech.monai.feature.settings.presentation.providerform

import com.djtech.monai.R
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.Permissions
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.user
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.settings.domain.event.ProviderChangeEvents
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.ProviderChanges
import com.djtech.monai.feature.settings.domain.repository.FakeAdminProviderRepository
import com.djtech.monai.feature.settings.domain.repository.adminProvider
import com.djtech.monai.feature.settings.domain.usecase.CreateProviderUseCase
import com.djtech.monai.feature.settings.domain.usecase.DeleteProviderUseCase
import com.djtech.monai.feature.settings.domain.usecase.GetAdminProviderUseCase
import com.djtech.monai.feature.settings.domain.usecase.ProviderLogoUploader
import com.djtech.monai.feature.settings.domain.usecase.SetProviderActiveUseCase
import com.djtech.monai.feature.settings.domain.usecase.UpdateProviderUseCase
import com.djtech.monai.feature.settings.presentation.providerform.model.ProviderFormDialog
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

class ProviderFormViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val profiles = FakeProfileRepository(
        user(
            permissions = setOf(
                Permissions.PAYMENT_PROVIDER_CREATE,
                Permissions.PAYMENT_PROVIDER_UPDATE,
                Permissions.PAYMENT_PROVIDER_DELETE,
            ),
        ),
    )
    private val ovo = adminProvider(
        "ovo",
        name = "OVO",
        type = WalletType.E_WALLET,
        aliases = listOf("ovo"),
        sortOrder = 70,
    )
    private val providers = FakeAdminProviderRepository(listOf(ovo, adminProvider("cash", isSystem = true)))
    private val images = FakeImageProcessor()
    private val events = ProviderChangeEvents()

    private fun runFormTest(
        providerId: String? = null,
        block: suspend TestScope.(ProviderFormViewModel, MutableList<ProviderFormEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val logos = ProviderLogoUploader(providers, images)
        val viewModel = ProviderFormViewModel(
            providerId = providerId,
            observeUser = ObserveUserUseCase(profiles),
            getAdminProvider = GetAdminProviderUseCase(providers),
            createProvider = CreateProviderUseCase(providers, logos, events),
            updateProvider = UpdateProviderUseCase(providers, logos, events),
            setProviderActive = SetProviderActiveUseCase(providers, events),
            deleteProvider = DeleteProviderUseCase(providers, events),
            clock = FixedAppClock(NOW),
        )
        val effects = mutableListOf<ProviderFormEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: ProviderFormViewModel, vararg intents: ProviderFormIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `a new provider needs a name and type, and shows its future ID`() = runFormTest { vm, _ ->
        assertFalse(vm.state.value.isReady)

        send(vm, ProviderFormIntent.NameChanged("Link Aja"))
        assertEquals("link-aja", vm.state.value.slug)
        assertFalse(vm.state.value.isReady)

        send(vm, ProviderFormIntent.PickType(WalletType.E_WALLET))
        assertTrue(vm.state.value.isReady)
    }

    @Test
    fun `aliases are added on enter or comma, normalized and without repeats`() = runFormTest { vm, _ ->
        send(
            vm,
            ProviderFormIntent.AliasInputChanged("LinkAja"),
            ProviderFormIntent.AddAlias,
            ProviderFormIntent.AliasInputChanged("link aja, linkaja,"),
        )

        assertEquals(listOf("linkaja", "link aja"), vm.state.value.aliases)
        assertEquals("", vm.state.value.aliasInput)

        send(vm, ProviderFormIntent.RemoveAlias("linkaja"))
        assertEquals(listOf("link aja"), vm.state.value.aliases)
    }

    @Test
    fun `sort order takes digits only`() = runFormTest { vm, _ ->
        send(vm, ProviderFormIntent.SortOrderChanged("12a"), ProviderFormIntent.SortOrderChanged("-5"))

        assertEquals("-5", vm.state.value.sortOrder)
    }

    @Test
    fun `creating saves the typed alias too, then closes`() = runFormTest { vm, effects ->
        send(
            vm,
            ProviderFormIntent.NameChanged("LinkAja"),
            ProviderFormIntent.PickType(WalletType.E_WALLET),
            ProviderFormIntent.AliasInputChanged("linkaja"),
            ProviderFormIntent.SetActive(false),
            ProviderFormIntent.LogoPicked("content://logo"),
            ProviderFormIntent.Save,
        )

        val created = providers.providers.last()
        assertEquals("LinkAja", created.name)
        assertEquals(listOf("linkaja"), created.aliases)
        assertFalse(created.isActive)
        assertEquals("https://cdn.example.com/logos/${created.id}.webp", created.logoUrl)
        assertEquals(listOf<ProviderFormEffect>(ProviderFormEffect.Close), effects)
    }

    @Test
    fun `a conflict is shown and the form stays`() = runFormTest { vm, effects ->
        providers.createError = AdminProviderError.Conflict

        send(
            vm,
            ProviderFormIntent.NameChanged("GoPay"),
            ProviderFormIntent.PickType(WalletType.E_WALLET),
            ProviderFormIntent.Save,
        )

        assertEquals(
            listOf<ProviderFormEffect>(
                ProviderFormEffect.ShowMessage(UiText.Resource(R.string.provider_error_conflict)),
            ),
            effects,
        )
        assertFalse(vm.state.value.isSaving)
    }

    @Test
    fun `editing loads the provider and saves only the changes`() = runFormTest("ovo") { vm, effects ->
        val state = vm.state.value
        assertTrue(state.isEditing)
        assertEquals("OVO", state.name)
        assertEquals("70", state.sortOrder)
        assertEquals("ovo", state.slug)
        assertTrue(state.canDelete)
        assertEquals(LocalDate.of(2026, 10, 2), state.lastEdited)

        send(vm, ProviderFormIntent.SortOrderChanged("5"), ProviderFormIntent.Save)

        assertEquals(listOf("get(ovo)", "update(ovo, ${ProviderChanges(sortOrder = 5)})"), providers.calls)
        assertEquals(listOf<ProviderFormEffect>(ProviderFormEffect.Close), effects)
    }

    @Test
    fun `deactivating an existing provider asks first, then applies at once`() = runFormTest("ovo") { vm, _ ->
        send(vm, ProviderFormIntent.SetActive(false))
        assertEquals(ProviderFormDialog.Deactivate, vm.state.value.dialog)
        assertTrue(vm.state.value.isActive)

        send(vm, ProviderFormIntent.ConfirmDialog)

        assertNull(vm.state.value.dialog)
        assertFalse(vm.state.value.isActive)
        assertEquals("setActive(ovo, false)", providers.calls.last())

        send(vm, ProviderFormIntent.SetActive(true))
        assertTrue(vm.state.value.isActive)
    }

    @Test
    fun `a system provider can't be switched off or deleted`() = runFormTest("cash") { vm, _ ->
        assertTrue(vm.state.value.isSystem)
        assertFalse(vm.state.value.canDelete)

        send(vm, ProviderFormIntent.SetActive(false))

        assertNull(vm.state.value.dialog)
        assertTrue(vm.state.value.isActive)
    }

    @Test
    fun `deleting asks first, then closes`() = runFormTest("ovo") { vm, effects ->
        send(vm, ProviderFormIntent.Delete)
        assertEquals(ProviderFormDialog.Delete, vm.state.value.dialog)

        send(vm, ProviderFormIntent.ConfirmDialog)

        assertTrue(providers.providers.none { it.id == "ovo" })
        assertEquals(listOf<ProviderFormEffect>(ProviderFormEffect.Close), effects)
    }

    @Test
    fun `a missing provider shows the load error`() = runFormTest("gone") { vm, _ ->
        assertEquals(UiText.Resource(R.string.provider_error_not_found), vm.state.value.loadError)
    }

    @Test
    fun `without the update permission the form can't be saved`() = runFormTest("ovo") { vm, _ ->
        profiles.user.value = user(permissions = setOf(Permissions.PAYMENT_PROVIDER_VIEW))
        advanceUntilIdle()

        assertFalse(vm.state.value.canSave)
        assertFalse(vm.state.value.canDelete)
    }
}
