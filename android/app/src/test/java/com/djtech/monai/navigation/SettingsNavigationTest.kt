package com.djtech.monai.navigation

import androidx.compose.runtime.mutableStateOf
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.feature.categories.presentation.categories.CategoriesDestination
import com.djtech.monai.feature.settings.presentation.settings.SettingsDestination
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class SettingsNavigationTest {

    private val navigator = MainNavigator(
        stacks = TopLevelDestination.entries.associateWith { NavBackStack<NavKey>(it.route) },
        currentTab = mutableStateOf(TopLevelDestination.Settings),
    )

    @Test
    fun `settings rows open on the settings tab`() {
        navigator.openFromSettings(SettingsDestination.EditProfile(focusDelete = true))
        navigator.openFromSettings(SettingsDestination.Budget(OCTOBER))
        navigator.openFromSettings(SettingsDestination.Categories)
        navigator.openFromSettings(SettingsDestination.ManageProviders)

        assertEquals(
            listOf(
                HomeRoute,
                SettingsRoute,
                EditProfileRoute(focusDelete = true),
                BudgetRoute("2026-10"),
                CategoriesRoute,
                ManageProvidersRoute,
            ),
            navigator.backStack,
        )
    }

    @Test
    fun `wallets switches to its tab`() {
        navigator.openFromSettings(SettingsDestination.Wallets)

        assertEquals(TopLevelDestination.Wallets, navigator.currentTab)
        assertEquals(listOf(HomeRoute, WalletsRoute), navigator.backStack)
    }

    @Test
    fun `categories open the form to add or edit`() {
        navigator.openFromCategories(CategoriesDestination.New(CategoryType.INCOME))
        navigator.openFromCategories(CategoriesDestination.Edit(CategoryType.EXPENSE, "kopi"))

        assertEquals(
            listOf(
                HomeRoute,
                SettingsRoute,
                CategoryFormRoute(CategoryType.INCOME),
                CategoryFormRoute(CategoryType.EXPENSE, "kopi"),
            ),
            navigator.backStack,
        )
    }

    @Test
    fun `providers open the form to add or edit`() {
        navigator.openProviderForm(null)
        navigator.openProviderForm("ovo")

        assertEquals(
            listOf(HomeRoute, SettingsRoute, ProviderFormRoute(), ProviderFormRoute("ovo")),
            navigator.backStack,
        )
    }

    @Test
    fun `settings screens take the whole phone screen`() {
        assertFalse(SettingsRoute.isFullScreen())
        assertTrue(EditProfileRoute().isFullScreen())
        assertTrue(CategoriesRoute.isFullScreen())
        assertTrue(ManageProvidersRoute.isFullScreen())
        assertTrue(ProviderFormRoute().isFullScreen())
    }
}
