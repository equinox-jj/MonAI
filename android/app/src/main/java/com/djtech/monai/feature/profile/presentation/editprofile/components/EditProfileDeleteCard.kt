package com.djtech.monai.feature.profile.presentation.editprofile.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAIPasswordField
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** What deleting the account removes, the password to confirm it, and the red button. */
@Composable
internal fun EditProfileDeleteCard(
    password: String,
    passwordError: String?,
    isDeleting: Boolean,
    onPasswordChange: (String) -> Unit,
    onDelete: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.lg)
    Column(
        modifier
            .fillMaxWidth()
            .clip(shape)
            .background(colors.errorContainer)
            .border(MonAITheme.sizes.border, colors.errorContainerBorder, shape)
            .padding(MonAITheme.spacing.cardPadding),
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            Icon(MonAIIcons.PersonRemove, null, tint = colors.errorText)
            Text(
                stringResource(R.string.profile_delete_title),
                style = MonAITheme.typography.titleMedium,
                color = colors.errorText,
            )
        }
        Text(
            stringResource(R.string.profile_delete_body),
            style = MonAITheme.extendedTypography.bodyCompact,
            color = colors.onErrorContainer,
        )
        MonAIPasswordField(
            value = password,
            onValueChange = onPasswordChange,
            placeholder = stringResource(R.string.profile_delete_password),
            supportingText = passwordError,
            tone = if (passwordError != null) MonAIFieldTone.Error else MonAIFieldTone.Neutral,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password, imeAction = ImeAction.Done),
            keyboardActions = KeyboardActions(onDone = { onDelete() }),
            enabled = !isDeleting,
        )
        MonAIButton(
            stringResource(R.string.profile_delete_button),
            onClick = onDelete,
            modifier = Modifier.fillMaxWidth(),
            variant = MonAIButtonVariant.Destructive,
            enabled = password.isNotEmpty(),
            loading = isDeleting,
        )
    }
}
