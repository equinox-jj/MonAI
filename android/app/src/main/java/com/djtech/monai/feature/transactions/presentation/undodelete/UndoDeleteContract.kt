package com.djtech.monai.feature.transactions.presentation.undodelete

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups

/** @param deleted the transaction that can still be restored; null hides the message. */
@Immutable
data class UndoDeleteState(
    val deleted: Transaction? = null,
    val lookups: TransactionLookups = TransactionLookups(),
    val isRestoring: Boolean = false,
)

sealed interface UndoDeleteIntent {
    data object Undo : UndoDeleteIntent

    data object Dismiss : UndoDeleteIntent
}

sealed interface UndoDeleteEffect {
    data class ShowMessage(val message: UiText) : UndoDeleteEffect
}
