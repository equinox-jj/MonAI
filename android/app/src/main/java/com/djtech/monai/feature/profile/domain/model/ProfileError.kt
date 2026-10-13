package com.djtech.monai.feature.profile.domain.model

import kotlin.time.Duration

/** Why a profile action failed, in terms the profile screens can show. */
sealed interface ProfileError {
    data object Network : ProfileError

    data class InvalidName(val issue: NameIssue) : ProfileError

    /** Not an IANA zone the server knows. */
    data object InvalidTimezone : ProfileError

    /** Deleting the account needs the password, and none was typed. */
    data object PasswordRequired : ProfileError

    data object WrongPassword : ProfileError

    /** The only user holding every admin permission can't delete the account. */
    data object LastAdmin : ProfileError

    /** Too many attempts; [retryAfter] is how long the server asks to wait, when it says. */
    data class RateLimited(val retryAfter: Duration?) : ProfileError

    /** Still over the size limit after it was shrunk. */
    data object PhotoTooLarge : ProfileError

    /** The photo couldn't be read, or the server refused its type. */
    data object PhotoUnsupported : ProfileError

    data object Unexpected : ProfileError
}

enum class NameIssue { REQUIRED, TOO_LONG, INVALID }
