package com.djtech.monai.feature.settings.presentation.providerform.preview

import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.settings.presentation.providerform.ProviderFormState
import java.time.LocalDate

internal object ProviderFormPreviewData {
    val new = ProviderFormState(
        isEditing = false,
        name = "LinkAja",
        slug = "linkaja",
        monogram = "LA",
        type = WalletType.E_WALLET,
        aliases = listOf("linkaja", "link aja"),
        canSave = true,
    )

    val edit = ProviderFormState(
        isEditing = true,
        name = "OVO",
        slug = "ovo",
        monogram = "OVO",
        type = WalletType.E_WALLET,
        aliases = listOf("ovo"),
        sortOrder = "70",
        isActive = false,
        canSave = true,
        canDelete = true,
        lastEdited = LocalDate.of(2026, 10, 2),
    )
}
