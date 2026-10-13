package com.djtech.monai.feature.receipt.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias ReceiptResult<T> = Outcome<T, ReceiptError>
