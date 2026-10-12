package com.djtech.monai.feature.transactions.presentation.transactions.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Icon
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.Text
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.CustomAccessibilityAction
import androidx.compose.ui.semantics.customActions
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.presentation.common.RowWhen
import com.djtech.monai.feature.transactions.presentation.common.TransactionRow
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import kotlinx.coroutines.launch
import java.time.ZoneId

/**
 * A list row that swipes left to reveal Delete. The row springs back and leaves the list once
 * the delete lands in the cache; a screen reader gets the same action from the actions menu.
 */
@Composable
internal fun TransactionsSwipeRow(
    transaction: Transaction,
    lookups: TransactionLookups,
    zone: ZoneId,
    selected: Boolean,
    onClick: () -> Unit,
    onDelete: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val currentOnDelete by rememberUpdatedState(onDelete)
    val swipe = rememberSwipeToDismissBoxState()
    val scope = rememberCoroutineScope()
    val deleteLabel = stringResource(R.string.transactions_delete)
    SwipeToDismissBox(
        state = swipe,
        modifier = modifier.semantics {
            customActions = listOf(CustomAccessibilityAction(deleteLabel) { currentOnDelete(); true })
        },
        enableDismissFromStartToEnd = false,
        onDismiss = { value ->
            if (value == SwipeToDismissBoxValue.EndToStart) currentOnDelete()
            scope.launch { swipe.reset() }
        },
        backgroundContent = { DeleteBackground(deleteLabel) },
    ) {
        TransactionRow(
            transaction = transaction,
            lookups = lookups,
            rowWhen = RowWhen.TIME,
            zone = zone,
            onClick = onClick,
            selected = selected,
        )
    }
}

@Composable
private fun DeleteBackground(label: String) {
    val colors = MonAITheme.colors
    Box(
        Modifier
            .fillMaxSize()
            .background(colors.error),
        contentAlignment = Alignment.CenterEnd,
    ) {
        Column(
            Modifier
                .width(96.dp)
                .fillMaxHeight(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center,
        ) {
            Icon(
                MonAIIcons.Delete,
                null,
                Modifier.size(MonAITheme.sizes.iconLg),
                tint = colors.onPrimary,
            )
            Text(label, style = MonAITheme.typography.labelMedium, color = colors.onPrimary)
        }
    }
}
