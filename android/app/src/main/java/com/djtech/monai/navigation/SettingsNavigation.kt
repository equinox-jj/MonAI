package com.djtech.monai.navigation

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation3.runtime.EntryProviderScope
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.designsystem.component.ScreenPlacement
import com.djtech.monai.feature.auth.presentation.changepassword.ChangePasswordRoute
import com.djtech.monai.feature.budgets.presentation.budget.BudgetRoute
import com.djtech.monai.feature.categories.presentation.categories.CategoriesDestination
import com.djtech.monai.feature.categories.presentation.categories.CategoriesRoute
import com.djtech.monai.feature.categories.presentation.categoryform.CategoryFormRoute
import com.djtech.monai.feature.profile.presentation.editprofile.EditProfileRoute
import com.djtech.monai.feature.settings.presentation.manageproviders.ManageProvidersRoute
import com.djtech.monai.feature.settings.presentation.providerform.ProviderFormRoute
import com.djtech.monai.feature.settings.presentation.settings.SettingsDestination
import com.djtech.monai.feature.settings.presentation.settings.SettingsRoute
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsPane
import java.time.YearMonth

/** Where Settings' rows lead; Wallets is its own tab. */
internal fun MainNavigator.openFromSettings(destination: SettingsDestination) {
    when (destination) {
        is SettingsDestination.EditProfile -> navigate(EditProfileRoute(destination.focusDelete))
        is SettingsDestination.Budget -> navigate(BudgetRoute(destination.month.toApiString()))
        SettingsDestination.Categories -> navigate(CategoriesRoute)
        SettingsDestination.Wallets -> selectTab(TopLevelDestination.Wallets)
        SettingsDestination.ManageProviders -> navigate(ManageProvidersRoute)
        SettingsDestination.ChangePassword -> navigate(ChangePasswordRoute)
    }
}

/** The category form, to add one of the shown type or edit one. */
internal fun MainNavigator.openFromCategories(destination: CategoriesDestination) {
    navigate(
        when (destination) {
            is CategoriesDestination.New -> CategoryFormRoute(destination.type)
            is CategoriesDestination.Edit -> CategoryFormRoute(destination.type, destination.id)
        },
    )
}

/** The provider form: [id] null adds a provider. */
internal fun MainNavigator.openProviderForm(id: String?) {
    navigate(ProviderFormRoute(id))
}

/** The Settings tab with its panes, and the screens its rows open. */
internal fun EntryProviderScope<NavKey>.settingsEntries(navigator: MainNavigator, config: MainNavConfig) {
    entry<SettingsRoute>(metadata = config.tabRootMetadata) {
        SettingsRoute(
            onNavigate = navigator::openFromSettings,
            detailPane = { pane, month, paneModifier ->
                SettingsDetailPane(
                    navigator,
                    pane,
                    month,
                    paneModifier,
                )
            },
        )
    }
    entry<EditProfileRoute> { key ->
        EditProfileRoute(onClose = navigator::goBack, focusDelete = key.focusDelete)
    }
    entry<ChangePasswordRoute> {
        ChangePasswordRoute(onClose = navigator::goBack)
    }
    entry<CategoriesRoute> {
        CategoriesRoute(onNavigate = navigator::openFromCategories, onBack = navigator::goBack)
    }
    formEntry<CategoryFormRoute>(config) { key, modifier, placement ->
        CategoryFormRoute(
            type = key.type,
            onClose = navigator::goBack,
            modifier = modifier,
            categoryId = key.id,
            placement = placement,
        )
    }
    entry<ManageProvidersRoute> {
        ManageProvidersRoute(onOpenForm = navigator::openProviderForm, onBack = navigator::goBack)
    }
    formEntry<ProviderFormRoute>(config) { key, modifier, placement ->
        ProviderFormRoute(
            providerId = key.id,
            onClose = navigator::goBack,
            modifier = modifier,
            placement = placement,
        )
    }
}

/** A Settings section beside the menu on a wide screen; its forms open over it as side sheets. */
@Composable
private fun SettingsDetailPane(
    navigator: MainNavigator,
    pane: SettingsPane,
    month: YearMonth,
    modifier: Modifier,
) {
    when (pane) {
        SettingsPane.Profile -> EditProfileRoute(onClose = {}, modifier = modifier, placement = ScreenPlacement.Pane)
        SettingsPane.Budget -> BudgetRoute(
            month = month,
            onClose = {},
            modifier = modifier,
            placement = ScreenPlacement.Pane,
        )

        SettingsPane.Categories -> CategoriesRoute(
            onNavigate = navigator::openFromCategories,
            onBack = {},
            modifier = modifier,
            placement = ScreenPlacement.Pane,
        )

        SettingsPane.Providers -> ManageProvidersRoute(
            onOpenForm = navigator::openProviderForm,
            onBack = {},
            modifier = modifier,
            placement = ScreenPlacement.Pane,
        )

        // Drawn by Settings itself.
        SettingsPane.Theme, SettingsPane.Language, SettingsPane.Export -> Unit
    }
}
