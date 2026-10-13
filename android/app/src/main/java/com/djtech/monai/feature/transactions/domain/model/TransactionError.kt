package com.djtech.monai.feature.transactions.domain.model

import kotlin.time.Duration

/** Why a transaction action failed, in terms the transaction screens can show. */
sealed interface TransactionError {
    /** The device or the server rejected one or more form fields. */
    data class InvalidFields(val errors: List<TransactionFieldError>) : TransactionError

    /** Restoring failed because one of its wallets was archived after the delete. */
    data object WalletArchived : TransactionError

    /** The transaction was deleted, or never belonged to this user. */
    data object NotFound : TransactionError

    /** The receipt photo is over the upload limit, even after shrinking. */
    data object PhotoTooLarge : TransactionError

    /** The receipt photo can't be read or isn't an accepted type. */
    data object PhotoUnsupported : TransactionError

    /** Too many receipt uploads; [retryAfter] is when to try again, if the server said. */
    data class RateLimited(val retryAfter: Duration?) : TransactionError

    data object Network : TransactionError

    data object Unexpected : TransactionError
}

data class TransactionFieldError(
    val field: TransactionField,
    val issue: TransactionFieldIssue,
)

enum class TransactionField { AMOUNT, WALLET, TO_WALLET, CATEGORY, DATE, NOTE }

/** What is wrong with a field, decoded from the API's field error code or found by local validation. */
enum class TransactionFieldIssue {
    /** Missing, or an amount of 0. */
    REQUIRED,

    /** Over the largest amount, or the note is too long. */
    TOO_LARGE,

    /** The date is after today. */
    FUTURE_DATE,

    /** A transfer's destination is its source wallet. */
    SAME_WALLET,

    /** The category is of the other type (an income category on an expense). */
    TYPE_MISMATCH,

    /** The wallet is archived. */
    ARCHIVED,

    /** The wallet or category no longer exists. */
    NOT_FOUND,

    /** A code this app does not know yet; show a generic message. */
    INVALID,
}
