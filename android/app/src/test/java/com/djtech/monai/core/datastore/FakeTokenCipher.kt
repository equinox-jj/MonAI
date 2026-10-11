package com.djtech.monai.core.datastore

/** Reversible stand-in for the Keystore cipher; rejects anything it did not encrypt. */
object FakeTokenCipher : TokenCipher {
    private const val PREFIX = "enc:"

    override fun encrypt(plaintext: String): String = PREFIX + plaintext.reversed()

    override fun decrypt(ciphertext: String): String? =
        ciphertext.takeIf { it.startsWith(PREFIX) }?.removePrefix(PREFIX)?.reversed()
}
