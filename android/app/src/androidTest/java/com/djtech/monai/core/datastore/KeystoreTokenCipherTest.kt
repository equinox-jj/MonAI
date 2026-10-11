package com.djtech.monai.core.datastore

import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class KeystoreTokenCipherTest {

    private val cipher = KeystoreTokenCipher(keyAlias = "monai_token_key_test")

    @Test
    fun roundTripsATokenWithoutStoringItInPlainText() {
        val encrypted = cipher.encrypt("eyJhbGciOi.token")

        assertFalse(encrypted.contains("eyJhbGciOi"))
        assertEquals("eyJhbGciOi.token", cipher.decrypt(encrypted))
    }

    @Test
    fun usesAFreshIvForEveryEncryption() {
        assertNotEquals(cipher.encrypt("same"), cipher.encrypt("same"))
    }

    @Test
    fun rejectsTamperedCiphertext() {
        val encrypted = cipher.encrypt("token")
        val tampered = encrypted.dropLast(2) + if (encrypted.endsWith("AA")) "BA" else "AA"

        assertNull(cipher.decrypt(tampered))
    }

    @Test
    fun rejectsInputThatIsNotCiphertext() {
        assertNull(cipher.decrypt("not base64 !!"))
        assertNull(cipher.decrypt(""))
    }
}
