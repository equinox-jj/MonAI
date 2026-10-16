package com.djtech.monai.feature.profile.presentation.editprofile

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.relocation.BringIntoViewRequester
import androidx.compose.foundation.relocation.bringIntoViewRequester
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.common.ui.rememberTakePicture
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.ScreenPlacement
import com.djtech.monai.core.designsystem.component.rememberMonAIMessenger
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.profile.presentation.editprofile.components.EditProfileAvatar
import com.djtech.monai.feature.profile.presentation.editprofile.components.EditProfileCrop
import com.djtech.monai.feature.profile.presentation.editprofile.components.EditProfileDeleteCard
import com.djtech.monai.feature.profile.presentation.editprofile.components.EditProfileDeleteDialog
import com.djtech.monai.feature.profile.presentation.editprofile.components.EditProfileFields
import com.djtech.monai.feature.profile.presentation.editprofile.components.EditProfilePhotoSheet
import com.djtech.monai.feature.profile.presentation.editprofile.components.EditProfileTimezoneSheet
import com.djtech.monai.feature.profile.presentation.editprofile.model.EditProfileSheet
import com.djtech.monai.feature.profile.presentation.editprofile.preview.EditProfilePreviewData

/**
 * @param onClose left without saving.
 * @param focusDelete scrolls to the delete-account card once, for Settings' "Delete account".
 */
@Composable
fun EditProfileRoute(
    onClose: () -> Unit,
    modifier: Modifier = Modifier,
    focusDelete: Boolean = false,
    placement: ScreenPlacement = ScreenPlacement.FullScreen,
    viewModel: EditProfileViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val messenger = rememberMonAIMessenger()
    val successIcon = MonAIIcons.CheckCircle
    val successTint = MonAITheme.colors.success
    val errorIcon = MonAIIcons.Error
    val errorTint = MonAITheme.colors.error
    val takePicture = rememberTakePicture(
        onDenied = { messenger.show(UiText.Resource(R.string.camera_permission_denied)) },
        onResult = { viewModel.onIntent(EditProfileIntent.PhotoPicked(it)) },
    )
    val gallery = rememberLauncherForActivityResult(ActivityResultContracts.PickVisualMedia()) { uri: Uri? ->
        viewModel.onIntent(EditProfileIntent.PhotoPicked(uri?.toString()))
    }
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            EditProfileEffect.Close -> onClose()
            is EditProfileEffect.LaunchCamera -> takePicture(effect.uri)

            EditProfileEffect.LaunchGallery -> gallery.launch(
                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly),
            )

            is EditProfileEffect.ShowSuccess ->
                messenger.show(effect.message, icon = successIcon, iconTint = successTint)

            is EditProfileEffect.ShowError -> messenger.show(effect.message, icon = errorIcon, iconTint = errorTint)
        }
    }
    EditProfileScreen(
        state,
        viewModel::onIntent,
        modifier,
        focusDelete = focusDelete,
        placement = placement,
        snackbarHostState = messenger.hostState,
    )
}

/** Photo, name, email and timezone, then the delete-account card. Save sits in the top bar. */
@Composable
fun EditProfileScreen(
    state: EditProfileState,
    onIntent: (EditProfileIntent) -> Unit,
    modifier: Modifier = Modifier,
    focusDelete: Boolean = false,
    placement: ScreenPlacement = ScreenPlacement.FullScreen,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
    val deleteCard = remember { BringIntoViewRequester() }
    var hasFocusedDelete by rememberSaveable { mutableStateOf(false) }
    LaunchedEffect(focusDelete, state.isLoading) {
        if (focusDelete && !hasFocusedDelete && !state.isLoading) {
            deleteCard.bringIntoView()
            hasFocusedDelete = true
        }
    }
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.surface),
    ) {
        Column(
            Modifier
                .fillMaxSize()
                .imePadding(),
        ) {
            MonAITopBar(
                title = stringResource(R.string.profile_title),
                onNavigationClick = { onIntent(EditProfileIntent.Back) },
                navigationContentDescription = stringResource(R.string.profile_back),
                placement = placement,
                actions = {
                    MonAIButton(
                        stringResource(R.string.profile_save),
                        onClick = { onIntent(EditProfileIntent.Save) },
                        size = MonAIButtonSize.Small,
                        enabled = state.canSave,
                        loading = state.isSaving,
                    )
                },
            )
            Column(
                Modifier
                    .weight(1f)
                    .verticalScroll(rememberScrollState())
                    .navigationBarsPadding()
                    .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2)
                    .widthIn(max = 640.dp),
                verticalArrangement = Arrangement.spacedBy(spacing.sectionGap),
            ) {
                EditProfileAvatar(
                    state.initials,
                    state.avatarUrl,
                    state.uploadProgress,
                    state.isRemovingPhoto,
                    onChangePhoto = { onIntent(EditProfileIntent.ShowSheet(EditProfileSheet.PhotoSource)) },
                    onRemovePhoto = { onIntent(EditProfileIntent.RemovePhoto) },
                )
                EditProfileFields(
                    name = state.name,
                    nameError = state.nameError?.asString(),
                    email = state.email,
                    timezone = state.selectedTimezone,
                    enabled = !state.isLoading,
                    onNameChange = { onIntent(EditProfileIntent.NameChanged(it)) },
                    onPickTimezone = { onIntent(EditProfileIntent.ShowSheet(EditProfileSheet.Timezone)) },
                )
                EditProfileDeleteCard(
                    password = state.password,
                    passwordError = state.passwordError?.asString(),
                    isDeleting = state.isDeleting,
                    onPasswordChange = { onIntent(EditProfileIntent.PasswordChanged(it)) },
                    onDelete = { onIntent(EditProfileIntent.DeleteAccount) },
                    modifier = Modifier.bringIntoViewRequester(deleteCard),
                )
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    when (state.sheet) {
        EditProfileSheet.PhotoSource -> EditProfilePhotoSheet(
            hasPhoto = state.hasPhoto,
            onTakePhoto = { onIntent(EditProfileIntent.TakePhoto) },
            onChooseFromGallery = { onIntent(EditProfileIntent.ChooseFromGallery) },
            onRemove = { onIntent(EditProfileIntent.RemovePhoto) },
            onDismiss = { onIntent(EditProfileIntent.DismissSheet) },
        )

        EditProfileSheet.Timezone -> EditProfileTimezoneSheet(
            selected = state.timezone,
            query = state.timezoneQuery,
            indonesian = state.indonesianTimezones,
            others = state.otherTimezones,
            onQueryChange = { onIntent(EditProfileIntent.TimezoneQueryChanged(it)) },
            onPick = { onIntent(EditProfileIntent.PickTimezone(it)) },
            onDismiss = { onIntent(EditProfileIntent.DismissSheet) },
        )

        null -> Unit
    }
    state.crop?.let { crop ->
        EditProfileCrop(
            crop,
            onSpecChange = { onIntent(EditProfileIntent.CropChanged(it)) },
            onRotate = { onIntent(EditProfileIntent.RotateCrop) },
            onReset = { onIntent(EditProfileIntent.ResetCrop) },
            onCancel = { onIntent(EditProfileIntent.CancelCrop) },
            onDone = { onIntent(EditProfileIntent.ConfirmCrop) },
        )
    }
    if (state.isConfirmingDelete) {
        EditProfileDeleteDialog(
            onConfirm = { onIntent(EditProfileIntent.ConfirmDeleteAccount) },
            onDismiss = { onIntent(EditProfileIntent.DismissDeleteAccount) },
        )
    }
}

@PreviewLightDark
@Composable
private fun EditProfileScreenPreview() {
    MonAITheme {
        EditProfileScreen(EditProfilePreviewData.state, onIntent = {})
    }
}

@PreviewLightDark
@Composable
private fun EditProfileScreenUploadingPreview() {
    MonAITheme {
        EditProfileScreen(EditProfilePreviewData.uploading, onIntent = {})
    }
}
