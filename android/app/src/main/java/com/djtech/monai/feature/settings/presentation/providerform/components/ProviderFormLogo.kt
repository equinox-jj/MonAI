package com.djtech.monai.feature.settings.presentation.providerform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import coil3.compose.AsyncImage
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.settings.presentation.manageproviders.components.ProviderLogo

/** The logo, or a dashed upload prompt while there is none. A picked logo shows before it uploads. */
@Composable
internal fun ProviderFormLogo(
    monogram: String,
    logoUrl: String?,
    newLogoUri: String?,
    enabled: Boolean,
    onPick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.lg)
    val shown = newLogoUri ?: logoUrl
    Row(
        modifier
            .fillMaxWidth()
            .clip(shape)
            .border(MonAITheme.sizes.border, colors.borderStrong, shape)
            .clickable(enabled = enabled, role = Role.Button, onClick = onPick)
            .padding(MonAITheme.spacing.x3),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        if (shown == null) {
            Box(
                Modifier
                    .size(MonAITheme.sizes.choiceChip + MonAITheme.spacing.x2)
                    .clip(RoundedCornerShape(MonAITheme.radius.md))
                    .background(colors.primaryContainer),
                contentAlignment = Alignment.Center,
            ) {
                Icon(MonAIIcons.AddPhotoAlternate, null, tint = colors.accent)
            }
        } else if (newLogoUri != null) {
            AsyncImage(
                model = newLogoUri,
                contentDescription = null,
                modifier = Modifier
                    .size(MonAITheme.sizes.choiceChip + MonAITheme.spacing.x2)
                    .clip(RoundedCornerShape(MonAITheme.radius.md)),
                contentScale = ContentScale.Fit,
            )
        } else {
            ProviderLogo(monogram, logoUrl)
        }
        Column(Modifier.weight(1f)) {
            Text(
                stringResource(if (shown == null) R.string.provider_form_upload_logo else R.string.provider_form_logo),
                style = MonAITheme.typography.titleSmall,
                color = colors.textPrimary,
            )
            Text(
                stringResource(R.string.provider_form_logo_note),
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
            )
        }
        if (shown != null) {
            MonAIButton(
                stringResource(R.string.provider_form_replace_logo),
                onClick = onPick,
                variant = MonAIButtonVariant.Outlined,
                size = MonAIButtonSize.Small,
                enabled = enabled,
            )
        }
    }
}
