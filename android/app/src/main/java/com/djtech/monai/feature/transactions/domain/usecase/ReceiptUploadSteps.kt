package com.djtech.monai.feature.transactions.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.transactions.domain.model.ReceiptUpload
import com.djtech.monai.feature.transactions.domain.model.TransactionResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

/** Passes the upload's progress through, then runs [next] with the receipt key, or ends with the upload's failure. */
internal fun <T> Flow<ReceiptUpload<String>>.thenWithKey(
    next: suspend (receiptKey: String) -> TransactionResult<T>,
): Flow<ReceiptUpload<T>> = flow {
    collect { step ->
        when (step) {
            is ReceiptUpload.Progress -> emit(step)
            is ReceiptUpload.Done -> emit(
                ReceiptUpload.Done(
                    when (val result = step.result) {
                        is Outcome.Success -> next(result.data)
                        is Outcome.Failure -> result
                    },
                ),
            )
        }
    }
}
