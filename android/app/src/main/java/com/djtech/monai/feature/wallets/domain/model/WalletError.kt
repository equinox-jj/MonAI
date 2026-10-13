package com.djtech.monai.feature.wallets.domain.model

/** Why a wallet action failed, in terms the wallet screens can show. */
sealed interface WalletError {
    /** The device or the server rejected one or more form fields, including a name already in use. */
    data class InvalidFields(val errors: List<WalletFieldError>) : WalletError

    /** Delete refused because the wallet has transactions; archive it instead. */
    data object HasTransactions : WalletError

    /** The default wallet can't be archived or deleted until another wallet is the default. */
    data object DefaultRequired : WalletError

    /** The wallet was deleted, or never belonged to this user. */
    data object NotFound : WalletError

    data object Network : WalletError

    data object Unexpected : WalletError
}

data class WalletFieldError(
    val field: WalletField,
    val issue: WalletFieldIssue,
)

enum class WalletField { NAME, TYPE, INITIAL_BALANCE, COLOR }

/** What is wrong with a field, decoded from the API's field error code or found by local validation. */
enum class WalletFieldIssue {
    /** Missing or blank. */
    REQUIRED,

    /** The name is over 30 characters. */
    TOO_LONG,

    /** The starting balance is over the largest amount. */
    TOO_LARGE,

    /** Another wallet already has this name (case-insensitive). */
    ALREADY_EXISTS,

    /** A malformed value, or a code this app does not know yet; show a generic message. */
    INVALID,
}
