package com.djtech.monai.feature.quickadd.presentation.quickadd.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** "Try an example": three phrases that fill the input when tapped. */
@Composable
internal fun QuickAddExamples(onPick: (String) -> Unit, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    val examples = listOf(
        stringResource(R.string.quick_add_example_1),
        stringResource(R.string.quick_add_example_2),
        stringResource(R.string.quick_add_example_3),
    )
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5)) {
        Text(
            stringResource(R.string.quick_add_examples),
            style = MonAITheme.typography.labelMedium,
            color = colors.textSecondary,
        )
        examples.forEach { example ->
            Text(
                "“$example”",
                Modifier
                    .fillMaxWidth()
                    .heightIn(min = MonAITheme.sizes.touchTarget)
                    .clip(shape)
                    .background(colors.surface)
                    .border(MonAITheme.sizes.border, colors.border, shape)
                    .clickable(role = Role.Button) { onPick(example) }
                    .padding(horizontal = MonAITheme.spacing.x3, vertical = MonAITheme.spacing.x2_5),
                style = MonAITheme.typography.bodyMedium,
                color = colors.iconStrong,
            )
        }
    }
}
