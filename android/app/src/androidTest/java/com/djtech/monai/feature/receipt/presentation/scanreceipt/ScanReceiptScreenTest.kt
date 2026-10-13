package com.djtech.monai.feature.receipt.presentation.scanreceipt

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.CameraPermission
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ProcessingStep
import com.djtech.monai.feature.receipt.presentation.scanreceipt.model.ScanPhase
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class ScanReceiptScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val intents = mutableListOf<ScanReceiptIntent>()
    private var allowCameraClicks = 0

    private fun setContent(state: ScanReceiptState) {
        compose.setContent {
            MonAITheme(darkTheme = false) {
                ScanReceiptScreen(state, onIntent = { intents += it }, onAllowCamera = { allowCameraClicks++ })
            }
        }
    }

    @Test
    fun theCameraControlsSendTheirIntents() {
        setContent(ScanReceiptState(permission = CameraPermission.GRANTED))

        compose.onNodeWithText("Fit the whole receipt inside the frame").assertIsDisplayed()
        compose.onNodeWithContentDescription("Flash off").performClick()
        compose.onNodeWithContentDescription("Take photo").performClick()
        compose.onNodeWithContentDescription("Choose from gallery").performClick()
        compose.onNodeWithText("Type instead").performClick()

        assertEquals(
            listOf(
                ScanReceiptIntent.ToggleFlash,
                ScanReceiptIntent.Capture,
                ScanReceiptIntent.OpenGallery,
                ScanReceiptIntent.TypeInstead,
            ),
            intents,
        )
    }

    @Test
    fun aDeniedCameraAsksAgainAndStillOffersTheGallery() {
        setContent(ScanReceiptState(permission = CameraPermission.DENIED))

        compose.onNodeWithText("Camera access is off").assertIsDisplayed()
        compose.onNodeWithText("Allow camera").performClick()
        compose.onNodeWithContentDescription("Choose from gallery").performClick()

        assertEquals(1, allowCameraClicks)
        assertEquals(listOf<ScanReceiptIntent>(ScanReceiptIntent.OpenGallery), intents)
    }

    @Test
    fun readingShowsItsStepsAndCanBeCancelled() {
        setContent(ScanReceiptState(phase = ScanPhase.Processing("", ProcessingStep.FINDING_DETAILS)))

        compose.onNodeWithText("Reading receipt…").assertIsDisplayed()
        compose.onNodeWithText("Finding total, store and date").assertIsDisplayed()
        compose.onNodeWithText("Cancel").performClick()

        assertEquals(listOf<ScanReceiptIntent>(ScanReceiptIntent.Retake), intents)
    }

    @Test
    fun aPhotoWithoutTextOffersRetakeOrManualEntry() {
        setContent(ScanReceiptState(phase = ScanPhase.NoText, permission = CameraPermission.GRANTED))

        compose.onNodeWithText("We couldn't read this receipt").assertIsDisplayed()
        compose.onNodeWithText("Enter manually").performClick()
        compose.onNodeWithText("Retake photo").performClick()

        assertEquals(listOf(ScanReceiptIntent.TypeInstead, ScanReceiptIntent.Retake), intents)
    }
}
