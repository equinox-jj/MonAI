package com.djtech.monai.feature.transactions.domain.event

import com.djtech.monai.core.model.Transaction
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Transactions deleted from any screen, for the undo bar in the shell and the list's detail pane.
 * A singleton because those ViewModels and the screens that delete don't share a scope. Nothing
 * is replayed.
 */
@Singleton
class TransactionDeletionEvents @Inject constructor() {
    private val deleted = MutableSharedFlow<Transaction>(extraBufferCapacity = 8)
    val deletions: Flow<Transaction> = deleted.asSharedFlow()

    suspend fun emit(transaction: Transaction) = deleted.emit(transaction)
}
