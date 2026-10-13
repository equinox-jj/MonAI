package com.djtech.monai.feature.profile.presentation.editprofile.preview

import com.djtech.monai.R
import com.djtech.monai.feature.profile.presentation.editprofile.EditProfileState
import com.djtech.monai.feature.profile.presentation.editprofile.model.TimezoneOption

internal object EditProfilePreviewData {
    private val jakarta = TimezoneOption(
        "Asia/Jakarta",
        "Jakarta",
        "UTC+7",
        R.string.profile_timezone_wib,
    )

    val state = EditProfileState(
        isLoading = false,
        name = "Joshua Pardede",
        email = "joshua@example.com",
        initials = "JP",
        timezone = "Asia/Jakarta",
        selectedTimezone = jakarta,
    )

    val uploading = state.copy(uploadProgress = 0.65f, name = "Joshua P", hasChanges = true)
}
