package com.djtech.monai.feature.transactions.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias TransactionResult<T> = Outcome<T, TransactionError>
