package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatThousands
import com.djtech.monai.core.common.format.parseAmount

/**
 * A sheet for typing a rupiah amount with the number keyboard, for screens without a keypad.
 * [amount] shows with dot grouping as it is typed; 0 shows empty and can't be confirmed.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MonAIAmountEntrySheet(
    title: String,
    amount: Long,
    onAmountChange: (Long) -> Unit,
    onConfirm: () -> Unit,
    onDismiss: () -> Unit,
) {
    val focusRequester = remember { FocusRequester() }
    LaunchedEffect(Unit) { focusRequester.requestFocus() }
    MonAIBottomSheet(onDismissRequest = onDismiss, title = title) {
        MonAITextField(
            value = if (amount == 0L) "" else formatThousands(amount),
            onValueChange = { onAmountChange(parseAmount(it) ?: 0) },
            modifier = Modifier.focusRequester(focusRequester),
            placeholder = "0",
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number, imeAction = ImeAction.Done),
            keyboardActions = KeyboardActions(onDone = { if (amount > 0) onConfirm() }),
            label = "Rp",
        )
        MonAISheetButtons(
            secondaryLabel = stringResource(R.string.transaction_picker_cancel),
            onSecondary = onDismiss,
            primaryLabel = stringResource(R.string.transaction_picker_done),
            onPrimary = { if (amount > 0) onConfirm() },
        )
    }
}
