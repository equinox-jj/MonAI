package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** The detail pane on a wide screen before a transaction is picked. */
@Composable
internal fun TransactionsDetailPlaceholder(modifier: Modifier = Modifier) {
    Box(
        modifier
            .fillMaxSize()
            .padding(MonAITheme.spacing.x10),
        contentAlignment = Alignment.Center,
    ) {
        MonAIStateMessage(
            icon = MonAIIcons.ReceiptLong,
            title = stringResource(R.string.transactions_select_prompt_title),
            message = stringResource(R.string.transactions_select_prompt_body),
        )
    }
}
