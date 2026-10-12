package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAIPillField
import com.djtech.monai.core.designsystem.component.MonAIScreenTitle
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheetKind
import com.djtech.monai.feature.transactions.presentation.common.monthText
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsDestination
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsIntent
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsState

/** Title, the search pill and the month switcher. */
@Composable
internal fun TransactionsHeader(
    state: TransactionsState,
    onIntent: (TransactionsIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
        MonAIScreenTitle(stringResource(R.string.transactions_title))
        MonAIPillField(
            text = stringResource(R.string.transactions_search_hint),
            leadingIcon = MonAIIcons.Search,
            onClick = { onIntent(TransactionsIntent.Open(TransactionsDestination.Search(state.month))) },
            modifier = Modifier.fillMaxWidth(),
        )
        MonthSwitcher(state, onIntent)
    }
}

@Composable
private fun MonthSwitcher(state: TransactionsState, onIntent: (TransactionsIntent) -> Unit) {
    val colors = MonAITheme.colors
    val label = monthText(state.month)
    val pickerDescription = stringResource(R.string.transactions_choose_month, label)
    Row(Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        MonAIIconButton(
            MonAIIcons.ChevronLeft,
            stringResource(R.string.transactions_previous_month),
            onClick = { onIntent(TransactionsIntent.PreviousMonth) },
            tint = colors.textSecondary,
        )
        Row(Modifier.weight(1f), horizontalArrangement = Arrangement.Center) {
            Row(
                Modifier
                    .clip(CircleShape)
                    .clickable(role = Role.Button) {
                        onIntent(TransactionsIntent.Filter(FilterIntent.Open(FilterSheetKind.MONTH)))
                    }
                    .semantics { contentDescription = pickerDescription }
                    .padding(horizontal = MonAITheme.spacing.x2, vertical = MonAITheme.spacing.x2_5),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
            ) {
                Text(label, style = MonAITheme.typography.titleMedium, color = colors.textPrimary)
                Icon(
                    MonAIIcons.ExpandMore,
                    null,
                    Modifier.size(MonAITheme.sizes.iconMd),
                    tint = colors.textPrimary,
                )
            }
        }
        MonAIIconButton(
            MonAIIcons.ChevronRight,
            stringResource(R.string.transactions_next_month),
            onClick = { onIntent(TransactionsIntent.NextMonth) },
            tint = colors.textSecondary,
            enabled = state.canShowNextMonth,
        )
    }
}
