package com.djtech.monai.feature.settings.presentation.settings.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIRadioOption
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.AppLanguage

/** The language picker as a bottom sheet. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun SettingsLanguageSheet(
    selected: AppLanguage,
    onPick: (AppLanguage) -> Unit,
    onDismiss: () -> Unit,
) {
    MonAIBottomSheet(onDismissRequest = onDismiss, title = stringResource(R.string.settings_language)) {
        SettingsLanguageOptions(selected, onPick)
        MonAIButton(
            stringResource(R.string.settings_done),
            onClick = onDismiss,
            modifier = Modifier.fillMaxWidth(),
            variant = MonAIButtonVariant.Tonal,
        )
    }
}

/** Indonesian and English, then how a transaction row reads in the current one. */
@Composable
internal fun SettingsLanguageOptions(
    selected: AppLanguage,
    onPick: (AppLanguage) -> Unit,
    modifier: Modifier = Modifier,
) {
    val effective = selected.effective()
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
        Column(Modifier.selectableGroup(), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
            LanguageOption(
                code = "ID",
                title = stringResource(R.string.settings_language_indonesian),
                subtitle = stringResource(R.string.settings_language_indonesian_native),
                selected = effective == AppLanguage.INDONESIAN,
                onClick = { onPick(AppLanguage.INDONESIAN) },
            )
            LanguageOption(
                code = "EN",
                title = stringResource(R.string.settings_language_english),
                subtitle = stringResource(R.string.settings_language_english_native),
                selected = effective == AppLanguage.ENGLISH,
                onClick = { onPick(AppLanguage.ENGLISH) },
            )
        }
        LanguagePreview()
        Text(
            stringResource(R.string.settings_language_note),
            style = MonAITheme.typography.bodySmall,
            color = MonAITheme.colors.textTertiary,
        )
    }
}

@Composable
private fun LanguageOption(
    code: String,
    title: String,
    subtitle: String,
    selected: Boolean,
    onClick: () -> Unit,
) {
    val colors = MonAITheme.colors
    MonAIRadioOption(
        title = title,
        selected = selected,
        onClick = onClick,
        subtitle = subtitle,
        leading = {
            Box(
                Modifier
                    .size(MonAITheme.sizes.avatarMedium)
                    .clip(CircleShape)
                    .background(colors.surfaceSunken),
                contentAlignment = Alignment.Center,
            ) {
                Text(code, style = MonAITheme.typography.labelLarge, color = colors.textSecondary)
            }
        },
    )
}

/** A sample expense row in the app's current language; decorative, so hidden from accessibility. */
@Composable
private fun LanguagePreview() {
    val colors = MonAITheme.colors
    Column(
        Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(MonAITheme.radius.mdl))
            .background(colors.surfaceSunken)
            .padding(MonAITheme.spacing.x3)
            .clearAndSetSemantics {},
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        Text(
            stringResource(R.string.settings_language_preview).uppercase(),
            style = MonAITheme.extendedTypography.overline,
            color = colors.textTertiary,
        )
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            MonAICategoryIcon(MonAIIcons.Restaurant, colors.expense)
            Column(Modifier.weight(1f)) {
                Text(
                    stringResource(R.string.settings_language_preview_title),
                    style = MonAITheme.typography.titleSmall,
                    color = colors.textPrimary,
                )
                Text(
                    stringResource(R.string.settings_language_preview_meta),
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                )
            }
            Text(
                formatRupiahSigned(SAMPLE_AMOUNT, MoneySign.Negative),
                style = MonAITheme.extendedTypography.amount,
                color = colors.textPrimary,
            )
        }
    }
}

private const val SAMPLE_AMOUNT = 35_000L
