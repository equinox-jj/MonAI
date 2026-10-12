package com.djtech.monai.feature.wallets.domain.model

/** Why a wallet action failed, in terms the wallet screens can show. */
sealed interface WalletError {
    data object Network : WalletError

    data object Unexpected : WalletError
}
