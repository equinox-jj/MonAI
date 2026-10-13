package com.djtech.monai.feature.profile.presentation.editprofile.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.autofill.ContentType
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAISelectField
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.profile.presentation.editprofile.model.TimezoneOption

/** Display name, the email (read-only: it identifies the account) and the timezone. */
@Composable
internal fun EditProfileFields(
    name: String,
    nameError: String?,
    email: String,
    timezone: TimezoneOption?,
    enabled: Boolean,
    onNameChange: (String) -> Unit,
    onPickTimezone: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4)) {
        MonAITextField(
            value = name,
            onValueChange = onNameChange,
            label = stringResource(R.string.profile_name),
            supportingText = nameError,
            tone = if (nameError != null) MonAIFieldTone.Error else MonAIFieldTone.Neutral,
            enabled = enabled,
            keyboardOptions = KeyboardOptions(
                capitalization = KeyboardCapitalization.Words,
                imeAction = ImeAction.Done,
            ),
            contentType = ContentType.PersonFullName,
        )
        MonAITextField(
            value = email,
            onValueChange = {},
            label = stringResource(R.string.profile_email),
            leadingIcon = MonAIIcons.Mail,
            enabled = false,
        )
        Column(verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.fieldLabelGap)) {
            MonAISelectField(
                value = timezone?.let { "${it.label} · ${it.offset}" }.orEmpty(),
                onClick = onPickTimezone,
                leadingIcon = MonAIIcons.Public,
                label = stringResource(R.string.profile_timezone),
                showChevron = true,
                enabled = enabled,
            )
            Text(
                stringResource(R.string.profile_timezone_note),
                style = MonAITheme.typography.bodySmall,
                color = MonAITheme.colors.textTertiary,
            )
        }
    }
}
