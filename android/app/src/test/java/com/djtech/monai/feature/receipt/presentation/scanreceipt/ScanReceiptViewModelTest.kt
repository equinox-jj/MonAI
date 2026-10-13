package com.djtech.monai.feature.receipt.presentation.scanreceipt

import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.model.receiptDraft
import com.djtech.monai.feature.receipt.domain.model.ReceiptError
import com.djtech.monai.feature.receipt.domain.ocr.FakeReceiptTextReader
import com.djtech.monai.feature.receipt.domain.repository.FakeReceiptRepository
import com.djtech.monai.feature.receipt.domain.usecase.ParseReceiptUseCase
import com.djtech.monai.feature.receipt.domain.usecase.ReadReceiptTextUseCase
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.CameraPermission
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ProcessingStep
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ScanPhase
import com.djtech.monai.feature.transactions.domain.usecase.testClock
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class ScanReceiptViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val reader = FakeReceiptTextReader()
    private val receipts = FakeReceiptRepository()

    private fun runScanTest(
        block: suspend TestScope.(ScanReceiptViewModel, MutableList<ScanReceiptEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = ScanReceiptViewModel(
            readReceiptText = ReadReceiptTextUseCase(reader),
            parseReceipt = ParseReceiptUseCase(receipts, testClock()),
            imageProcessor = FakeImageProcessor(),
        )
        val effects = mutableListOf<ScanReceiptEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: ScanReceiptViewModel, vararg intents: ScanReceiptIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `the shutter asks for a photo file once`() = runScanTest { vm, effects ->
        send(vm, ScanReceiptIntent.PermissionResult(true), ScanReceiptIntent.Capture, ScanReceiptIntent.Capture)

        assertEquals(CameraPermission.GRANTED, vm.state.value.permission)
        assertEquals(listOf<ScanReceiptEffect>(ScanReceiptEffect.TakePhoto("content://camera/1")), effects)
        assertTrue(vm.state.value.isCapturing)
    }

    @Test
    fun `a photo is read on the phone, then by the AI, then reviewed`() = runScanTest { vm, effects ->
        receipts.gate = CompletableDeferred()
        send(vm, ScanReceiptIntent.PhotoTaken("content://camera/1"))

        assertEquals(ScanPhase.Processing("content://camera/1", ProcessingStep.FINDING_DETAILS), vm.state.value.phase)
        assertEquals(listOf("TOKO SUMBER REJEKI\nTOTAL 187.500"), receipts.texts)

        receipts.gate?.complete(Unit)
        advanceUntilIdle()

        assertEquals(
            listOf<ScanReceiptEffect>(
                ScanReceiptEffect.OpenReview("content://camera/1", receiptDraft(), aiFailed = false),
            ),
            effects,
        )
        assertEquals(ScanPhase.Camera, vm.state.value.phase)
    }

    @Test
    fun `a photo without text asks to retake and never reaches the AI`() = runScanTest { vm, _ ->
        reader.text = null

        send(vm, ScanReceiptIntent.PhotoPicked("content://gallery/7"))

        assertEquals(ScanPhase.NoText, vm.state.value.phase)
        assertEquals(emptyList<String>(), receipts.texts)

        send(vm, ScanReceiptIntent.Retake)
        assertEquals(ScanPhase.Camera, vm.state.value.phase)
    }

    @Test
    fun `when the AI fails the review still opens, empty`() = runScanTest { vm, effects ->
        receipts.result = Outcome.Failure(ReceiptError.RateLimited)

        send(vm, ScanReceiptIntent.PhotoPicked("content://gallery/7"))

        val review = effects.single() as ScanReceiptEffect.OpenReview
        assertTrue(review.aiFailed)
        assertNull(review.draft.draft.amount)
    }

    @Test
    fun `nothing picked from the gallery does nothing`() = runScanTest { vm, effects ->
        send(vm, ScanReceiptIntent.PhotoPicked(null))

        assertEquals(ScanPhase.Camera, vm.state.value.phase)
        assertEquals(emptyList<ScanReceiptEffect>(), effects)
    }
}
