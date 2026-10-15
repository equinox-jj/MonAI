package com.djtech.monai.feature.profile.presentation.editprofile

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.media.CropSpec
import com.djtech.monai.feature.profile.presentation.editprofile.model.CropState
import com.djtech.monai.feature.profile.presentation.editprofile.model.EditProfileSheet
import com.djtech.monai.feature.profile.presentation.editprofile.model.TimezoneOption

/**
 * @param isLoading the user hasn't been cached yet, so the fields are empty and locked.
 * @param name the name being typed; starts at the saved one.
 * @param hasChanges [name] or [timezone] differs from what is saved.
 * @param uploadProgress 0..1 while a new photo uploads; null otherwise.
 * @param password typed to confirm deleting the account.
 * @param indonesianTimezones the timezone sheet's first group, filtered by [timezoneQuery].
 * @param otherTimezones every other zone matching [timezoneQuery].
 * @param crop the picked photo being framed, over everything else.
 */
@Immutable
data class EditProfileState(
    val isLoading: Boolean = true,
    val name: String = "",
    val email: String = "",
    val initials: String = "",
    val avatarUrl: String? = null,
    val timezone: String = "",
    val selectedTimezone: TimezoneOption? = null,
    val nameError: UiText? = null,
    val hasChanges: Boolean = false,
    val isSaving: Boolean = false,
    val uploadProgress: Float? = null,
    val isRemovingPhoto: Boolean = false,
    val password: String = "",
    val passwordError: UiText? = null,
    val isDeleting: Boolean = false,
    val isConfirmingDelete: Boolean = false,
    val sheet: EditProfileSheet? = null,
    val timezoneQuery: String = "",
    val indonesianTimezones: List<TimezoneOption> = emptyList(),
    val otherTimezones: List<TimezoneOption> = emptyList(),
    val crop: CropState? = null,
) {
    val canSave: Boolean get() = hasChanges && !isSaving && !isLoading && name.isNotBlank()
    val hasPhoto: Boolean get() = avatarUrl != null
    val isChangingPhoto: Boolean get() = uploadProgress != null || isRemovingPhoto
    val canDelete: Boolean get() = password.isNotEmpty() && !isDeleting
}

sealed interface EditProfileIntent {
    data class NameChanged(val name: String) : EditProfileIntent

    data object Save : EditProfileIntent

    data object Back : EditProfileIntent

    data class ShowSheet(val sheet: EditProfileSheet) : EditProfileIntent

    data object DismissSheet : EditProfileIntent

    data class TimezoneQueryChanged(val query: String) : EditProfileIntent

    data class PickTimezone(val id: String) : EditProfileIntent

    data object TakePhoto : EditProfileIntent

    data object ChooseFromGallery : EditProfileIntent

    /** The camera or the gallery returned a photo; null when the user backed out. */
    data class PhotoPicked(val uri: String?) : EditProfileIntent

    /** A drag, pinch or slider move in the crop window. */
    data class CropChanged(val spec: CropSpec) : EditProfileIntent

    data object RotateCrop : EditProfileIntent

    data object ResetCrop : EditProfileIntent

    data object CancelCrop : EditProfileIntent

    /** Crops, then uploads. */
    data object ConfirmCrop : EditProfileIntent

    data object RemovePhoto : EditProfileIntent

    data class PasswordChanged(val password: String) : EditProfileIntent

    /** Asks to confirm first. */
    data object DeleteAccount : EditProfileIntent

    data object ConfirmDeleteAccount : EditProfileIntent

    data object DismissDeleteAccount : EditProfileIntent
}

sealed interface EditProfileEffect {
    /** Left without saving: close the screen. */
    data object Close : EditProfileEffect

    /** Open the camera, writing the photo to [uri]. */
    data class LaunchCamera(val uri: String) : EditProfileEffect

    data object LaunchGallery : EditProfileEffect

    /** A save or photo change went through. */
    data class ShowSuccess(val message: UiText) : EditProfileEffect

    data class ShowError(val message: UiText) : EditProfileEffect
}
