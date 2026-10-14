package com.djtech.monai.feature.receipt.presentation.scanreceipt

import android.Manifest
import android.content.pm.PackageManager
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.camera.core.ImageCapture
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.core.content.ContextCompat
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.feature.receipt.presentation.scanreceipt.components.ScanReceiptCamera
import com.djtech.monai.feature.receipt.presentation.scanreceipt.components.ScanReceiptControls
import com.djtech.monai.feature.receipt.presentation.scanreceipt.components.ScanReceiptFrame
import com.djtech.monai.feature.receipt.presentation.scanreceipt.components.ScanReceiptHint
import com.djtech.monai.feature.receipt.presentation.scanreceipt.components.ScanReceiptNoText
import com.djtech.monai.feature.receipt.presentation.scanreceipt.components.ScanReceiptProcessing
import com.djtech.monai.feature.receipt.presentation.scanreceipt.components.takePhotoTo
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.CameraPermission
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ProcessingStep
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ScanPhase
import kotlinx.coroutines.launch

/**
 * @param onOpenReview a photo was read: review the draft, [Boolean] true when the AI couldn't help.
 * @param onOpenForm "Type instead" or "Enter manually".
 */
@Composable
fun ScanReceiptRoute(
    onClose: () -> Unit,
    onOpenReview: (photoUri: String, draft: ReceiptDraft, aiFailed: Boolean) -> Unit,
    onOpenForm: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: ScanReceiptViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }
    val captureFailed = stringResource(R.string.scan_capture_failed)
    val imageCapture = remember {
        ImageCapture.Builder().setCaptureMode(ImageCapture.CAPTURE_MODE_MINIMIZE_LATENCY).build()
    }
    val permissionLauncher = rememberLauncherForActivityResult(ActivityResultContracts.RequestPermission()) {
        viewModel.onIntent(ScanReceiptIntent.PermissionResult(it))
    }
    val galleryLauncher = rememberLauncherForActivityResult(ActivityResultContracts.PickVisualMedia()) {
        viewModel.onIntent(ScanReceiptIntent.PhotoPicked(it?.toString()))
    }
    LaunchedEffect(Unit) {
        val granted = ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) ==
            PackageManager.PERMISSION_GRANTED
        if (granted) {
            viewModel.onIntent(ScanReceiptIntent.PermissionResult(true))
        } else {
            permissionLauncher.launch(Manifest.permission.CAMERA)
        }
    }
    LaunchedEffect(state.flashOn) {
        imageCapture.flashMode = if (state.flashOn) ImageCapture.FLASH_MODE_ON else ImageCapture.FLASH_MODE_OFF
    }
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is ScanReceiptEffect.TakePhoto -> imageCapture.takePhotoTo(context, effect.uri) { saved ->
                if (saved) {
                    viewModel.onIntent(ScanReceiptIntent.PhotoTaken(effect.uri))
                } else {
                    viewModel.onIntent(ScanReceiptIntent.CaptureFailed)
                    scope.launch { snackbarHostState.showSnackbar(MonAISnackbarVisuals(captureFailed)) }
                }
            }

            ScanReceiptEffect.LaunchGallery ->
                galleryLauncher.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly))

            is ScanReceiptEffect.OpenReview -> onOpenReview(effect.photoUri, effect.draft, effect.aiFailed)
            ScanReceiptEffect.OpenForm -> onOpenForm()
            ScanReceiptEffect.Close -> onClose()
        }
    }
    ScanReceiptScreen(
        state = state,
        onIntent = viewModel::onIntent,
        onAllowCamera = { permissionLauncher.launch(Manifest.permission.CAMERA) },
        modifier = modifier,
        snackbarHostState = snackbarHostState,
        camera = { ScanReceiptCamera(imageCapture, Modifier.fillMaxSize()) },
    )
}

/** [camera] is the live preview; a plain dark area in previews. */
@Composable
fun ScanReceiptScreen(
    state: ScanReceiptState,
    onIntent: (ScanReceiptIntent) -> Unit,
    onAllowCamera: () -> Unit,
    modifier: Modifier = Modifier,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
    camera: @Composable () -> Unit = {},
) {
    // The camera is always shown on black, whatever the theme.
    Box(
        modifier
            .fillMaxSize()
            .background(Color.Black),
    ) {
        val phase = state.phase
        if (phase !is ScanPhase.Processing && state.permission == CameraPermission.GRANTED) camera()
        Column(
            Modifier
                .fillMaxSize()
                .statusBarsPadding(),
        ) {
            Header(state, onIntent)
            Box(
                Modifier
                    .weight(1f)
                    .fillMaxWidth(),
                contentAlignment = Alignment.Center,
            ) {
                when {
                    phase is ScanPhase.Processing -> ScanReceiptProcessing(
                        phase.photoUri,
                        phase.step,
                        Modifier.padding(horizontal = MonAITheme.spacing.screenHorizontal),
                    )

                    state.permission == CameraPermission.DENIED -> PermissionOff(onAllowCamera)
                    else -> Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x5),
                    ) {
                        ScanReceiptFrame()
                        ScanReceiptHint(stringResource(R.string.scan_hint))
                    }
                }
            }
            if (phase is ScanPhase.Processing) {
                MonAIButton(
                    stringResource(R.string.scan_cancel),
                    onClick = { onIntent(ScanReceiptIntent.Retake) },
                    modifier = Modifier
                        .align(Alignment.CenterHorizontally)
                        .padding(bottom = MonAITheme.spacing.x10),
                    variant = MonAIButtonVariant.Outlined,
                    size = MonAIButtonSize.Medium,
                )
            } else {
                ScanReceiptControls(
                    canCapture = state.permission == CameraPermission.GRANTED && !state.isCapturing,
                    onGallery = { onIntent(ScanReceiptIntent.OpenGallery) },
                    onCapture = { onIntent(ScanReceiptIntent.Capture) },
                    onTypeInstead = { onIntent(ScanReceiptIntent.TypeInstead) },
                )
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    if (state.phase == ScanPhase.NoText) {
        ScanReceiptNoText(
            onRetake = { onIntent(ScanReceiptIntent.Retake) },
            onManual = { onIntent(ScanReceiptIntent.TypeInstead) },
        )
    }
}

@Composable
private fun Header(state: ScanReceiptState, onIntent: (ScanReceiptIntent) -> Unit) {
    Row(
        Modifier
            .fillMaxWidth()
            .padding(MonAITheme.spacing.x4),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        MonAIIconButton(
            MonAIIcons.Close,
            stringResource(R.string.scan_close),
            onClick = { onIntent(ScanReceiptIntent.Close) },
            modifier = Modifier.background(Color.Black.copy(alpha = 0.4f), CircleShape),
            tint = Color.White,
        )
        Text(
            stringResource(R.string.scan_title),
            Modifier.weight(1f),
            style = MonAITheme.typography.titleMedium,
            color = Color.White,
            textAlign = TextAlign.Center,
        )
        if (state.phase == ScanPhase.Camera && state.permission == CameraPermission.GRANTED) {
            MonAIIconButton(
                if (state.flashOn) MonAIIcons.FlashOn else MonAIIcons.FlashOff,
                stringResource(if (state.flashOn) R.string.scan_flash_on else R.string.scan_flash_off),
                onClick = { onIntent(ScanReceiptIntent.ToggleFlash) },
                modifier = Modifier.background(Color.Black.copy(alpha = 0.4f), CircleShape),
                tint = Color.White,
            )
        } else {
            Box(Modifier.padding(MonAITheme.sizes.touchTarget / 2))
        }
    }
}

@Composable
private fun PermissionOff(onAllowCamera: () -> Unit) {
    Column(
        Modifier.padding(horizontal = MonAITheme.spacing.x8),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Text(
            stringResource(R.string.scan_permission_title),
            style = MonAITheme.typography.titleMedium,
            color = Color.White,
            textAlign = TextAlign.Center,
        )
        Text(
            stringResource(R.string.scan_permission_body),
            style = MonAITheme.typography.bodyMedium,
            color = Color.White.copy(alpha = 0.7f),
            textAlign = TextAlign.Center,
        )
        MonAIButton(
            stringResource(R.string.scan_permission_allow),
            onClick = onAllowCamera,
            size = MonAIButtonSize.Medium,
            leadingIcon = MonAIIcons.PhotoCamera,
        )
    }
}

@Preview
@Composable
private fun ScanReceiptCameraPreview() {
    MonAITheme {
        ScanReceiptScreen(ScanReceiptState(permission = CameraPermission.GRANTED), onIntent = {}, onAllowCamera = {})
    }
}

@Preview
@Composable
private fun ScanReceiptProcessingPreview() {
    MonAITheme {
        ScanReceiptScreen(
            ScanReceiptState(phase = ScanPhase.Processing("", ProcessingStep.FINDING_DETAILS)),
            onIntent = {},
            onAllowCamera = {},
        )
    }
}

@Preview
@Composable
private fun ScanReceiptDeniedPreview() {
    MonAITheme {
        ScanReceiptScreen(ScanReceiptState(permission = CameraPermission.DENIED), onIntent = {}, onAllowCamera = {})
    }
}
