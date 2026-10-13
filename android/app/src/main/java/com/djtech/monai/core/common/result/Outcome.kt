package com.djtech.monai.core.common.result

import kotlin.coroutines.cancellation.CancellationException

/**
 * The result of an operation that fails with a typed [E] instead of throwing. Each layer picks
 * its own error type through a typealias: `ApiResult<T>` in the network layer, `AuthResult<T>` in auth.
 */
sealed interface Outcome<out T, out E> {
    data class Success<out T>(val data: T) : Outcome<T, Nothing>
    data class Failure<out E>(val error: E) : Outcome<Nothing, E>
}

inline fun <T, E, R> Outcome<T, E>.map(transform: (T) -> R): Outcome<R, E> = when (this) {
    is Outcome.Success -> Outcome.Success(transform(data))
    is Outcome.Failure -> this
}

inline fun <T, E, F> Outcome<T, E>.mapError(transform: (E) -> F): Outcome<T, F> = when (this) {
    is Outcome.Success -> this
    is Outcome.Failure -> Outcome.Failure(transform(error))
}

/** Runs the next step only after a success, e.g. caching what the API returned. */
inline fun <T, E, R> Outcome<T, E>.flatMap(transform: (T) -> Outcome<R, E>): Outcome<R, E> = when (this) {
    is Outcome.Success -> transform(data)
    is Outcome.Failure -> this
}

/** The data of a success, or [onFailure]'s fallback for the error. */
inline fun <T, E> Outcome<T, E>.getOrElse(onFailure: (E) -> T): T = when (this) {
    is Outcome.Success -> data
    is Outcome.Failure -> onFailure(error)
}

/**
 * [runCatching] for coroutines: an [Exception] becomes a [Outcome.Failure], but cancellation is
 * rethrown so it still stops the caller. Inline, so [block] may call suspend functions.
 */
inline fun <T> catching(block: () -> T): Outcome<T, Exception> = try {
    Outcome.Success(block())
} catch (e: CancellationException) {
    throw e
} catch (e: Exception) {
    Outcome.Failure(e)
}
