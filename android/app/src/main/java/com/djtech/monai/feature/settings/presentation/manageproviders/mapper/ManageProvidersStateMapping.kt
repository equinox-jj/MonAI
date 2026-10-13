package com.djtech.monai.feature.settings.presentation.manageproviders.mapper

import com.djtech.monai.R
import com.djtech.monai.core.common.format.walletMonogram
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.AliasIssue
import com.djtech.monai.feature.settings.domain.model.ProviderNameIssue
import com.djtech.monai.feature.settings.domain.validation.MAX_ALIASES
import com.djtech.monai.feature.settings.domain.validation.MAX_ALIAS_LENGTH
import com.djtech.monai.feature.settings.domain.validation.MAX_PROVIDER_NAME_LENGTH
import com.djtech.monai.feature.settings.presentation.manageproviders.model.ProviderRow
import com.djtech.monai.feature.settings.presentation.manageproviders.model.ProviderStatus

fun AdminPaymentProvider.toRow(): ProviderRow = ProviderRow(
    id = id,
    name = name,
    monogram = walletMonogram(name),
    logoUrl = logoUrl,
    type = type,
    aliases = aliases.joinToString(", "),
    status = when {
        isSystem -> ProviderStatus.SYSTEM
        isActive -> ProviderStatus.ACTIVE
        else -> ProviderStatus.INACTIVE
    },
)

/** Matches the name, the slug or any alias, ignoring case. */
fun AdminPaymentProvider.matches(query: String): Boolean {
    val needle = query.trim()
    return needle.isEmpty() ||
        name.contains(needle, ignoreCase = true) ||
        slug.contains(needle, ignoreCase = true) ||
        aliases.any { it.contains(needle, ignoreCase = true) }
}

fun AdminProviderError.message(): UiText = when (this) {
    AdminProviderError.Network -> UiText.Resource(R.string.provider_error_network)
    is AdminProviderError.InvalidName -> when (issue) {
        ProviderNameIssue.REQUIRED -> UiText.Resource(R.string.provider_error_name_required)
        ProviderNameIssue.TOO_LONG -> UiText.Resource(R.string.provider_error_name_too_long, MAX_PROVIDER_NAME_LENGTH)
    }

    is AdminProviderError.InvalidAliases -> when (issue) {
        AliasIssue.TOO_MANY -> UiText.Resource(R.string.provider_error_aliases_too_many, MAX_ALIASES)
        AliasIssue.TOO_LONG -> UiText.Resource(R.string.provider_error_alias_too_long, MAX_ALIAS_LENGTH)
        AliasIssue.INVALID -> UiText.Resource(R.string.provider_error_aliases_invalid)
    }

    AdminProviderError.Conflict -> UiText.Resource(R.string.provider_error_conflict)
    AdminProviderError.Locked -> UiText.Resource(R.string.provider_error_locked)
    AdminProviderError.Forbidden -> UiText.Resource(R.string.provider_error_forbidden)
    AdminProviderError.NotFound -> UiText.Resource(R.string.provider_error_not_found)
    AdminProviderError.LogoTooLarge -> UiText.Resource(R.string.provider_error_logo_too_large)
    AdminProviderError.LogoUnsupported -> UiText.Resource(R.string.provider_error_logo_unsupported)
    AdminProviderError.Unexpected -> UiText.Resource(R.string.provider_error_unexpected)
}
