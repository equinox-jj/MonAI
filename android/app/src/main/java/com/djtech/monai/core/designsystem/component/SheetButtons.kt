package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** The two equal buttons at the foot of a picker sheet: an outlined one and the main action. */
@Composable
fun MonAISheetButtons(
    secondaryLabel: String,
    onSecondary: () -> Unit,
    primaryLabel: String,
    onPrimary: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Row(
        modifier
            .fillMaxWidth()
            .padding(top = MonAITheme.spacing.x1),
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        MonAIButton(
            secondaryLabel,
            onSecondary,
            Modifier.weight(1f),
            variant = MonAIButtonVariant.Outlined,
            size = MonAIButtonSize.Medium,
        )
        MonAIButton(
            primaryLabel,
            onPrimary,
            Modifier.weight(1f),
            size = MonAIButtonSize.Medium,
        )
    }
}
