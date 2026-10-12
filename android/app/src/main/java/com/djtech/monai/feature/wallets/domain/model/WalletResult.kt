package com.djtech.monai.feature.wallets.domain.model

import com.djtech.monai.core.common.result.Outcome

typealias WalletResult<T> = Outcome<T, WalletError>
