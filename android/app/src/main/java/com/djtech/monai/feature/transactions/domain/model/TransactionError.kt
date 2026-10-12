package com.djtech.monai.feature.transactions.domain.model

/** Why a transaction action failed, in terms the transaction screens can show. */
sealed interface TransactionError {
    data object Network : TransactionError

    data object Unexpected : TransactionError
}
