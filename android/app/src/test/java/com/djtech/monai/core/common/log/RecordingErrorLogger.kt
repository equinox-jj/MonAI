package com.djtech.monai.core.common.log

/** Keeps every logged error so a test can check a recovered failure still left a trace. */
class RecordingErrorLogger : ErrorLogger {
    val errors = mutableListOf<Throwable>()

    override fun log(message: String, error: Throwable) {
        errors += error
    }
}
