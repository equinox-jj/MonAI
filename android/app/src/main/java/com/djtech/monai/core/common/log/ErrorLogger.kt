package com.djtech.monai.core.common.log

/**
 * Leaves a trace of a failure the app recovers from (a cache that won't clear, a payload that won't
 * parse), so it isn't silently lost. Not for expected outcomes such as offline or a 4xx.
 */
interface ErrorLogger {
    fun log(message: String, error: Throwable)
}
