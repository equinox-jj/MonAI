package com.djtech.monai.feature.settings.domain.validation

import com.djtech.monai.feature.settings.domain.model.AliasIssue
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.model.ProviderNameIssue

/** The API's limits on providers. */
const val MAX_PROVIDER_NAME_LENGTH = 50
const val MAX_ALIAS_LENGTH = 50
const val MAX_ALIASES = 20

/** Trimmed name; aliases as the API stores them: trimmed, lowercase, sorted, without repeats. */
fun ProviderInput.normalized(): ProviderInput = copy(
    name = name.trim(),
    aliases = aliases.map(::normalizedAlias).filter(String::isNotEmpty).distinct().sorted(),
)

/** One alias as the API stores it: trimmed and lowercase. */
fun normalizedAlias(alias: String): String = alias.trim().lowercase()

/** The API's name rules, checked on the device; null when the name is fine. */
fun ProviderInput.nameIssue(): ProviderNameIssue? = when {
    name.isBlank() -> ProviderNameIssue.REQUIRED
    name.length > MAX_PROVIDER_NAME_LENGTH -> ProviderNameIssue.TOO_LONG
    else -> null
}

/** The API's alias rules on normalized aliases; null when they are fine. */
fun ProviderInput.aliasIssue(): AliasIssue? = when {
    aliases.size > MAX_ALIASES -> AliasIssue.TOO_MANY
    aliases.any { it.length > MAX_ALIAS_LENGTH } -> AliasIssue.TOO_LONG
    else -> null
}

/**
 * The slug the server makes from [name] when none is sent: lowercase letters and digits joined by
 * single hyphens (`Bank BCA` → `bank-bca`). Shown as the provider's ID before it is created.
 */
fun slugOf(name: String): String = name.lowercase()
    .replace(NON_SLUG, "-")
    .trim('-')
    .take(MAX_PROVIDER_NAME_LENGTH)
    .trimEnd('-')

private val NON_SLUG = Regex("[^a-z0-9]+")
