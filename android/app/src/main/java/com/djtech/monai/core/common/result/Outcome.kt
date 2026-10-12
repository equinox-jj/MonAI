package com.djtech.monai.core.common.result

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
