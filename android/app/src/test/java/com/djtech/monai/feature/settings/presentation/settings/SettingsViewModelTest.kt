package com.djtech.monai.feature.settings.presentation.settings

import com.djtech.monai.R
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.locale.FakeAppLocaleManager
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.datastore.InMemoryPreferencesDataStore
import com.djtech.monai.core.datastore.ThemePreferenceStore
import com.djtech.monai.core.model.AppLanguage
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.Permissions
import com.djtech.monai.core.model.Role
import com.djtech.monai.core.model.ThemeMode
import com.djtech.monai.core.model.budget
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.user
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.auth.domain.model.AuthError
import com.djtech.monai.feature.auth.domain.usecase.FakeAuthRepository
import com.djtech.monai.feature.auth.domain.usecase.LogoutAllDevicesUseCase
import com.djtech.monai.feature.auth.domain.usecase.LogoutUseCase
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.budgets.domain.usecase.ObserveBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.RefreshBudgetUseCase
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.RefreshCategoriesUseCase
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.profile.domain.usecase.RefreshUserUseCase
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsDialog
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsPane
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsProfile
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsSheet
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import kotlinx.coroutines.flow.first
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

class SettingsViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val profiles = FakeProfileRepository(user(name = "Sari Putri"))
    private val budgets = FakeBudgetRepository(budget(limit = 3_000_000))
    private val categories = FakeCategoryRepository(listOf(category("food"), category("salary")))
    private val wallets = FakeWalletRepository(listOf(wallet("bca"), wallet("cash")))
    private val auth = FakeAuthRepository()
    private val themeStore = ThemePreferenceStore(InMemoryPreferencesDataStore())
    private val locales = FakeAppLocaleManager()

    private fun runSettingsTest(block: suspend TestScope.(SettingsViewModel, MutableList<SettingsEffect>) -> Unit) =
        runTest(mainDispatcherRule.dispatcher) {
            val viewModel = SettingsViewModel(
                observeUser = ObserveUserUseCase(profiles),
                refreshUser = RefreshUserUseCase(profiles),
                observeBudget = ObserveBudgetUseCase(budgets),
                refreshBudget = RefreshBudgetUseCase(budgets),
                observeCategories = ObserveCategoriesUseCase(categories),
                refreshCategories = RefreshCategoriesUseCase(categories),
                observeWallets = ObserveWalletsUseCase(wallets),
                logout = LogoutUseCase(auth),
                logoutAllDevices = LogoutAllDevicesUseCase(auth),
                themePreferenceStore = themeStore,
                localeManager = locales,
                clock = FixedAppClock(NOW),
            )
            val effects = mutableListOf<SettingsEffect>()
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
            backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
            advanceUntilIdle()
            block(viewModel, effects)
        }

    private fun TestScope.send(viewModel: SettingsViewModel, vararg intents: SettingsIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `shows the cached user, budget and counts, and refreshes them`() = runSettingsTest { vm, _ ->
        val state = vm.state.value

        assertEquals(
            SettingsProfile(
                name = "Sari Putri",
                email = "joshua@example.com",
                initials = "SP",
                avatarUrl = null,
                roleBadge = null,
            ),
            state.profile,
        )
        assertEquals(OCTOBER, state.month)
        assertEquals(3_000_000L, state.budgetLimit)
        assertEquals(2, state.categoryCount)
        assertEquals(2, state.walletCount)
        assertFalse(state.showAdmin)
        assertEquals(1, profiles.refreshCount)
        assertEquals(listOf(OCTOBER), budgets.refreshedMonths)
        assertEquals(1, categories.refreshCount)
    }

    @Test
    fun `a month without a budget shows none`() = runSettingsTest { vm, _ ->
        budgets.budgets.value = emptyMap()
        advanceUntilIdle()

        assertNull(vm.state.value.budgetLimit)
    }

    @Test
    fun `provider managers get the admin section and a role badge`() = runSettingsTest { vm, _ ->
        profiles.user.value = user(
            role = Role(slug = "admin", name = "Admin"),
            permissions = setOf(Permissions.PAYMENT_PROVIDER_VIEW, Permissions.PAYMENT_PROVIDER_CREATE),
        )
        advanceUntilIdle()

        assertTrue(vm.state.value.showAdmin)
        assertEquals("Admin", vm.state.value.profile?.roleBadge)
    }

    @Test
    fun `viewing the catalog alone is not enough for the admin section`() = runSettingsTest { vm, _ ->
        profiles.user.value = user(permissions = setOf(Permissions.PAYMENT_PROVIDER_VIEW))
        advanceUntilIdle()

        assertFalse(vm.state.value.showAdmin)
    }

    @Test
    fun `picking a theme saves it and closes the sheet`() = runSettingsTest { vm, _ ->
        send(vm, SettingsIntent.ShowSheet(SettingsSheet.Theme))
        assertEquals(SettingsSheet.Theme, vm.state.value.sheet)

        send(vm, SettingsIntent.PickTheme(ThemeMode.DARK))

        assertNull(vm.state.value.sheet)
        assertEquals(ThemeMode.DARK, vm.state.value.themeMode)
        assertEquals(ThemeMode.DARK, themeStore.themeMode.first())
    }

    @Test
    fun `picking a language applies it once`() = runSettingsTest { vm, _ ->
        send(
            vm,
            SettingsIntent.PickLanguage(AppLanguage.INDONESIAN),
            SettingsIntent.PickLanguage(AppLanguage.INDONESIAN),
        )

        assertEquals(AppLanguage.INDONESIAN, vm.state.value.language)
        assertEquals(AppLanguage.INDONESIAN, locales.current)
        assertEquals(1, locales.setCount)
    }

    @Test
    fun `signing out asks first`() = runSettingsTest { vm, _ ->
        send(vm, SettingsIntent.SignOut)
        assertEquals(SettingsDialog.SignOut, vm.state.value.dialog)
        assertTrue(auth.calls.isEmpty())

        send(vm, SettingsIntent.ConfirmDialog)

        assertNull(vm.state.value.dialog)
        assertEquals(listOf("logout"), auth.calls)
    }

    @Test
    fun `signing out of all devices that fails offline says so`() = runSettingsTest { vm, effects ->
        auth.unitResult = Outcome.Failure(AuthError.Network)

        send(vm, SettingsIntent.SignOutAllDevices, SettingsIntent.ConfirmDialog)

        assertEquals(listOf("logoutAllDevices"), auth.calls)
        assertFalse(vm.state.value.isSigningOut)
        assertEquals(
            SettingsEffect.ShowMessage(UiText.Resource(R.string.settings_error_network), isOffline = true),
            effects.single(),
        )
    }

    @Test
    fun `dismissing the dialog does nothing`() = runSettingsTest { vm, _ ->
        send(vm, SettingsIntent.SignOut, SettingsIntent.DismissDialog)

        assertNull(vm.state.value.dialog)
        assertTrue(auth.calls.isEmpty())
    }

    @Test
    fun `links are forwarded as navigation`() = runSettingsTest { vm, effects ->
        send(vm, SettingsIntent.Open(SettingsDestination.Categories))

        assertEquals(listOf<SettingsEffect>(SettingsEffect.Navigate(SettingsDestination.Categories)), effects)
    }

    @Test
    fun `the providers pane falls back to the profile without the permission`() = runSettingsTest { vm, _ ->
        send(vm, SettingsIntent.SelectPane(SettingsPane.Providers))

        assertEquals(SettingsPane.Profile, vm.state.value.pane)

        send(vm, SettingsIntent.SelectPane(SettingsPane.Theme))
        assertEquals(SettingsPane.Theme, vm.state.value.pane)
    }
}
