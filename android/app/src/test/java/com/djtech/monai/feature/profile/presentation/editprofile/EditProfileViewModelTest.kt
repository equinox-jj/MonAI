package com.djtech.monai.feature.profile.presentation.editprofile

import com.djtech.monai.R
import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.media.CropSpec
import com.djtech.monai.core.media.FakeImageBitmap
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.user
import com.djtech.monai.feature.profile.domain.model.NameIssue
import com.djtech.monai.feature.profile.domain.model.ProfileChanges
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.repository.FakeProfileRepository
import com.djtech.monai.feature.profile.domain.usecase.DeleteAccountUseCase
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.profile.domain.usecase.RefreshUserUseCase
import com.djtech.monai.feature.profile.domain.usecase.RemoveAvatarUseCase
import com.djtech.monai.feature.profile.domain.usecase.UpdateProfileUseCase
import com.djtech.monai.feature.profile.domain.usecase.UploadAvatarUseCase
import com.djtech.monai.feature.profile.presentation.editprofile.model.EditProfileSheet
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class EditProfileViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val profiles = FakeProfileRepository(
        user(name = "Joshua Pardede", avatarUrl = "https://cdn.example.com/a.webp", timezone = "Asia/Jakarta"),
    )
    private val images = FakeImageProcessor().apply { preview = FakeImageBitmap(400, 300) }

    private fun runEditTest(
        block: suspend TestScope.(EditProfileViewModel, MutableList<EditProfileEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = EditProfileViewModel(
            observeUser = ObserveUserUseCase(profiles),
            refreshUser = RefreshUserUseCase(profiles),
            updateProfile = UpdateProfileUseCase(profiles),
            uploadAvatar = UploadAvatarUseCase(profiles, images),
            removeAvatar = RemoveAvatarUseCase(profiles),
            deleteAccount = DeleteAccountUseCase(profiles),
            imageProcessor = images,
            clock = FixedAppClock(NOW),
        )
        val effects = mutableListOf<EditProfileEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: EditProfileViewModel, vararg intents: EditProfileIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `fills the form from the cached user and refreshes it`() = runEditTest { vm, _ ->
        val state = vm.state.value

        assertFalse(state.isLoading)
        assertEquals("Joshua Pardede", state.name)
        assertEquals("JP", state.initials)
        assertEquals("Asia/Jakarta", state.timezone)
        assertEquals("Jakarta", state.selectedTimezone?.label)
        assertEquals("UTC+7", state.selectedTimezone?.offset)
        assertTrue(state.hasPhoto)
        assertFalse(state.canSave)
        assertEquals(1, profiles.refreshCount)
    }

    @Test
    fun `saving a new name and timezone sends both and reports it`() = runEditTest { vm, effects ->
        send(
            vm,
            EditProfileIntent.NameChanged("Joshua P"),
            EditProfileIntent.ShowSheet(EditProfileSheet.Timezone),
            EditProfileIntent.PickTimezone("Asia/Makassar"),
        )
        assertTrue(vm.state.value.canSave)
        assertNull(vm.state.value.sheet)

        send(vm, EditProfileIntent.Save)

        assertEquals(listOf(ProfileChanges(name = "Joshua P", timezone = "Asia/Makassar")), profiles.updates)
        assertEquals(listOf<EditProfileEffect>(EditProfileEffect.Saved), effects)
        assertFalse(vm.state.value.hasChanges)
    }

    @Test
    fun `a refused name shows the error on the field`() = runEditTest { vm, _ ->
        send(vm, EditProfileIntent.NameChanged("  "))
        assertFalse(vm.state.value.canSave)

        profiles.updateError = ProfileError.InvalidName(NameIssue.TOO_LONG)
        send(vm, EditProfileIntent.NameChanged("Joshua Panjaitan"), EditProfileIntent.Save)

        assertEquals(UiText.Resource(R.string.profile_error_name_too_long, 100), vm.state.value.nameError)

        send(vm, EditProfileIntent.NameChanged("Josh"))
        assertNull(vm.state.value.nameError)
    }

    @Test
    fun `the timezone sheet lists indonesia first and filters`() = runEditTest { vm, _ ->
        send(vm, EditProfileIntent.ShowSheet(EditProfileSheet.Timezone))
        assertEquals(
            listOf("Asia/Jakarta", "Asia/Makassar", "Asia/Jayapura"),
            vm.state.value.indonesianTimezones.map { it.id },
        )
        assertTrue(vm.state.value.otherTimezones.any { it.id == "Europe/London" })

        send(vm, EditProfileIntent.TimezoneQueryChanged("ho chi"))

        assertTrue(vm.state.value.indonesianTimezones.isEmpty())
        assertEquals(listOf("Asia/Ho_Chi_Minh"), vm.state.value.otherTimezones.map { it.id })
    }

    @Test
    fun `taking a photo opens the camera with a new file`() = runEditTest { vm, effects ->
        send(vm, EditProfileIntent.ShowSheet(EditProfileSheet.PhotoSource), EditProfileIntent.TakePhoto)

        assertNull(vm.state.value.sheet)
        assertEquals(EditProfileEffect.LaunchCamera("content://camera/1"), effects.single())
    }

    @Test
    fun `a picked photo is framed, then uploaded with progress`() = runEditTest { vm, _ ->
        send(vm, EditProfileIntent.PhotoPicked("content://photo"))
        assertEquals("content://photo", vm.state.value.crop?.uri)
        assertEquals(images.preview, vm.state.value.crop?.preview)

        send(
            vm,
            EditProfileIntent.CropChanged(CropSpec(zoom = 2f, offsetX = 0.1f)),
            EditProfileIntent.ConfirmCrop,
        )

        assertNull(vm.state.value.crop)
        assertNull(vm.state.value.uploadProgress)
        assertEquals(CropSpec(zoom = 2f, offsetX = 0.1f), images.crops.single().spec)
        assertEquals("https://cdn.example.com/avatars/new.webp", vm.state.value.avatarUrl)
    }

    @Test
    fun `crop offsets stay inside the photo and rotating starts them over`() = runEditTest { vm, _ ->
        send(vm, EditProfileIntent.PhotoPicked("content://photo"))

        send(vm, EditProfileIntent.CropChanged(CropSpec(zoom = 9f, offsetX = 9f)))
        assertEquals(CropSpec.MAX_ZOOM, vm.state.value.crop?.spec?.zoom)
        // A 400×300 photo at 2.5x shows 120px; 140px are left on each side.
        assertEquals(140f / 120f, vm.state.value.crop?.spec?.offsetX ?: 0f, 0.001f)

        send(vm, EditProfileIntent.RotateCrop)
        assertEquals(CropSpec(zoom = CropSpec.MAX_ZOOM, quarterTurns = 1), vm.state.value.crop?.spec)

        send(vm, EditProfileIntent.ResetCrop)
        assertEquals(CropSpec(), vm.state.value.crop?.spec)
    }

    @Test
    fun `an unreadable photo says so`() = runEditTest { vm, effects ->
        images.preview = null

        send(vm, EditProfileIntent.PhotoPicked("content://broken"))

        assertNull(vm.state.value.crop)
        assertEquals(
            EditProfileEffect.ShowMessage(UiText.Resource(R.string.profile_crop_unreadable)),
            effects.single(),
        )
    }

    @Test
    fun `backing out of the camera does nothing`() = runEditTest { vm, _ ->
        send(vm, EditProfileIntent.PhotoPicked(null))

        assertNull(vm.state.value.crop)
    }

    @Test
    fun `a failed upload says why`() = runEditTest { vm, effects ->
        profiles.uploadError = ProfileError.PhotoTooLarge

        send(vm, EditProfileIntent.PhotoPicked("content://photo"))
        send(vm, EditProfileIntent.ConfirmCrop)

        assertEquals(
            EditProfileEffect.ShowMessage(UiText.Resource(R.string.profile_error_photo_too_large)),
            effects.single(),
        )
        assertEquals("https://cdn.example.com/a.webp", vm.state.value.avatarUrl)
    }

    @Test
    fun `removing the photo goes back to initials`() = runEditTest { vm, _ ->
        send(vm, EditProfileIntent.RemovePhoto)

        assertEquals(1, profiles.removeAvatarCount)
        assertFalse(vm.state.value.hasPhoto)
    }

    @Test
    fun `deleting needs the password, then a confirmation`() = runEditTest { vm, _ ->
        send(vm, EditProfileIntent.DeleteAccount)
        assertEquals(UiText.Resource(R.string.profile_error_password_required), vm.state.value.passwordError)
        assertFalse(vm.state.value.isConfirmingDelete)

        send(vm, EditProfileIntent.PasswordChanged("secret"), EditProfileIntent.DeleteAccount)
        assertTrue(vm.state.value.isConfirmingDelete)
        assertTrue(profiles.deletedWithPasswords.isEmpty())

        send(vm, EditProfileIntent.ConfirmDeleteAccount)
        assertEquals(listOf("secret"), profiles.deletedWithPasswords)
    }

    @Test
    fun `a wrong password shows on the field`() = runEditTest { vm, _ ->
        profiles.deleteError = ProfileError.WrongPassword

        send(
            vm,
            EditProfileIntent.PasswordChanged("nope"),
            EditProfileIntent.DeleteAccount,
            EditProfileIntent.ConfirmDeleteAccount,
        )

        assertEquals(UiText.Resource(R.string.profile_error_wrong_password), vm.state.value.passwordError)
        assertFalse(vm.state.value.isDeleting)
    }

    @Test
    fun `the last admin is told why`() = runEditTest { vm, effects ->
        profiles.deleteError = ProfileError.LastAdmin

        send(
            vm,
            EditProfileIntent.PasswordChanged("secret"),
            EditProfileIntent.DeleteAccount,
            EditProfileIntent.ConfirmDeleteAccount,
        )

        assertEquals(
            EditProfileEffect.ShowMessage(UiText.Resource(R.string.profile_error_last_admin)),
            effects.single(),
        )
    }
}
