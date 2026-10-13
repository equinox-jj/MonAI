package com.djtech.monai.feature.settings.presentation.manageproviders

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.settings.presentation.manageproviders.model.ProviderRow

/**
 * @param isLoading the first load is running.
 * @param loadError the last load failed and nothing is shown.
 * @param rows providers matching [query], by sort order.
 * @param totalCount every provider, for the empty state.
 * @param canCreate the user may add providers.
 * @param canEdit the user may open a provider to change it.
 */
@Immutable
data class ManageProvidersState(
    val isLoading: Boolean = true,
    val loadError: UiText? = null,
    val isRefreshing: Boolean = false,
    val query: String = "",
    val rows: List<ProviderRow> = emptyList(),
    val totalCount: Int = 0,
    val canCreate: Boolean = false,
    val canEdit: Boolean = false,
)

sealed interface ManageProvidersIntent {
    data class QueryChanged(val query: String) : ManageProvidersIntent

    /** Pull-to-refresh and the error's retry. */
    data object Refresh : ManageProvidersIntent

    data object Back : ManageProvidersIntent

    data object Add : ManageProvidersIntent

    data class Open(val id: String) : ManageProvidersIntent
}

sealed interface ManageProvidersEffect {
    data object Close : ManageProvidersEffect

    /** The provider form: [id] null adds one. */
    data class OpenForm(val id: String?) : ManageProvidersEffect

    data class ShowMessage(val message: UiText) : ManageProvidersEffect
}
