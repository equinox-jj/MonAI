package com.djtech.monai.feature.wallets.presentation.wallets.components

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons

/** Shown in place of the cards when the user has no active wallets. */
@Composable
internal fun WalletsEmpty(onAdd: () -> Unit, modifier: Modifier = Modifier) {
    MonAICard(modifier.fillMaxWidth(), contentPadding = PaddingValues(horizontal = 24.dp, vertical = 32.dp)) {
        MonAIStateMessage(
            icon = MonAIIcons.AccountBalanceWallet,
            title = stringResource(R.string.wallets_empty_title),
            message = stringResource(R.string.wallets_empty_body),
            modifier = Modifier.fillMaxWidth(),
            actionLabel = stringResource(R.string.wallets_add),
            actionIcon = MonAIIcons.Add,
            onAction = onAdd,
        )
    }
}
