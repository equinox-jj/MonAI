package com.djtech.monai.feature.budgets.presentation.budget.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.monthName
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.budgets.presentation.budget.BudgetState

/** Save, and Remove when the month already has a budget. */
@Composable
internal fun BudgetActions(
    state: BudgetState,
    onSave: () -> Unit,
    onRemove: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        MonAIButton(
            stringResource(R.string.budget_save),
            onClick = onSave,
            modifier = Modifier.fillMaxWidth(),
            enabled = state.canSave,
            loading = state.isSaving,
        )
        if (state.hasBudget) {
            val colors = MonAITheme.colors
            Box(
                Modifier
                    .fillMaxWidth()
                    .height(MonAITheme.sizes.buttonMedium)
                    .clip(CircleShape)
                    .clickable(enabled = !state.isWorking, role = Role.Button, onClick = onRemove),
                contentAlignment = Alignment.Center,
            ) {
                Text(
                    stringResource(R.string.budget_remove, state.month.monthName()),
                    style = MonAITheme.typography.labelLarge,
                    color = if (state.isWorking) colors.textDisabled else colors.errorText,
                )
            }
        }
    }
}
