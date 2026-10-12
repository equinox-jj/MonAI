package com.djtech.monai.feature.auth.presentation.signin

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.hasSetTextAction
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performImeAction
import androidx.compose.ui.test.performTextInput
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class SignInScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private var state by mutableStateOf(SignInState())
    private val intents = mutableListOf<SignInIntent>()

    private fun setContent(initial: SignInState = SignInState(), expanded: Boolean = false) {
        state = initial
        compose.setContent {
            MonAITheme { SignInScreen(state, onIntent = ::record, expanded = expanded) }
        }
    }

    // Feeds typing back into the state like the ViewModel would; a field that stays empty would reset itself.
    private fun record(intent: SignInIntent) {
        intents += intent
        state = when (intent) {
            is SignInIntent.EmailChanged -> state.copy(email = intent.value)
            is SignInIntent.PasswordChanged -> state.copy(password = intent.value)
            else -> state
        }
    }

    // In layout order: email, then password.
    private fun field(index: Int) = compose.onAllNodes(hasSetTextAction())[index]

    @Test
    fun showsTheTitleAndFields() {
        setContent()

        compose.onNodeWithText("Welcome back").assertIsDisplayed()
        compose.onNodeWithText("Email").assertIsDisplayed()
        compose.onNodeWithText("Password").assertIsDisplayed()
    }

    @Test
    fun typingSendsFieldIntents() {
        setContent()

        field(0).performTextInput("a@b.co")
        field(1).performTextInput("secret")

        assertEquals(listOf(SignInIntent.EmailChanged("a@b.co"), SignInIntent.PasswordChanged("secret")), intents)
    }

    @Test
    fun showsTheFormErrorAndFieldErrors() {
        setContent(
            SignInState(
                formError = UiText.Resource(R.string.auth_error_invalid_credentials),
                emailError = UiText.Resource(R.string.auth_field_email_invalid),
            ),
        )

        compose.onNodeWithText("Email or password is incorrect. Check them and try again.").assertIsDisplayed()
        compose.onNodeWithText("Enter a valid email address").assertIsDisplayed()
    }

    @Test
    fun theButtonSubmits() {
        setContent()

        compose.onNodeWithText("Sign in").performClick()

        assertEquals(listOf<SignInIntent>(SignInIntent.Submit), intents)
    }

    @Test
    fun imeDoneOnThePasswordSubmits() {
        setContent()

        field(1).performImeAction()

        assertEquals(listOf<SignInIntent>(SignInIntent.Submit), intents)
    }

    @Test
    fun createAccountSendsItsIntent() {
        setContent()

        compose.onNodeWithText("Create an account").performClick()

        assertEquals(listOf<SignInIntent>(SignInIntent.CreateAccount), intents)
    }

    @Test
    fun tabletUsesTheTwoPaneLayout() {
        setContent(expanded = true)

        compose.onNodeWithText("Sign in to see your wallets on this tablet.").assertIsDisplayed()
        // The hero is decorative, so it is hidden from accessibility.
        compose.onNodeWithText("Expense Tracker").assertDoesNotExist()
    }
}
