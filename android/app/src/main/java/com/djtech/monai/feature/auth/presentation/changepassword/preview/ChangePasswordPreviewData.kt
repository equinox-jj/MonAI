package com.djtech.monai.feature.auth.presentation.changepassword.preview

import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.auth.presentation.changepassword.ChangePasswordState

internal object ChangePasswordPreviewData {
    val filled = ChangePasswordState(currentPassword = "oldPass1", newPassword = "newPass12")

    val wrongCurrent = filled.copy(currentPasswordError = UiText.Resource(R.string.change_password_wrong_current))
}
