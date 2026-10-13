package com.djtech.monai.feature.settings.presentation.providerform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** The aliases as removable chips, and a field that adds one on Enter or a comma. */
@OptIn(ExperimentalLayoutApi::class)
@Composable
internal fun ProviderFormAliases(
    aliases: List<String>,
    input: String,
    error: String?,
    enabled: Boolean,
    onInputChange: (String) -> Unit,
    onAdd: () -> Unit,
    onRemove: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.fieldLabelGap)) {
        Text(
            stringResource(R.string.provider_form_aliases),
            style = MonAITheme.typography.labelMedium,
            color = colors.textSecondary,
        )
        if (aliases.isNotEmpty()) {
            FlowRow(
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
                verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
            ) {
                aliases.forEach { alias -> AliasChip(alias, enabled, onRemove = { onRemove(alias) }) }
            }
        }
        MonAITextField(
            value = input,
            onValueChange = onInputChange,
            placeholder = stringResource(
                if (aliases.isEmpty()) R.string.provider_form_alias_placeholder else R.string.provider_form_alias_add,
            ),
            supportingText = error ?: stringResource(R.string.provider_form_aliases_note),
            tone = if (error != null) MonAIFieldTone.Error else MonAIFieldTone.Neutral,
            enabled = enabled,
            keyboardOptions = KeyboardOptions(
                capitalization = KeyboardCapitalization.None,
                autoCorrectEnabled = false,
                imeAction = ImeAction.Done,
            ),
            keyboardActions = KeyboardActions(onDone = { onAdd() }),
        )
    }
}

@Composable
private fun AliasChip(alias: String, enabled: Boolean, onRemove: () -> Unit) {
    val colors = MonAITheme.colors
    Row(
        Modifier
            .clip(CircleShape)
            .background(colors.primaryContainer)
            .padding(start = MonAITheme.spacing.x3),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(alias, style = MonAITheme.typography.labelLarge, color = colors.onPrimaryContainer)
        MonAIIconButton(
            MonAIIcons.Close,
            stringResource(R.string.provider_form_alias_remove, alias),
            onClick = onRemove,
            tint = colors.onPrimaryContainer,
            size = MonAITheme.sizes.buttonSmall,
            iconSize = MonAITheme.sizes.iconSm,
            enabled = enabled,
        )
    }
}
