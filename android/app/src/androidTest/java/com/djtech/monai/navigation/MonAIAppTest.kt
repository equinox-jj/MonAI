package com.djtech.monai.navigation

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertCountEquals
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotSelected
import androidx.compose.ui.test.assertIsSelected
import androidx.compose.ui.test.assertTextContains
import androidx.compose.ui.test.hasSetTextAction
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.isSelectable
import androidx.compose.ui.test.junit4.v2.createAndroidComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performTextInput
import com.djtech.monai.HiltTestActivity
import com.djtech.monai.MainState
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.designsystem.theme.MonAITheme
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test

// Screens get their ViewModels from hiltViewModel(), so the app runs in a Hilt activity.
@HiltAndroidTest
class MonAIAppTest {

    @get:Rule(order = 0)
    val hilt = HiltAndroidRule(this)

    @get:Rule(order = 1)
    val compose = createAndroidComposeRule<HiltTestActivity>()

    private var sessionState by mutableStateOf<SessionState>(SessionState.Loading)
    private var onboardingCompleted by mutableStateOf(false)
    private var expiryAcknowledgements = 0

    private fun setContent(initial: SessionState, onboardingDone: Boolean = false) {
        sessionState = initial
        onboardingCompleted = onboardingDone
        compose.setContent {
            MonAITheme {
                MonAIApp(
                    MainState(sessionState, onboardingCompleted),
                    onSessionExpiredAcknowledged = { expiryAcknowledgements++ },
                )
            }
        }
    }

    private fun welcome() = compose.onNodeWithText(WELCOME_TITLE)

    private fun tab(label: String) = compose.onNode(hasText(label) and isSelectable())

    private fun textField(index: Int) = compose.onAllNodes(hasSetTextAction())[index]

    @Test
    fun loadingShowsNeitherGraph() {
        setContent(SessionState.Loading)

        welcome().assertDoesNotExist()
        tab("Home").assertDoesNotExist()
    }

    @Test
    fun theFirstLaunchShowsOnboarding() {
        setContent(SessionState.SignedOut)

        welcome().assertIsDisplayed()
        tab("Home").assertDoesNotExist()
    }

    @Test
    fun afterOnboardingTheAuthGraphOpensOnSignIn() {
        setContent(SessionState.SignedOut, onboardingDone = true)

        compose.onNodeWithText("Welcome back").assertIsDisplayed()
        welcome().assertDoesNotExist()
    }

    @Test
    fun finishingOnboardingKeepsTheScreenItOpened() {
        setContent(SessionState.SignedOut)
        compose.onNodeWithText("Skip").performClick()

        // OnboardingViewModel saves the flag, which reaches the app root while Register is showing.
        onboardingCompleted = true

        compose.onNodeWithText("Create your account").assertIsDisplayed()
    }

    @Test
    fun skipOpensRegister() {
        setContent(SessionState.SignedOut)

        compose.onNodeWithText("Skip").performClick()

        compose.onNodeWithText("Create account").assertIsDisplayed()
        welcome().assertDoesNotExist()
    }

    @Test
    fun alreadyHavingAnAccountOpensSignIn() {
        setContent(SessionState.SignedOut)
        // The account actions are on the last page: the first page's Next link, then the middle page's button.
        compose.onNodeWithText("Next").performClick()
        compose.onNodeWithText("Next").performClick()

        compose.onNodeWithText("I already have an account").performClick()

        compose.onNodeWithText("Sign in").assertIsDisplayed()
        welcome().assertDoesNotExist()
    }

    @Test
    fun signInAndRegisterReplaceOnboardingWithNoWayBack() {
        setContent(SessionState.SignedOut)
        compose.onNodeWithText("Skip").performClick()

        compose.onNodeWithText("Sign in").performClick()
        compose.onNodeWithText("Welcome back").assertIsDisplayed()
        compose.onNodeWithText("Create an account").performClick()
        compose.onNodeWithText("Create your account").assertIsDisplayed()

        compose.onNodeWithContentDescription("Back").assertDoesNotExist()
        welcome().assertDoesNotExist()
    }

    @Test
    fun switchingBetweenSignInAndRegisterKeepsTheTypedEmail() {
        setContent(SessionState.SignedOut, onboardingDone = true)
        textField(0).performTextInput("joshua@example.com")

        compose.onNodeWithText("Create an account").performClick()
        compose.onNodeWithText("Create your account").assertIsDisplayed()
        // Register's fields in layout order: name, email, password.
        textField(1).assertTextContains("joshua@example.com")

        compose.onNodeWithText("Sign in").performClick()
        compose.onNodeWithText("Welcome back").assertIsDisplayed()
        textField(0).assertTextContains("joshua@example.com")
    }

    @Test
    fun signedInStartsOnHome() {
        setContent(SessionState.SignedIn)

        tab("Home").assertIsSelected()
        tab("Wallets").assertIsNotSelected()
    }

    @Test
    fun selectingATabShowsIt() {
        setContent(SessionState.SignedIn)

        tab("Wallets").performClick()

        tab("Wallets").assertIsSelected()
        tab("Home").assertIsNotSelected()
        // The bar label plus the screen's own title.
        compose.onAllNodesWithText("Wallets").assertCountEquals(2)
    }

    @Test
    fun signingOutReturnsToSignIn() {
        setContent(SessionState.SignedIn, onboardingDone = true)

        sessionState = SessionState.SignedOut

        compose.onNodeWithText("Welcome back").assertIsDisplayed()
        welcome().assertDoesNotExist()
        tab("Home").assertDoesNotExist()
    }

    @Test
    fun anExpiredSessionShowsTheDialogOverTheMainGraph() {
        setContent(SessionState.SignedIn, onboardingDone = true)

        sessionState = SessionState.Expired

        compose.onNodeWithText("Session expired").assertIsDisplayed()
        tab("Home").assertExists()
        welcome().assertDoesNotExist()
    }

    @Test
    fun signingInAgainAfterExpiryOpensSignIn() {
        setContent(SessionState.SignedIn, onboardingDone = true)
        sessionState = SessionState.Expired

        compose.onNodeWithText("Sign in again").performClick()
        assertEquals(1, expiryAcknowledgements)
        // MainViewModel acknowledges, which moves the session on to SignedOut.
        sessionState = SessionState.SignedOut

        compose.onNodeWithText("Welcome back").assertIsDisplayed()
        compose.onNodeWithText("Session expired").assertDoesNotExist()
        welcome().assertDoesNotExist()
    }

    @Test
    fun signingInAgainStartsFreshOnHome() {
        setContent(SessionState.SignedIn)
        tab("Settings").performClick()

        sessionState = SessionState.SignedOut
        compose.waitForIdle()
        sessionState = SessionState.SignedIn

        tab("Home").assertIsSelected()
    }

    private companion object {
        const val WELCOME_TITLE = "Every rupiah, every wallet, in seconds."
    }
}
