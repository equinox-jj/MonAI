package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIAlertDialog
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormIntent

/** Asked when closing a form that has unsaved changes. */
@Composable
internal fun TransactionFormDiscardDialog(onIntent: (TransactionFormIntent) -> Unit) {
    MonAIAlertDialog(
        title = stringResource(R.string.transaction_form_discard_title),
        message = stringResource(R.string.transaction_form_discard_body),
        confirmLabel = stringResource(R.string.transaction_form_discard_confirm),
        onConfirm = { onIntent(TransactionFormIntent.ConfirmDiscard) },
        onDismissRequest = { onIntent(TransactionFormIntent.KeepEditing) },
        dismissLabel = stringResource(R.string.transaction_form_discard_keep),
        destructive = true,
    )
}
