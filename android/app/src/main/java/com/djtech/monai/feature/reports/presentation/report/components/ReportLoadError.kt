package com.djtech.monai.feature.reports.presentation.report.components

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Replaces the report when a month with nothing cached failed to load. */
@Composable
internal fun ReportLoadError(message: UiText, onRetry: () -> Unit, modifier: Modifier = Modifier) {
    MonAIStateMessage(
        icon = MonAIIcons.Error,
        title = stringResource(R.string.report_error_title),
        message = message.asString(),
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = MonAITheme.spacing.x6, vertical = MonAITheme.spacing.x10),
        tone = MonAIAlertTone.Error,
        actionLabel = stringResource(R.string.report_try_again),
        actionIcon = MonAIIcons.Refresh,
        onAction = onRetry,
    )
}
