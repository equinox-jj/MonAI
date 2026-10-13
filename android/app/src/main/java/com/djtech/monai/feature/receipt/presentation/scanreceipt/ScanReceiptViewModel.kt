package com.djtech.monai.feature.receipt.presentation.scanreceipt

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.ImageProcessor
import com.djtech.monai.core.model.DraftConfidence
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.feature.receipt.domain.usecase.ParseReceiptUseCase
import com.djtech.monai.feature.receipt.domain.usecase.ReadReceiptTextUseCase
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.CameraPermission
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ProcessingStep
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ScanPhase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Takes or picks a receipt photo, reads its text on the phone, then asks the AI for a draft. No
 * text means retake or type it in; an AI failure still opens the review, empty, so the photo is kept.
 */
@HiltViewModel
class ScanReceiptViewModel @Inject constructor(
    private val readReceiptText: ReadReceiptTextUseCase,
    private val parseReceipt: ParseReceiptUseCase,
    private val imageProcessor: ImageProcessor,
) : ViewModel() {

    private val mutableState = MutableStateFlow(ScanReceiptState())
    val state: StateFlow<ScanReceiptState> = mutableState.asStateFlow()

    private val effectChannel = Channel<ScanReceiptEffect>(Channel.BUFFERED)
    val effects: Flow<ScanReceiptEffect> = effectChannel.receiveAsFlow()

    private var processing: Job? = null

    fun onIntent(intent: ScanReceiptIntent) {
        when (intent) {
            is ScanReceiptIntent.PermissionResult -> mutableState.update {
                it.copy(permission = if (intent.granted) CameraPermission.GRANTED else CameraPermission.DENIED)
            }

            ScanReceiptIntent.ToggleFlash -> mutableState.update { it.copy(flashOn = !it.flashOn) }
            ScanReceiptIntent.Capture -> if (!mutableState.value.isCapturing) {
                mutableState.update { it.copy(isCapturing = true) }
                send(ScanReceiptEffect.TakePhoto(imageProcessor.newCameraUri()))
            }

            is ScanReceiptIntent.PhotoTaken -> {
                mutableState.update { it.copy(isCapturing = false) }
                process(intent.uri)
            }

            ScanReceiptIntent.CaptureFailed -> mutableState.update { it.copy(isCapturing = false) }
            ScanReceiptIntent.OpenGallery -> send(ScanReceiptEffect.LaunchGallery)
            is ScanReceiptIntent.PhotoPicked -> intent.uri?.let(::process)
            ScanReceiptIntent.Retake -> {
                processing?.cancel()
                mutableState.update { it.copy(phase = ScanPhase.Camera) }
            }

            ScanReceiptIntent.TypeInstead -> send(ScanReceiptEffect.OpenForm)
            ScanReceiptIntent.Close -> {
                processing?.cancel()
                send(ScanReceiptEffect.Close)
            }
        }
    }

    private fun process(uri: String) {
        processing?.cancel()
        processing = viewModelScope.launch {
            setPhase(ScanPhase.Processing(uri, ProcessingStep.READING_TEXT))
            val text = readReceiptText(uri)
            if (text == null) {
                setPhase(ScanPhase.NoText)
                return@launch
            }
            setPhase(ScanPhase.Processing(uri, ProcessingStep.FINDING_DETAILS))
            val effect = when (val result = parseReceipt(text)) {
                is Outcome.Success -> ScanReceiptEffect.OpenReview(uri, result.data, aiFailed = false)
                is Outcome.Failure -> ScanReceiptEffect.OpenReview(uri, EMPTY_DRAFT, aiFailed = true)
            }
            send(effect)
            // Coming back from the review starts a new scan.
            setPhase(ScanPhase.Camera)
        }
    }

    private fun setPhase(phase: ScanPhase) = mutableState.update { it.copy(phase = phase) }

    private fun send(effect: ScanReceiptEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }

    private companion object {
        val EMPTY_DRAFT = ReceiptDraft(
            draft = TransactionDraft(
                type = null,
                amount = null,
                walletId = null,
                toWalletId = null,
                categoryId = null,
                date = null,
                note = null,
                merchant = null,
                confidence = DraftConfidence(
                    type = 0.0,
                    amount = 0.0,
                    wallet = 0.0,
                    category = 0.0,
                    date = 0.0,
                ),
            ),
            items = emptyList(),
        )
    }
}
