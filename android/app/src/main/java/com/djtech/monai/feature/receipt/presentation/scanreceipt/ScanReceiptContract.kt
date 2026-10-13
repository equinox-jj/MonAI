package com.djtech.monai.feature.receipt.presentation.scanreceipt

import androidx.compose.runtime.Immutable
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.CameraPermission
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ScanPhase

@Immutable
data class ScanReceiptState(
    val phase: ScanPhase = ScanPhase.Camera,
    val permission: CameraPermission = CameraPermission.UNKNOWN,
    val flashOn: Boolean = false,
    /** A photo is being taken; the shutter is disabled. */
    val isCapturing: Boolean = false,
)

sealed interface ScanReceiptIntent {
    data class PermissionResult(val granted: Boolean) : ScanReceiptIntent

    data object ToggleFlash : ScanReceiptIntent

    /** The shutter: asks for a file to write the photo to. */
    data object Capture : ScanReceiptIntent

    data class PhotoTaken(val uri: String) : ScanReceiptIntent

    data object CaptureFailed : ScanReceiptIntent

    data object OpenGallery : ScanReceiptIntent

    /** The gallery's answer; null when nothing was picked. */
    data class PhotoPicked(val uri: String?) : ScanReceiptIntent

    /** Back to the camera, from processing or the no-text sheet. */
    data object Retake : ScanReceiptIntent

    /** "Type instead" or "Enter manually": the add form. */
    data object TypeInstead : ScanReceiptIntent

    data object Close : ScanReceiptIntent
}

sealed interface ScanReceiptEffect {
    /** Write the photo to [uri], then send PhotoTaken or CaptureFailed. */
    data class TakePhoto(val uri: String) : ScanReceiptEffect

    data object LaunchGallery : ScanReceiptEffect

    /** [aiFailed]: the AI couldn't read it, so [draft] is empty for the user to fill. */
    data class OpenReview(val photoUri: String, val draft: ReceiptDraft, val aiFailed: Boolean) : ScanReceiptEffect

    data object OpenForm : ScanReceiptEffect

    data object Close : ScanReceiptEffect
}
