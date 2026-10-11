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
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.datastore.SessionState
import com.djtech.monai.core.designsystem.theme.MonAITheme
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class MonAIAppTest {

    @get:Rule
    val compose = createComposeRule()

    private var sessionState by mutableStateOf<SessionState>(SessionState.Loading)

    private fun setContent(initial: SessionState) {
        sessionState = initial
        compose.setContent { MonAITheme { MonAIApp(sessionState) } }
    }

    private fun tab(label: String) = compose.onNode(hasText(label) and isSelectable())

    @Test
    fun loadingShowsNeitherGraph() {
        setContent(SessionState.Loading)

        compose.onNodeWithText("Welcome").assertDoesNotExist()
        tab("Home").assertDoesNotExist()
    }

    @Test
    fun signedOutShowsTheAuthGraph() {
        setContent(SessionState.SignedOut)

        compose.onNodeWithText("Welcome").assertIsDisplayed()
        tab("Home").assertDoesNotExist()
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

        compose.onNodeWithText("Welcome").assertIsDisplayed()
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
}
