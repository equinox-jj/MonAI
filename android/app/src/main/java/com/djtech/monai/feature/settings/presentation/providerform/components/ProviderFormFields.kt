package com.djtech.monai.feature.settings.presentation.providerform.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.selection.toggleable
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.text.input.KeyboardType
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAISegment
import com.djtech.monai.core.designsystem.component.MonAISegmentedControl
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.WalletType

/** The name, with the ID the server makes from it. */
@Composable
internal fun ProviderFormName(
    name: String,
    slug: String,
    error: String?,
    enabled: Boolean,
    onNameChange: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    MonAITextField(
        value = name,
        onValueChange = onNameChange,
        modifier = modifier,
        label = stringResource(R.string.provider_form_name),
        placeholder = stringResource(R.string.provider_form_name_placeholder),
        supportingText = error ?: if (slug.isEmpty()) {
            stringResource(R.string.provider_form_id_pending)
        } else {
            stringResource(R.string.provider_form_id, slug)
        },
        tone = if (error != null) MonAIFieldTone.Error else MonAIFieldTone.Neutral,
        enabled = enabled,
        keyboardOptions = KeyboardOptions(capitalization = KeyboardCapitalization.Words, imeAction = ImeAction.Next),
    )
}

/** Cash, Bank, E-wallet or Other; none picked on a new provider. */
@Composable
internal fun ProviderFormType(
    type: WalletType?,
    enabled: Boolean,
    onPick: (WalletType) -> Unit,
    modifier: Modifier = Modifier,
) {
    val types = remember { WalletType.entries.toList() }
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.fieldLabelGap)) {
        Text(
            stringResource(R.string.provider_form_type),
            style = MonAITheme.typography.labelMedium,
            color = MonAITheme.colors.textSecondary,
        )
        MonAISegmentedControl(
            segments = types.map { MonAISegment(it.label()) },
            selectedIndex = types.indexOf(type),
            onSelect = { if (enabled) onPick(types[it]) },
        )
    }
}

@Composable
internal fun ProviderFormSortOrder(
    sortOrder: String,
    enabled: Boolean,
    onChange: (String) -> Unit,
    modifier: Modifier = Modifier,
) {
    MonAITextField(
        value = sortOrder,
        onValueChange = onChange,
        modifier = modifier,
        label = stringResource(R.string.provider_form_sort_order),
        supportingText = stringResource(R.string.provider_form_sort_order_note),
        enabled = enabled,
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number, imeAction = ImeAction.Done),
    )
}

/**
 * The status switch. A system provider is always active, so its switch is off-limits; on an
 * existing provider the note says existing wallets keep working.
 */
@Composable
internal fun ProviderFormActive(
    isActive: Boolean,
    isEditing: Boolean,
    isSystem: Boolean,
    enabled: Boolean,
    onChange: (Boolean) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val canToggle = enabled && !isSystem
    MonAICard(modifier.fillMaxWidth()) {
        Row(
            Modifier.toggleable(
                value = isActive,
                enabled = canToggle,
                role = Role.Switch,
                onValueChange = onChange,
            ),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        ) {
            Column(Modifier.weight(1f)) {
                Text(
                    stringResource(R.string.provider_form_active),
                    style = MonAITheme.typography.titleSmall,
                    color = colors.textPrimary,
                )
                Text(
                    stringResource(
                        when {
                            isSystem -> R.string.provider_form_system_note
                            isEditing -> R.string.provider_form_active_note_edit
                            else -> R.string.provider_form_active_note_new
                        },
                    ),
                    Modifier.padding(top = MonAITheme.spacing.x0_5),
                    style = MonAITheme.typography.bodySmall,
                    color = colors.textTertiary,
                )
            }
            Switch(
                checked = isActive,
                onCheckedChange = null,
                enabled = canToggle,
                colors = SwitchDefaults.colors(
                    checkedTrackColor = colors.primary,
                    checkedThumbColor = colors.onPrimary,
                ),
            )
        }
    }
}
