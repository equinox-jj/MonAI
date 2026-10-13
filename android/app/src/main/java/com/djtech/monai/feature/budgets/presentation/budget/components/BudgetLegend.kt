package com.djtech.monai.feature.budgets.presentation.budget.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.color
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.BudgetStatus

/** What each bar color means. */
@Composable
internal fun BudgetLegend(modifier: Modifier = Modifier) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        LegendRow(BudgetStatus.OK.color(), stringResource(R.string.budget_legend_ok))
        LegendRow(BudgetStatus.WARNING.color(), stringResource(R.string.budget_legend_warning))
        LegendRow(BudgetStatus.EXCEEDED.color(), stringResource(R.string.budget_legend_exceeded))
    }
}

@Composable
private fun LegendRow(color: Color, label: String) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        Box(
            Modifier
                .size(width = 24.dp, height = 6.dp)
                .background(color, RoundedCornerShape(3.dp)),
        )
        Text(label, style = MonAITheme.typography.bodySmall, color = MonAITheme.colors.textSecondary)
    }
}
