package com.djtech.monai.core.common.ui

/**
 * A background refresh of cached content, and what the screen shows meanwhile: the skeleton until
 * the first refresh answers, the error only when nothing is cached, and the pull-to-refresh spinner
 * only for a refresh the user asked for.
 *
 * @param failure how the last finished refresh failed; null when it succeeded or one is running.
 */
data class RefreshStatus<E>(
    val isRunning: Boolean = false,
    val isUserInitiated: Boolean = false,
    val hasFinished: Boolean = false,
    val failure: E? = null,
) {
    fun started(userInitiated: Boolean = false): RefreshStatus<E> =
        copy(isRunning = true, isUserInitiated = userInitiated, failure = null)

    fun finished(failure: E?): RefreshStatus<E> = RefreshStatus(hasFinished = true, failure = failure)

    fun isLoading(hasCache: Boolean): Boolean = !hasCache && (isRunning || !hasFinished)

    fun loadFailure(hasCache: Boolean): E? = failure.takeIf { !hasCache && !isRunning }

    fun isRefreshing(hasCache: Boolean): Boolean = hasCache && isRunning && isUserInitiated
}
