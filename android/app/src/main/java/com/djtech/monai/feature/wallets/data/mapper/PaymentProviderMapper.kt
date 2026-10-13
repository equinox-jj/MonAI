package com.djtech.monai.feature.wallets.data.mapper

import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.PaymentProviderCatalog
import com.djtech.monai.feature.wallets.data.dto.PaymentProviderCatalogDto
import com.djtech.monai.feature.wallets.data.dto.PaymentProviderDto
import com.djtech.monai.feature.wallets.data.dto.SeedPaymentProviderDto

fun PaymentProviderDto.asModel() = PaymentProvider(
    id = id,
    slug = slug,
    name = name,
    type = type,
    logoUrl = logoUrl,
    aliases = aliases,
    sortOrder = sortOrder,
)

fun PaymentProviderCatalogDto.asModel() = PaymentProviderCatalog(
    version = version,
    providers = providers.map(PaymentProviderDto::asModel),
)

/** A seed entry has no server id yet; it is left empty and resolved by slug when a wallet is created. */
fun SeedPaymentProviderDto.asModel() = PaymentProvider(
    id = "",
    slug = slug,
    name = name,
    type = type,
    logoUrl = null,
    aliases = aliases,
    sortOrder = sortOrder,
)
