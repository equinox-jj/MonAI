package com.djtech.monai.feature.transactions.presentation.search.components

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Before anything is typed and with no recent searches yet. */
@Composable
internal fun SearchPrompt(modifier: Modifier = Modifier) {
    MonAIStateMessage(
        icon = MonAIIcons.Search,
        title = stringResource(R.string.transaction_search_prompt_title),
        message = stringResource(R.string.transaction_search_prompt_body),
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = MonAITheme.spacing.x6, vertical = MonAITheme.spacing.x10),
    )
}
