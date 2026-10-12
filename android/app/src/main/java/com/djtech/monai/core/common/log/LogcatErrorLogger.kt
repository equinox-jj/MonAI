package com.djtech.monai.core.common.log

import android.util.Log
import com.djtech.monai.BuildConfig
import javax.inject.Inject

/** Writes to logcat in debug builds only: release builds stay quiet until a crash reporter is added. */
class LogcatErrorLogger @Inject constructor() : ErrorLogger {
    override fun log(message: String, error: Throwable) {
        if (BuildConfig.DEBUG) Log.w(TAG, message, error)
    }

    private companion object {
        const val TAG = "MonAI"
    }
}
