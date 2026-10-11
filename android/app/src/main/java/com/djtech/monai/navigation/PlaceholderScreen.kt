package com.djtech.monai.navigation

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Stands in for a destination whose feature screen is not built yet. */
@Composable
internal fun PlaceholderScreen(title: String, modifier: Modifier = Modifier) {
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background)
            .safeDrawingPadding(),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = title,
            style = MonAITheme.typography.headlineSmall,
            color = MonAITheme.colors.textPrimary,
            modifier = Modifier.semantics { heading() },
        )
    }
}
