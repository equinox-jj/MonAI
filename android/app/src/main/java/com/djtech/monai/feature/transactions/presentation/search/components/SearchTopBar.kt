package com.djtech.monai.feature.transactions.presentation.search.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAISearchField
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.presentation.search.SearchIntent

/** Back and the search field, which takes focus when the screen opens. */
@Composable
internal fun SearchTopBar(
    query: String,
    onIntent: (SearchIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val focusRequester = remember { FocusRequester() }
    val keyboard = LocalSoftwareKeyboardController.current
    LaunchedEffect(Unit) { focusRequester.requestFocus() }
    Row(
        modifier
            .fillMaxWidth()
            .padding(end = MonAITheme.spacing.screenHorizontal, start = MonAITheme.spacing.x1_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        MonAIIconButton(
            MonAIIcons.ArrowBack,
            stringResource(R.string.transaction_search_back),
            onClick = { onIntent(SearchIntent.Back) },
        )
        MonAISearchField(
            value = query,
            onValueChange = { text ->
                onIntent(if (text.isEmpty()) SearchIntent.ClearQuery else SearchIntent.QueryChanged(text))
            },
            placeholder = stringResource(R.string.transactions_search_hint),
            modifier = Modifier
                .weight(1f)
                .focusRequester(focusRequester),
            keyboardActions = KeyboardActions(
                onSearch = {
                    keyboard?.hide()
                    onIntent(SearchIntent.Submit)
                },
            ),
            clearContentDescription = stringResource(R.string.transaction_search_clear),
        )
    }
}
