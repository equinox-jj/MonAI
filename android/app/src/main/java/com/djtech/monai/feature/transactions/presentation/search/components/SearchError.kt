package com.djtech.monai.feature.transactions.presentation.search.components

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** A month search that failed. Offline, the device's saved transactions can still be searched. */
@Composable
internal fun SearchError(
    isOffline: Boolean,
    onRetry: () -> Unit,
    onSearchAllMonths: () -> Unit,
    modifier: Modifier = Modifier,
) {
    MonAIStateMessage(
        icon = if (isOffline) MonAIIcons.CloudOff else MonAIIcons.Error,
        title = stringResource(R.string.transactions_error_title),
        message = stringResource(
            if (isOffline) {
                R.string.transaction_search_failed_network
            } else {
                R.string.transaction_search_failed_unexpected
            },
        ),
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = MonAITheme.spacing.x6, vertical = MonAITheme.spacing.x10),
        tone = MonAIAlertTone.Error,
        actionLabel = stringResource(R.string.transaction_try_again),
        actionIcon = MonAIIcons.Refresh,
        onAction = onRetry,
        secondaryActionLabel = if (isOffline) stringResource(R.string.transaction_search_all_months) else null,
        onSecondaryAction = onSearchAllMonths,
    )
}
