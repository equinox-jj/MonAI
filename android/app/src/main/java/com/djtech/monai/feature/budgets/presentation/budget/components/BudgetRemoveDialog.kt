package com.djtech.monai.feature.budgets.presentation.budget.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.monthName
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import java.time.YearMonth

/** Confirms removing [month]'s budget. */
@Composable
internal fun BudgetRemoveDialog(month: YearMonth, onConfirm: () -> Unit, onDismiss: () -> Unit) {
    MonAIAlertDialog(
        title = stringResource(R.string.budget_remove_title, month.monthName()),
        message = stringResource(R.string.budget_remove_message),
        confirmLabel = stringResource(R.string.budget_remove_confirm),
        onConfirm = onConfirm,
        onDismissRequest = onDismiss,
        dismissLabel = stringResource(R.string.budget_cancel),
        icon = MonAIIcons.Delete,
        tone = MonAIAlertTone.Error,
        destructive = true,
    )
}
