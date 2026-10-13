package com.djtech.monai.core.common.locale

import com.djtech.monai.core.model.AppLanguage

/** Remembers the language set, as AppCompat would; [setCount] counts activity recreations. */
class FakeAppLocaleManager(initial: AppLanguage = AppLanguage.SYSTEM) : AppLocaleManager {
    var current = initial
        private set
    var setCount = 0
        private set

    override fun currentLanguage(): AppLanguage = current

    override fun setLanguage(language: AppLanguage) {
        setCount++
        current = language
    }
}
