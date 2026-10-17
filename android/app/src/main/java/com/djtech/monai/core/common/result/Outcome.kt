package com.djtech.monai.core.common.result

import kotlin.coroutines.cancellation.CancellationException

/**
 * The result of an operation that can fail with a typed error [E] instead of throwing. It is the one
 * result type for every layer: the network layer returns it, repositories translate its error into
 * their feature's error, and ViewModels branch on it to decide what to show.
 *
 * Each layer names it with a typealias rather than declaring its own sealed result:
 * `ApiResult<T>` (`Outcome<T, ApiError>`) in the network layer, `AuthResult<T>` in auth,
 * `WalletResult<T>` in wallets, and so on.
 *
 * Both type parameters are covariant, and each case fixes the side it doesn't carry to [Nothing]:
 * a [Success] fits any error type and a [Failure] fits any data type. That is what lets the
 * operators below return `this` unchanged for the case they don't transform.
 *
 * Build values with `Outcome.Success(...)` / `Outcome.Failure(...)`: nested classes can't be reached
 * through a typealias, so `ApiResult.Success(...)` doesn't compile. Read them with an exhaustive
 * `when` (no `else`):
 *
 * ```kotlin
 * when (val result = refreshWallets()) {
 *     is Outcome.Success -> showWallets(result.data)
 *     is Outcome.Failure -> showError(result.error.message())
 * }
 * ```
 *
 * @param T the data of a success.
 * @param E the error of a failure; usually a feature's sealed error such as `WalletError`.
 */
sealed interface Outcome<out T, out E> {
    /** The operation finished and produced [data]. */
    data class Success<out T>(val data: T) : Outcome<T, Nothing>

    /** The operation failed with [error], an expected outcome the caller is meant to handle. */
    data class Failure<out E>(val error: E) : Outcome<Nothing, E>
}

/**
 * Transforms the data of a success with [transform]; a failure passes through untouched and
 * [transform] isn't called. Use it for a step that can't fail, such as mapping a DTO to a model.
 * For a step that can fail, use [flatMap].
 *
 * ```kotlin
 * apiCaller.call { walletApiService.getWallet(id) }.map(WalletDto::asModel)
 * ```
 *
 * @return a [Outcome.Success] holding the transformed data, or the same [Outcome.Failure].
 */
inline fun <T, E, R> Outcome<T, E>.map(transform: (T) -> R): Outcome<R, E> = when (this) {
    is Outcome.Success -> Outcome.Success(transform(data))
    is Outcome.Failure -> this
}

/**
 * Transforms the error of a failure with [transform]; a success passes through untouched and
 * [transform] isn't called. Repositories use it to turn the network layer's `ApiError` into their
 * own feature error, so nothing above the data layer sees `ApiError`:
 *
 * ```kotlin
 * apiCaller.callRaw { … }.mapError(ApiError::toWalletError)
 * ```
 *
 * @return the same [Outcome.Success], or a [Outcome.Failure] holding the transformed error.
 */
inline fun <T, E, F> Outcome<T, E>.mapError(transform: (E) -> F): Outcome<T, F> = when (this) {
    is Outcome.Success -> this
    is Outcome.Failure -> Outcome.Failure(transform(error))
}

/**
 * Runs the next step, which can fail too, only after a success, and returns that step's outcome.
 * A failure short-circuits: [transform] isn't called and the failure is returned as is. This chains
 * an API call and its cache write without branching on the first result by hand:
 *
 * ```kotlin
 * apiCaller.call { walletApiService.getWallet(id) }
 *     .map(WalletDto::asModel)
 *     .mapError(ApiError::toWalletError)
 *     .flatMap { wallet ->
 *         errorLogger.runLogged("Caching a wallet failed", WalletError.Unexpected) {
 *             walletDao.upsertAll(listOf(wallet.asEntity()))
 *         }
 *     }
 * ```
 *
 * Both steps must share the error type [E], so call [mapError] first when the first step's error
 * differs from the next step's.
 *
 * @return the outcome of [transform] for a success, or the same [Outcome.Failure].
 */
inline fun <T, E, R> Outcome<T, E>.flatMap(transform: (T) -> Outcome<R, E>): Outcome<R, E> = when (this) {
    is Outcome.Success -> transform(data)
    is Outcome.Failure -> this
}

/**
 * Leaves the [Outcome] world: returns the data of a success, or whatever [onFailure] returns for the
 * error of a failure. [onFailure] is only called for a failure.
 *
 * Because the function is inline, [onFailure] can also `return` from the enclosing function, which
 * gives an early exit without a nested `when`:
 *
 * ```kotlin
 * val wallets = refreshWallets().getOrElse { error ->
 *     effectQueue.send(Effect.ShowError(error.message()))
 *     return
 * }
 * ```
 *
 * @return the success's data, or the fallback from [onFailure].
 */
inline fun <T, E> Outcome<T, E>.getOrElse(onFailure: (E) -> T): T = when (this) {
    is Outcome.Success -> data
    is Outcome.Failure -> onFailure(error)
}

/**
 * Runs [block] and turns a thrown [Exception] into a [Outcome.Failure]: a [runCatching] that is
 * safe to use in coroutines. It differs from [runCatching] in three ways:
 *
 * - [CancellationException] is rethrown, not caught, so a cancelled coroutine still stops instead
 *   of carrying on with a failure value (swallowing it breaks structured concurrency).
 * - Only [Exception]s are caught. An [Error] (`OutOfMemoryError`, `StackOverflowError`) still
 *   crashes, since there is nothing sensible to recover from.
 * - It returns an [Outcome] with the exception as the error, so the result chains with
 *   [mapError] / [flatMap] like everything else.
 *
 * It is inline, so [block] may call suspend functions when `catching` itself is called from a
 * suspend function. It is the building block for `ApiCaller.callRaw` (which maps the exception to
 * an `ApiError`) and `ErrorLogger.runLogged` (which logs it and returns a fixed error); prefer
 * those two in repositories, and don't write `try`/`catch` by hand.
 *
 * @return a [Outcome.Success] with [block]'s value, or a [Outcome.Failure] with the exception it threw.
 * @throws CancellationException when [block] is cancelled.
 */
inline fun <T> catching(block: () -> T): Outcome<T, Exception> = try {
    Outcome.Success(block())
} catch (e: CancellationException) {
    throw e
} catch (e: Exception) {
    Outcome.Failure(e)
}
