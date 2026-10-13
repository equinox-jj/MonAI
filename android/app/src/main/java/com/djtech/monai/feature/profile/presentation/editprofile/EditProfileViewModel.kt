package com.djtech.monai.feature.profile.presentation.editprofile

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.format.initialsOf
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.media.CropSpec
import com.djtech.monai.core.media.ImageProcessor
import com.djtech.monai.core.media.clamped
import com.djtech.monai.core.media.rotatedSize
import com.djtech.monai.core.model.User
import com.djtech.monai.feature.profile.domain.model.AvatarUpload
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.model.isKnownTimezone
import com.djtech.monai.feature.profile.domain.model.pickableTimezones
import com.djtech.monai.feature.profile.domain.usecase.DeleteAccountUseCase
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.profile.domain.usecase.RefreshUserUseCase
import com.djtech.monai.feature.profile.domain.usecase.RemoveAvatarUseCase
import com.djtech.monai.feature.profile.domain.usecase.UpdateProfileUseCase
import com.djtech.monai.feature.profile.domain.usecase.UploadAvatarUseCase
import com.djtech.monai.feature.profile.presentation.editprofile.mapper.message
import com.djtech.monai.feature.profile.presentation.editprofile.mapper.timezoneOption
import com.djtech.monai.feature.profile.presentation.editprofile.mapper.timezoneOptions
import com.djtech.monai.feature.profile.presentation.editprofile.model.CropState
import com.djtech.monai.feature.profile.presentation.editprofile.model.EditProfileSheet
import com.djtech.monai.feature.profile.presentation.editprofile.model.TimezoneOption
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Edits the display name and timezone, changes or removes the profile photo (picked, then cropped
 * square and uploaded with progress), and deletes the account behind the password.
 */
@HiltViewModel
class EditProfileViewModel @Inject constructor(
    observeUser: ObserveUserUseCase,
    private val refreshUser: RefreshUserUseCase,
    private val updateProfile: UpdateProfileUseCase,
    private val uploadAvatar: UploadAvatarUseCase,
    private val removeAvatar: RemoveAvatarUseCase,
    private val deleteAccount: DeleteAccountUseCase,
    private val imageProcessor: ImageProcessor,
    private val clock: AppClock,
) : ViewModel() {

    private val ui = MutableStateFlow(Ui())

    // Read once: the zone list doesn't change while the app runs.
    private val allTimezones by lazy { pickableTimezones() }

    val state: StateFlow<EditProfileState> = combine(observeUser(), ui) { user, ui -> toState(user, ui) }
        .stateIn(viewModelScope, WhileUiSubscribed, EditProfileState())

    private val effectChannel = Channel<EditProfileEffect>(Channel.BUFFERED)
    val effects: Flow<EditProfileEffect> = effectChannel.receiveAsFlow()

    private var cropJob: Job? = null

    init {
        viewModelScope.launch { refreshUser() }
    }

    fun onIntent(intent: EditProfileIntent) {
        when (intent) {
            is EditProfileIntent.NameChanged -> ui.update {
                it.copy(name = intent.name.take(UpdateProfileUseCase.MAX_NAME_LENGTH), nameError = null)
            }

            EditProfileIntent.Save -> save()
            EditProfileIntent.Back -> send(EditProfileEffect.Close)
            is EditProfileIntent.ShowSheet -> ui.update { it.copy(sheet = intent.sheet, timezoneQuery = "") }
            EditProfileIntent.DismissSheet -> ui.update { it.copy(sheet = null) }
            is EditProfileIntent.TimezoneQueryChanged -> ui.update { it.copy(timezoneQuery = intent.query) }
            is EditProfileIntent.PickTimezone -> ui.update { it.copy(timezone = intent.id, sheet = null) }
            EditProfileIntent.TakePhoto -> {
                ui.update { it.copy(sheet = null) }
                send(EditProfileEffect.LaunchCamera(imageProcessor.newCameraUri()))
            }

            EditProfileIntent.ChooseFromGallery -> {
                ui.update { it.copy(sheet = null) }
                send(EditProfileEffect.LaunchGallery)
            }

            is EditProfileIntent.PhotoPicked -> intent.uri?.let(::startCrop)
            is EditProfileIntent.CropChanged -> updateCrop { crop ->
                val preview = crop.preview ?: return@updateCrop crop
                val (width, height) = rotatedSize(preview.width, preview.height, crop.spec.quarterTurns)
                crop.copy(spec = intent.spec.copy(quarterTurns = crop.spec.quarterTurns).clamped(width, height))
            }

            EditProfileIntent.RotateCrop -> updateCrop { crop ->
                // A turn swaps the sides, so the offsets start over.
                crop.copy(spec = CropSpec(zoom = crop.spec.zoom, quarterTurns = (crop.spec.quarterTurns + 1) % 4))
            }

            EditProfileIntent.ResetCrop -> updateCrop { it.copy(spec = CropSpec()) }
            EditProfileIntent.CancelCrop -> {
                cropJob?.cancel()
                ui.update { it.copy(crop = null) }
            }

            EditProfileIntent.ConfirmCrop -> upload()
            EditProfileIntent.RemovePhoto -> removePhoto()
            is EditProfileIntent.PasswordChanged -> ui.update {
                it.copy(password = intent.password, passwordError = null)
            }
            EditProfileIntent.DeleteAccount -> confirmDelete()
            EditProfileIntent.ConfirmDeleteAccount -> delete()
            EditProfileIntent.DismissDeleteAccount -> ui.update { it.copy(isConfirmingDelete = false) }
        }
    }

    private fun toState(user: User?, ui: Ui): EditProfileState {
        val name = ui.name ?: user?.name.orEmpty()
        val timezone = ui.timezone ?: user?.timezone.orEmpty()
        val now = clock.now()
        val (indonesian, others) = if (ui.sheet == EditProfileSheet.Timezone) {
            timezoneOptions(allTimezones, ui.timezoneQuery, now)
        } else {
            emptyList<TimezoneOption>() to emptyList()
        }
        return EditProfileState(
            isLoading = user == null,
            name = name,
            email = user?.email.orEmpty(),
            initials = initialsOf(name),
            avatarUrl = user?.avatarUrl,
            timezone = timezone,
            selectedTimezone = timezone.takeIf(::isKnownTimezone)?.let { timezoneOption(it, now) },
            nameError = ui.nameError,
            hasChanges = user != null && (name.trim() != user.name || timezone != user.timezone),
            isSaving = ui.isSaving,
            uploadProgress = ui.uploadProgress,
            isRemovingPhoto = ui.isRemovingPhoto,
            password = ui.password,
            passwordError = ui.passwordError,
            isDeleting = ui.isDeleting,
            isConfirmingDelete = ui.isConfirmingDelete,
            sheet = ui.sheet,
            timezoneQuery = ui.timezoneQuery,
            indonesianTimezones = indonesian,
            otherTimezones = others,
            crop = ui.crop,
        )
    }

    private fun save() {
        // Read the typed values from ui: state may not have caught up with an intent sent just before.
        val current = state.value
        if (current.isLoading || ui.value.isSaving) return
        val name = ui.value.name ?: current.name
        val timezone = ui.value.timezone ?: current.timezone
        ui.update { it.copy(isSaving = true, nameError = null) }
        viewModelScope.launch {
            val result = updateProfile(name, timezone)
            ui.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> {
                    // Back to following the cache, which now holds what was saved.
                    ui.update { it.copy(name = null, timezone = null) }
                    send(EditProfileEffect.Saved)
                }

                is Outcome.Failure -> when (val error = result.error) {
                    is ProfileError.InvalidName -> ui.update { it.copy(nameError = error.message()) }
                    else -> send(EditProfileEffect.ShowMessage(error.message()))
                }
            }
        }
    }

    private fun startCrop(uri: String) {
        ui.update { it.copy(crop = CropState(uri)) }
        cropJob?.cancel()
        cropJob = viewModelScope.launch {
            val preview = imageProcessor.loadPreview(uri, PREVIEW_SIDE)
            if (preview == null) {
                ui.update { it.copy(crop = null) }
                send(EditProfileEffect.ShowMessage(UiText.Resource(R.string.profile_crop_unreadable)))
            } else {
                updateCrop { if (it.uri == uri) it.copy(preview = preview) else it }
            }
        }
    }

    private inline fun updateCrop(change: (CropState) -> CropState) {
        ui.update { current -> current.copy(crop = current.crop?.let(change)) }
    }

    private fun upload() {
        val crop = ui.value.crop ?: return
        if (crop.preview == null || ui.value.uploadProgress != null) return
        ui.update { it.copy(crop = null, uploadProgress = 0f) }
        viewModelScope.launch {
            uploadAvatar(crop.uri, crop.spec).collect { step ->
                when (step) {
                    is AvatarUpload.Progress -> ui.update { it.copy(uploadProgress = step.fraction) }
                    is AvatarUpload.Done -> {
                        ui.update { it.copy(uploadProgress = null) }
                        val result = step.result
                        if (result is Outcome.Failure) send(EditProfileEffect.ShowMessage(result.error.message()))
                    }
                }
            }
        }
    }

    private fun removePhoto() {
        if (state.value.isChangingPhoto || !state.value.hasPhoto) return
        ui.update { it.copy(sheet = null, isRemovingPhoto = true) }
        viewModelScope.launch {
            val result = removeAvatar()
            ui.update { it.copy(isRemovingPhoto = false) }
            if (result is Outcome.Failure) send(EditProfileEffect.ShowMessage(result.error.message()))
        }
    }

    private fun confirmDelete() {
        if (ui.value.password.isEmpty()) {
            ui.update { it.copy(passwordError = UiText.Resource(R.string.profile_error_password_required)) }
            return
        }
        ui.update { it.copy(isConfirmingDelete = true) }
    }

    private fun delete() {
        if (ui.value.isDeleting) return
        val password = ui.value.password
        ui.update { it.copy(isConfirmingDelete = false, isDeleting = true, passwordError = null) }
        viewModelScope.launch {
            // On success the session ends and the app leaves for Sign in.
            val result = deleteAccount(password)
            ui.update { it.copy(isDeleting = false) }
            if (result is Outcome.Failure) {
                when (val error = result.error) {
                    ProfileError.WrongPassword, ProfileError.PasswordRequired ->
                        ui.update { it.copy(passwordError = error.message()) }

                    else -> send(EditProfileEffect.ShowMessage(error.message()))
                }
            }
        }
    }

    private fun send(effect: EditProfileEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }

    private companion object {
        /** Large enough to crop sharply at 2.5x zoom on any phone. */
        const val PREVIEW_SIDE = 2048
    }
}

/** Screen-local state; the saved profile comes from the cache. */
private data class Ui(
    /** Null until the user types, so a profile that arrives late fills the field. */
    val name: String? = null,
    /** Null until the user picks one. */
    val timezone: String? = null,
    val nameError: UiText? = null,
    val isSaving: Boolean = false,
    val uploadProgress: Float? = null,
    val isRemovingPhoto: Boolean = false,
    val password: String = "",
    val passwordError: UiText? = null,
    val isDeleting: Boolean = false,
    val isConfirmingDelete: Boolean = false,
    val sheet: EditProfileSheet? = null,
    val timezoneQuery: String = "",
    val crop: CropState? = null,
)
