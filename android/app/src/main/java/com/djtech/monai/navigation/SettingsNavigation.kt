package com.djtech.monai.navigation

import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.feature.categories.presentation.categories.CategoriesDestination
import com.djtech.monai.feature.settings.presentation.settings.SettingsDestination

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
