package com.djtech.monai.feature.transactions.presentation.transactions.components

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

/** Takes the list's place when the month's first page failed with nothing cached. */
@Composable
internal fun TransactionsLoadError(
    isOffline: Boolean,
    onRetry: () -> Unit,
    modifier: Modifier = Modifier,
) {
    MonAIStateMessage(
        icon = if (isOffline) MonAIIcons.CloudOff else MonAIIcons.Error,
        title = stringResource(R.string.transactions_error_title),
        message = stringResource(
            if (isOffline) R.string.transactions_load_failed_network else R.string.transactions_load_failed_unexpected,
        ),
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = MonAITheme.spacing.x6, vertical = MonAITheme.spacing.x10),
        tone = MonAIAlertTone.Error,
        actionLabel = stringResource(R.string.transaction_try_again),
        actionIcon = MonAIIcons.Refresh,
        onAction = onRetry,
    )
}
