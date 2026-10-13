package com.djtech.monai.feature.settings.presentation.manageproviders.model

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.model.WalletType

enum class ProviderStatus { SYSTEM, ACTIVE, INACTIVE }

/** One provider in the admin list. [monogram] stands in while there is no logo. */
@Immutable
data class ProviderRow(
    val id: String,
    val name: String,
    val monogram: String,
    val logoUrl: String?,
    val type: WalletType,
    /** Comma-separated, as typed into quick add. */
    val aliases: String,
    val status: ProviderStatus,
)
