package com.djtech.monai.feature.auth.presentation.onboarding

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.onRoot
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTouchInput
import androidx.compose.ui.test.swipeLeft
import androidx.test.espresso.Espresso
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.theme.MonAITheme
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class OnboardingScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private var state by mutableStateOf(OnboardingState())
    private val intents = mutableListOf<OnboardingIntent>()

    private fun setContent(page: Int = 0) {
        state = OnboardingState(page)
        compose.setContent {
            MonAITheme { OnboardingScreen(state, onIntent = { intents += it }) }
        }
    }

    @Test
    fun firstPageShowsTheCaptureStepWithNextAndSkip() {
        setContent(page = 0)

        compose.onNodeWithText("Every rupiah, every wallet, in seconds.").assertIsDisplayed()
        compose.onNodeWithContentDescription("Step 1 of 3").assertIsDisplayed()
        compose.onNodeWithText("Next").assertIsDisplayed()
        compose.onNodeWithText("Skip").assertIsDisplayed()
        compose.onNodeWithText("Create free account").assertDoesNotExist()
        compose.onNodeWithText("I already have an account").assertDoesNotExist()
    }

    @Test
    fun illustrationsAreHiddenFromAccessibility() {
        setContent(page = 0)

        compose.onNodeWithText("makan siang 35rb pakai gopay").assertDoesNotExist()
    }

    @Test
    fun actionsOnTheFirstPageSendTheirIntents() {
        setContent(page = 0)

        compose.onNodeWithText("Next").performClick()
        compose.onNodeWithText("Skip").performClick()

        assertEquals(
            listOf(OnboardingIntent.Next, OnboardingIntent.Skip),
            intents.filterNot { it is OnboardingIntent.PageSettled },
        )
    }

    @Test
    fun middlePageStepsBackAndForthAndCanSkip() {
        setContent(page = 1)

        compose.onNodeWithText("All your wallets, one total.").assertIsDisplayed()
        compose.onNodeWithContentDescription("Step 2 of 3").assertIsDisplayed()
        compose.onNodeWithText("Create free account").assertDoesNotExist()

        compose.onNodeWithText("Back").performClick()
        compose.onNodeWithText("Next").performClick()
        compose.onNodeWithText("Skip").performClick()

        assertEquals(
            listOf(OnboardingIntent.Back, OnboardingIntent.Next, OnboardingIntent.Skip),
            intents.filterNot { it is OnboardingIntent.PageSettled },
        )
    }

    @Test
    fun lastPageOffersTheAccountActions() {
        setContent(page = 2)

        compose.onNodeWithText("See where it went. Stay on budget.").assertIsDisplayed()
        compose.onNodeWithText("Create free account").assertIsDisplayed()
        compose.onNodeWithText("I already have an account").assertIsDisplayed()
        compose.onNodeWithText("Next").assertDoesNotExist()
        compose.onNodeWithText("Skip").assertDoesNotExist()
    }

    @Test
    fun accountActionsOnTheLastPageSendTheirIntents() {
        setContent(page = 2)

        compose.onNodeWithText("Create free account").performClick()
        compose.onNodeWithText("I already have an account").performClick()

        assertEquals(
            listOf(OnboardingIntent.CreateAccount, OnboardingIntent.SignIn),
            intents.filterNot { it is OnboardingIntent.PageSettled },
        )
    }

    @Test
    fun theScreenFollowsAPageChange() {
        setContent(page = 0)

        state = OnboardingState(page = 1)

        compose.onNodeWithText("All your wallets, one total.").assertIsDisplayed()
    }

    @Test
    fun aSwipeReportsTheSettledPage() {
        setContent(page = 0)

        compose.onRoot().performTouchInput { swipeLeft() }
        compose.waitForIdle()

        assertTrue(OnboardingIntent.PageSettled(1) in intents)
    }

    @Test
    fun systemBackStepsBackAfterTheFirstPage() {
        setContent(page = 1)

        Espresso.pressBack()

        assertTrue(OnboardingIntent.Back in intents)
    }
}
