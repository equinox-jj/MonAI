package com.djtech.monai.feature.settings.presentation.settings.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.DarkMonAIColors
import com.djtech.monai.core.designsystem.theme.LightMonAIColors
import com.djtech.monai.core.designsystem.theme.MonAIColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.ThemeMode

/** The theme picker as a bottom sheet. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun SettingsThemeSheet(
    selected: ThemeMode,
    onPick: (ThemeMode) -> Unit,
    onDismiss: () -> Unit,
) {
    MonAIBottomSheet(onDismissRequest = onDismiss, title = stringResource(R.string.settings_theme)) {
        SettingsThemeOptions(selected, onPick)
        MonAIButton(
            stringResource(R.string.settings_done),
            onClick = onDismiss,
            modifier = Modifier.fillMaxWidth(),
            variant = MonAIButtonVariant.Tonal,
        )
    }
}

/** System, Light and Dark side by side, each drawn as a tiny screen in its colors. */
@Composable
internal fun SettingsThemeOptions(
    selected: ThemeMode,
    onPick: (ThemeMode) -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3_5)) {
        Row(
            Modifier
                .fillMaxWidth()
                .selectableGroup(),
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            ThemeMode.entries.forEach { mode ->
                ThemeOption(
                    mode,
                    isSelected = mode == selected,
                    onClick = { onPick(mode) },
                    modifier = Modifier.weight(1f),
                )
            }
        }
        Text(
            stringResource(R.string.settings_theme_note),
            style = MonAITheme.typography.bodySmall,
            color = MonAITheme.colors.textTertiary,
        )
    }
}

@Composable
private fun ThemeOption(
    mode: ThemeMode,
    isSelected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.lg)
    Column(
        modifier
            .clip(shape)
            .selectable(selected = isSelected, role = Role.RadioButton, onClick = onClick),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        Row(
            Modifier
                .fillMaxWidth()
                .aspectRatio(PREVIEW_RATIO)
                .clip(shape)
                .border(
                    if (isSelected) MonAITheme.sizes.borderFocused + 1.dp else MonAITheme.sizes.border,
                    if (isSelected) colors.focus else colors.border,
                    shape,
                ),
        ) {
            if (mode != ThemeMode.DARK) MiniScreen(LightMonAIColors, Modifier.weight(1f))
            if (mode != ThemeMode.LIGHT) MiniScreen(DarkMonAIColors, Modifier.weight(1f))
        }
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
        ) {
            Icon(
                if (isSelected) MonAIIcons.RadioButtonChecked else MonAIIcons.RadioButtonUnchecked,
                contentDescription = null,
                modifier = Modifier.size(MonAITheme.sizes.iconMd),
                tint = if (isSelected) colors.accent else colors.textDisabled,
            )
            Text(mode.label(), style = MonAITheme.typography.titleSmall, color = colors.textPrimary)
        }
    }
}

/** A header bar, two cards and a button, in [palette]'s colors whatever the app's theme. */
@Composable
private fun MiniScreen(palette: MonAIColors, modifier: Modifier = Modifier) {
    val bar = RoundedCornerShape(MonAITheme.radius.xs)
    Column(
        modifier
            .fillMaxHeight()
            .background(palette.background)
            .padding(MonAITheme.spacing.x2),
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        Box(
            Modifier
                .fillMaxWidth(HEADER_WIDTH)
                .height(MonAITheme.spacing.x1_5)
                .clip(bar)
                .background(palette.textPrimary),
        )
        Box(
            Modifier
                .fillMaxWidth()
                .weight(1f)
                .clip(bar)
                .background(palette.surface),
        )
        Box(
            Modifier
                .fillMaxWidth()
                .weight(1f)
                .clip(bar)
                .background(palette.surface),
        )
        Box(
            Modifier
                .size(MonAITheme.spacing.x3)
                .clip(CircleShape)
                .background(palette.primary)
                .align(Alignment.End),
        )
    }
}

private const val PREVIEW_RATIO = 0.75f
private const val HEADER_WIDTH = 0.6f
