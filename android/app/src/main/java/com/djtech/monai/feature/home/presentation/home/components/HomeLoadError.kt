package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.home.presentation.home.HomeIntent

/** Replaces the dashboard when the first load failed with nothing cached. */
@Composable
internal fun HomeLoadError(
    message: UiText,
    onIntent: (HomeIntent) -> Unit,
    contentPadding: PaddingValues,
) {
    Box(
        Modifier
            .fillMaxSize()
            .padding(contentPadding)
            .padding(horizontal = MonAITheme.spacing.x10),
        contentAlignment = Alignment.Center,
    ) {
        MonAIStateMessage(
            icon = MonAIIcons.Error,
            title = stringResource(R.string.home_error_title),
            message = message.asString(),
            tone = MonAIAlertTone.Error,
            actionLabel = stringResource(R.string.home_try_again),
            actionIcon = MonAIIcons.Refresh,
            onAction = { onIntent(HomeIntent.Refresh) },
        )
    }
}
