package com.djtech.monai.feature.settings.domain.model

/** Why a provider action failed, in terms the admin screens can show. */
sealed interface AdminProviderError {
    data object Network : AdminProviderError

    data class InvalidName(val issue: ProviderNameIssue) : AdminProviderError

    data class InvalidAliases(val issue: AliasIssue) : AdminProviderError

    /** Another provider already uses the name's slug, or one of the aliases. */
    data object Conflict : AdminProviderError

    /** System providers can't be deactivated or deleted. */
    data object Locked : AdminProviderError

    /** The user's role no longer allows this. */
    data object Forbidden : AdminProviderError

    data object NotFound : AdminProviderError

    data object LogoTooLarge : AdminProviderError

    /** The logo couldn't be read, or the server refused its type. */
    data object LogoUnsupported : AdminProviderError

    data object Unexpected : AdminProviderError
}

enum class ProviderNameIssue { REQUIRED, TOO_LONG }

enum class AliasIssue { TOO_MANY, TOO_LONG, INVALID }
