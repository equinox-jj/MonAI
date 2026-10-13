package com.djtech.monai.feature.settings.presentation.settings.preview

import com.djtech.monai.core.model.AppLanguage
import com.djtech.monai.core.model.ThemeMode
import com.djtech.monai.feature.settings.presentation.settings.SettingsState
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsProfile
import java.time.YearMonth

internal object SettingsPreviewData {
    val admin = SettingsState(
        month = YearMonth.of(2026, 10),
        profile = SettingsProfile(
            name = "Joshua Pardede",
            email = "joshua@example.com",
            initials = "JP",
            avatarUrl = null,
            roleBadge = "Admin",
        ),
        budgetLimit = 3_000_000,
        categoryCount = 10,
        walletCount = 4,
        themeMode = ThemeMode.SYSTEM,
        language = AppLanguage.INDONESIAN,
        showAdmin = true,
        appVersion = "1.0",
    )

    val user = admin.copy(
        profile = SettingsProfile(
            name = "Sari Putri",
            email = "sari@example.com",
            initials = "SP",
            avatarUrl = null,
            roleBadge = null,
        ),
        budgetLimit = null,
        walletCount = 2,
        language = AppLanguage.ENGLISH,
        showAdmin = false,
    )
}
