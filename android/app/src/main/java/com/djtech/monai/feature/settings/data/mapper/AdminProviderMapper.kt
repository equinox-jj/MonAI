package com.djtech.monai.feature.settings.data.mapper

import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.settings.data.dto.AdminPaymentProviderDto
import com.djtech.monai.feature.settings.data.dto.CreateProviderRequestDto
import com.djtech.monai.feature.settings.data.dto.UpdateProviderRequestDto
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.AliasIssue
import com.djtech.monai.feature.settings.domain.model.ProviderChanges
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import com.djtech.monai.feature.settings.domain.model.ProviderNameIssue
import java.time.Instant

fun AdminPaymentProviderDto.asModel(): AdminPaymentProvider = AdminPaymentProvider(
    id = id,
    slug = slug,
    name = name,
    type = type,
    logoUrl = logoUrl,
    aliases = aliases,
    sortOrder = sortOrder,
    isActive = isActive,
    isSystem = isSystem,
    updatedAt = Instant.parse(updatedAt),
)

fun ProviderInput.toCreateRequest() = CreateProviderRequestDto(
    name = name,
    type = type,
    aliases = aliases,
    sortOrder = sortOrder,
)

fun ProviderChanges.toUpdateRequest() = UpdateProviderRequestDto(
    name = name,
    type = type,
    aliases = aliases,
    sortOrder = sortOrder,
)

/** Branches on the backend's stable error codes, never on the message. */
fun ApiError.toAdminProviderError(): AdminProviderError = when (this) {
    ApiError.Network -> AdminProviderError.Network
    is ApiError.Unknown -> AdminProviderError.Unexpected
    is ApiError.Http -> when (code) {
        "conflict" -> AdminProviderError.Conflict
        "system_provider_locked" -> AdminProviderError.Locked
        "forbidden" -> AdminProviderError.Forbidden
        "not_found" -> AdminProviderError.NotFound
        "validation_failed" -> fields.firstNotNullOfOrNull { field ->
            when {
                field.field == "name" -> AdminProviderError.InvalidName(
                    if (field.code == "max_length") ProviderNameIssue.TOO_LONG else ProviderNameIssue.REQUIRED,
                )
                // `aliases` is the list itself; `aliases[2]` one alias.
                field.field == "aliases" && field.code == "max_length" -> AdminProviderError.InvalidAliases(AliasIssue.TOO_MANY)
                field.field.startsWith("aliases[") && field.code == "max_length" -> AdminProviderError.InvalidAliases(
                    AliasIssue.TOO_LONG,
                )

                field.field.startsWith("aliases") -> AdminProviderError.InvalidAliases(AliasIssue.INVALID)
                field.field == "file" && field.code == "max_size" -> AdminProviderError.LogoTooLarge
                field.field == "file" -> AdminProviderError.LogoUnsupported
                else -> null
            }
        } ?: AdminProviderError.Unexpected

        else -> AdminProviderError.Unexpected
    }
}
