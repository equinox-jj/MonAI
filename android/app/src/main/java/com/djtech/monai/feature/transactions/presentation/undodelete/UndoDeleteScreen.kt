package com.djtech.monai.feature.transactions.presentation.undodelete

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.rememberMonAIMessenger
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.presentation.common.preview.TransactionPreviewData
import com.djtech.monai.feature.transactions.presentation.common.title
import com.djtech.monai.feature.transactions.presentation.undodelete.components.UndoDeleteSnackbar

/**
 * The undo bar for deleted transactions, laid over the signed-in app just above its navigation so
 * a delete from any screen can be undone. Place it at the bottom of the content area.
 */
@Composable
fun UndoDeleteRoute(modifier: Modifier = Modifier, viewModel: UndoDeleteViewModel = hiltViewModel()) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val messenger = rememberMonAIMessenger()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is UndoDeleteEffect.ShowMessage -> messenger.show(effect.message)
        }
    }
    Column(modifier) {
        UndoDeleteScreen(state, viewModel::onIntent)
        MonAISnackbarHost(messenger.hostState)
    }
}

@Composable
fun UndoDeleteScreen(
    state: UndoDeleteState,
    onIntent: (UndoDeleteIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    // Keeps the last transaction while the bar animates out.
    val shown = rememberLast(state.deleted)
    AnimatedVisibility(
        visible = state.deleted != null,
        modifier = modifier,
        enter = slideInVertically { it } + fadeIn(),
        exit = slideOutVertically { it } + fadeOut(),
    ) {
        if (shown != null) {
            UndoDeleteSnackbar(
                key = shown.id,
                title = shown.title(state.lookups),
                windowMillis = UNDO_WINDOW_MS,
                enabled = !state.isRestoring,
                onUndo = { onIntent(UndoDeleteIntent.Undo) },
                modifier = Modifier.padding(
                    horizontal = MonAITheme.spacing.screenHorizontal,
                    vertical = MonAITheme.spacing.x3,
                ),
            )
        }
    }
}

@Composable
private fun rememberLast(transaction: Transaction?): Transaction? {
    val holder = remember { arrayOfNulls<Transaction>(1) }
    if (transaction != null) holder[0] = transaction
    return holder[0]
}

@PreviewLightDark
@Composable
private fun UndoDeletePreview() {
    MonAITheme {
        Box {
            UndoDeleteScreen(
                UndoDeleteState(
                    deleted = TransactionPreviewData.transactions.first { it.id == "t4" },
                    lookups = TransactionPreviewData.lookups,
                ),
                onIntent = {},
            )
        }
    }
}
