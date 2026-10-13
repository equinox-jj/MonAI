package com.djtech.monai.feature.budgets.presentation.budget.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.semantics.Role
import com.djtech.monai.core.common.format.formatRupiahCompact
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Quick limits in one row of pills; the one matching [limit] is selected. */
@Composable
internal fun BudgetPresets(
    presets: List<Long>,
    limit: Long,
    onPick: (Long) -> Unit,
    modifier: Modifier = Modifier,
) {
    Row(
        modifier
            .fillMaxWidth()
            .selectableGroup(),
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        presets.forEach { preset ->
            PresetPill(
                // `2,5 jt`: the compact amount without the currency, which the field already shows.
                formatRupiahCompact(preset).removePrefix("Rp "),
                selected = preset == limit,
                onClick = { onPick(preset) },
                modifier = Modifier.weight(1f),
            )
        }
    }
}

@Composable
private fun PresetPill(
    label: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    Box(
        modifier
            .height(sizes.choiceChip)
            .clip(CircleShape)
            .background(if (selected) colors.primaryContainer else colors.surface)
            .border(sizes.border, if (selected) colors.primaryContainerBorder else colors.borderStrong, CircleShape)
            .selectable(selected = selected, role = Role.RadioButton, onClick = onClick),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            label,
            style = MonAITheme.typography.labelLarge,
            color = if (selected) colors.onPrimaryContainer else colors.iconStrong,
        )
    }
}
