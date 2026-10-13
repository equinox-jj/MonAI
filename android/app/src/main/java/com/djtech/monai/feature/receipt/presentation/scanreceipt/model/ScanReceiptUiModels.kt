package com.djtech.monai.feature.receipt.presentation.scanreceipt.model

/** Where the scan is: aiming the camera, reading a photo, or a photo with no text. */
sealed interface ScanPhase {
    data object Camera : ScanPhase

    /** [step] is how far reading [photoUri] has got. */
    data class Processing(val photoUri: String, val step: ProcessingStep) : ScanPhase

    /** OCR found nothing on the photo: retake or type it in. */
    data object NoText : ScanPhase
}

enum class ProcessingStep { READING_TEXT, FINDING_DETAILS }

/** Whether the camera may be used; unknown until the system answers the request. */
enum class CameraPermission { UNKNOWN, GRANTED, DENIED }
