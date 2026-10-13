package com.djtech.monai.feature.profile.presentation.editprofile.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
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
import com.djtech.monai.core.designsystem.component.MonAISearchField
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.profile.presentation.editprofile.model.TimezoneOption

/** Indonesia's three zones first, then every zone, searchable by city or region. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun EditProfileTimezoneSheet(
    selected: String,
    query: String,
    indonesian: List<TimezoneOption>,
    others: List<TimezoneOption>,
    onQueryChange: (String) -> Unit,
    onPick: (String) -> Unit,
    onDismiss: () -> Unit,
) {
    MonAIBottomSheet(onDismissRequest = onDismiss, title = stringResource(R.string.profile_timezone)) {
        MonAISearchField(
            value = query,
            onValueChange = onQueryChange,
            placeholder = stringResource(R.string.profile_timezone_search),
        )
        LazyColumn(Modifier.heightIn(max = ListMaxHeight)) {
            if (indonesian.isNotEmpty()) {
                item(key = "indonesia") { SectionTitle(stringResource(R.string.profile_timezone_indonesia)) }
                items(indonesian, key = { "id-${it.id}" }) { option ->
                    TimezoneRow(option, option.id == selected, onPick)
                }
            }
            if (others.isNotEmpty()) {
                item(key = "all") { SectionTitle(stringResource(R.string.profile_timezone_all)) }
                items(others, key = { it.id }) { option -> TimezoneRow(option, option.id == selected, onPick) }
            }
            if (indonesian.isEmpty() && others.isEmpty()) {
                item(key = "none") {
                    Text(
                        stringResource(R.string.profile_timezone_none, query),
                        Modifier.padding(vertical = MonAITheme.spacing.x4),
                        style = MonAITheme.typography.bodyMedium,
                        color = MonAITheme.colors.textTertiary,
                    )
                }
            }
        }
    }
}

@Composable
private fun SectionTitle(title: String) {
    Text(
        title.uppercase(),
        Modifier.padding(top = MonAITheme.spacing.x3, bottom = MonAITheme.spacing.x1),
        style = MonAITheme.extendedTypography.overline,
        color = MonAITheme.colors.textTertiary,
    )
}

@Composable
private fun TimezoneRow(option: TimezoneOption, isSelected: Boolean, onPick: (String) -> Unit) {
    val colors = MonAITheme.colors
    Row(
        Modifier
            .fillMaxWidth()
            .heightIn(min = MonAITheme.sizes.settingsRow)
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .clickable(role = Role.RadioButton) { onPick(option.id) }
            .padding(horizontal = MonAITheme.spacing.x2),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Column(Modifier.weight(1f)) {
            Text(option.label, style = MonAITheme.typography.titleSmall, color = colors.textPrimary)
            Text(
                option.indonesianName?.let { stringResource(it) } ?: option.id,
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
            )
        }
        Text(option.offset, style = MonAITheme.extendedTypography.bodyCompact, color = colors.textSecondary)
        Icon(
            if (isSelected) MonAIIcons.RadioButtonChecked else MonAIIcons.RadioButtonUnchecked,
            null,
            tint = if (isSelected) colors.accent else colors.textDisabled,
        )
    }
}

private val ListMaxHeight = 480.dp
