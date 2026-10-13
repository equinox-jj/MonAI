package com.djtech.monai.core.common.locale

import com.djtech.monai.core.model.AppLanguage
import org.junit.Assert.assertEquals
import org.junit.Test

class AppLocaleManagerTest {

    @Test
    fun `reads both codes java uses for indonesian`() {
        assertEquals(AppLanguage.INDONESIAN, languageOf("id"))
        assertEquals(AppLanguage.INDONESIAN, languageOf("in"))
    }

    @Test
    fun `reads english`() {
        assertEquals(AppLanguage.ENGLISH, languageOf("en"))
    }

    @Test
    fun `an untranslated language follows the system`() {
        assertEquals(AppLanguage.SYSTEM, languageOf("fr"))
        assertEquals(AppLanguage.SYSTEM, languageOf(null))
    }
}
