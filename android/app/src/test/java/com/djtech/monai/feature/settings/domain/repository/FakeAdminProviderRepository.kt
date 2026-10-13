package com.djtech.monai.feature.settings.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.settings.domain.model.AdminPaymentProvider
import com.djtech.monai.feature.settings.domain.model.AdminProviderError
import com.djtech.monai.feature.settings.domain.model.AdminProviderResult
import com.djtech.monai.feature.settings.domain.model.ProviderChanges
import com.djtech.monai.feature.settings.domain.model.ProviderInput
import java.time.Instant

/** Keeps [providers] in memory; every call is recorded in [calls] and fails with its error when set. */
class FakeAdminProviderRepository(providers: List<AdminPaymentProvider> = emptyList()) : AdminProviderRepository {
    val providers = providers.toMutableList()
    val calls = mutableListOf<String>()
    var listError: AdminProviderError? = null
    var createError: AdminProviderError? = null
    var updateError: AdminProviderError? = null
    var statusError: AdminProviderError? = null
    var deleteError: AdminProviderError? = null
    var logoError: AdminProviderError? = null
    val uploadedLogos = mutableListOf<EncodedImage>()

    override suspend fun listProviders(): AdminProviderResult<List<AdminPaymentProvider>> {
        calls += "list"
        listError?.let { return Outcome.Failure(it) }
        return Outcome.Success(
            providers.sortedWith(compareBy(AdminPaymentProvider::sortOrder, AdminPaymentProvider::name)),
        )
    }

    override suspend fun getProvider(id: String): AdminProviderResult<AdminPaymentProvider> {
        calls += "get($id)"
        return find(id)
    }

    override suspend fun createProvider(input: ProviderInput): AdminProviderResult<AdminPaymentProvider> {
        calls += "create(${input.name})"
        createError?.let { return Outcome.Failure(it) }
        val created = adminProvider(
            id = "new-${providers.size + 1}",
            name = input.name,
            type = input.type,
            aliases = input.aliases,
            sortOrder = input.sortOrder,
        )
        providers += created
        return Outcome.Success(created)
    }

    override suspend fun updateProvider(
        id: String,
        changes: ProviderChanges,
    ): AdminProviderResult<AdminPaymentProvider> {
        calls += "update($id, $changes)"
        updateError?.let { return Outcome.Failure(it) }
        return replace(id) {
            it.copy(
                name = changes.name ?: it.name,
                type = changes.type ?: it.type,
                aliases = changes.aliases ?: it.aliases,
                sortOrder = changes.sortOrder ?: it.sortOrder,
            )
        }
    }

    override suspend fun setActive(id: String, active: Boolean): AdminProviderResult<AdminPaymentProvider> {
        calls += "setActive($id, $active)"
        statusError?.let { return Outcome.Failure(it) }
        return replace(id) { it.copy(isActive = active) }
    }

    override suspend fun deleteProvider(id: String): AdminProviderResult<Unit> {
        calls += "delete($id)"
        deleteError?.let { return Outcome.Failure(it) }
        providers.removeAll { it.id == id }
        return Outcome.Success(Unit)
    }

    override suspend fun uploadLogo(id: String, image: EncodedImage): AdminProviderResult<AdminPaymentProvider> {
        calls += "uploadLogo($id)"
        uploadedLogos += image
        logoError?.let { return Outcome.Failure(it) }
        return replace(id) { it.copy(logoUrl = "https://cdn.example.com/logos/$id.webp") }
    }

    private fun find(id: String): AdminProviderResult<AdminPaymentProvider> =
        providers.firstOrNull { it.id == id }?.let { Outcome.Success(it) }
            ?: Outcome.Failure(AdminProviderError.NotFound)

    private fun replace(
        id: String,
        change: (AdminPaymentProvider) -> AdminPaymentProvider,
    ): AdminProviderResult<AdminPaymentProvider> {
        val index = providers.indexOfFirst { it.id == id }
        if (index < 0) return Outcome.Failure(AdminProviderError.NotFound)
        providers[index] = change(providers[index])
        return Outcome.Success(providers[index])
    }
}

fun adminProvider(
    id: String,
    name: String = id.uppercase(),
    type: WalletType = WalletType.BANK,
    aliases: List<String> = listOf(id),
    sortOrder: Int = 10,
    isActive: Boolean = true,
    isSystem: Boolean = false,
    logoUrl: String? = null,
) = AdminPaymentProvider(
    id = id,
    slug = id,
    name = name,
    type = type,
    logoUrl = logoUrl,
    aliases = aliases,
    sortOrder = sortOrder,
    isActive = isActive,
    isSystem = isSystem,
    updatedAt = Instant.parse("2026-10-02T09:00:00Z"),
)
