package com.djtech.monai.core.common.log

import android.util.Log
import com.djtech.monai.BuildConfig
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.catching
import com.djtech.monai.core.common.result.mapError
import javax.inject.Inject

/**
 * Leaves a trace of a failure the app recovers from (a cache that won't clear, a payload that won't
 * parse), so it isn't silently lost. Not for expected outcomes such as offline or a 4xx.
 */
interface ErrorLogger {
    fun log(message: String, error: Throwable)
}

/**
 * Runs [block] (typically a cache write after the server accepted a change); an exception is logged
 * as [message] and returned as [error] instead of thrown.
 */
inline fun <T, E> ErrorLogger.runLogged(message: String, error: E, block: () -> T): Outcome<T, E> =
    catching(block).mapError { e ->
        log(message, e)
        error
    }

/** Writes to logcat in debug builds only: release builds stay quiet until a crash reporter is added. */
class LogcatErrorLogger @Inject constructor() : ErrorLogger {
    override fun log(message: String, error: Throwable) {
        if (BuildConfig.DEBUG) Log.w(TAG, message, error)
    }

    private companion object {
        const val TAG = "MonAI"
    }
}
