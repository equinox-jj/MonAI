package com.djtech.monai.feature.auth.domain.validation

// The one place auth input is cleaned up. Use cases apply it once, then validate and send the same
// values. The backend does the same, so an email matches however it was typed. Passwords stay as
// typed: spaces may be part of them.

internal fun String.normalizedName(): String = trim()

internal fun String.normalizedEmail(): String = trim().lowercase()
