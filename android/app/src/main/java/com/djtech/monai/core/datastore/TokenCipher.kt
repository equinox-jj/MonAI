package com.djtech.monai.core.datastore

/** Encrypts the access token before it is written to disk. */
interface TokenCipher {
    fun encrypt(plaintext: String): String

    /** Returns null when [ciphertext] cannot be decrypted (wrong key, tampered, not ours). */
    fun decrypt(ciphertext: String): String?
}
