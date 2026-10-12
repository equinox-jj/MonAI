package com.djtech.monai.navigation

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertCountEquals
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotSelected
import androidx.compose.ui.test.assertIsSelected
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.isSelectable
import androidx.compose.ui.test.junit4.v2.createAndroidComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import com.djtech.monai.HiltTestActivity
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.designsystem.theme.MonAITheme
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
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

    private fun setContent(initial: SessionState) {
        sessionState = initial
        compose.setContent { MonAITheme { MonAIApp(sessionState) } }
    }

    private fun welcome() = compose.onNodeWithText(WELCOME_TITLE)

    private fun tab(label: String) = compose.onNode(hasText(label) and isSelectable())

    @Test
    fun loadingShowsNeitherGraph() {
        setContent(SessionState.Loading)

        welcome().assertDoesNotExist()
        tab("Home").assertDoesNotExist()
    }

    @Test
    fun signedOutShowsTheAuthGraph() {
        setContent(SessionState.SignedOut)

        welcome().assertIsDisplayed()
        tab("Home").assertDoesNotExist()
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
    fun sessionExpiryReturnsToTheAuthGraph() {
        setContent(SessionState.SignedIn)

        sessionState = SessionState.SignedOut

        welcome().assertIsDisplayed()
        tab("Home").assertDoesNotExist()
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
