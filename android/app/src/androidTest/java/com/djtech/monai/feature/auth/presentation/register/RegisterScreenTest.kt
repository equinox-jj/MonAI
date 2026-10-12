package com.djtech.monai.feature.auth.presentation.register

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsFocused
import androidx.compose.ui.semantics.SemanticsProperties
import androidx.compose.ui.test.SemanticsMatcher
import androidx.compose.ui.test.assertAll
import androidx.compose.ui.test.assertCountEquals
import androidx.compose.ui.test.isNotEnabled
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
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.presentation.common.AuthFieldFocus
import com.djtech.monai.feature.auth.presentation.common.rememberAuthFieldFocus
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class RegisterScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private var state by mutableStateOf(RegisterState())
    private lateinit var fieldFocus: AuthFieldFocus
    private val intents = mutableListOf<RegisterIntent>()

    private fun setContent(initial: RegisterState = RegisterState()) {
        state = initial
        compose.setContent {
            fieldFocus = rememberAuthFieldFocus()
            MonAITheme { RegisterScreen(state, onIntent = ::record, expanded = false, fieldFocus = fieldFocus) }
        }
    }

    // Feeds typing back into the state like the ViewModel would; a field that stays empty would reset itself.
    private fun record(intent: RegisterIntent) {
        intents += intent
        state = when (intent) {
            is RegisterIntent.NameChanged -> state.copy(name = intent.value)
            is RegisterIntent.EmailChanged -> state.copy(email = intent.value)
            is RegisterIntent.PasswordChanged -> state.copy(password = intent.value)
            else -> state
        }
    }

    // In layout order: name, email, password.
    private fun field(index: Int) = compose.onAllNodes(hasSetTextAction())[index]

    @Test
    fun showsTheFormWithTheHintAndSetupNote() {
        setContent()

        compose.onNodeWithText("Create your account").assertIsDisplayed()
        compose.onNodeWithText("At least 8 characters").assertIsDisplayed()
        compose.onNodeWithText("We'll set up a Cash wallet", substring = true).assertIsDisplayed()
    }

    @Test
    fun typingSendsFieldIntents() {
        setContent()

        field(0).performTextInput("Joshua")
        field(1).performTextInput("a@b.co")
        field(2).performTextInput("secretpass")

        assertEquals(
            listOf(
                RegisterIntent.NameChanged("Joshua"),
                RegisterIntent.EmailChanged("a@b.co"),
                RegisterIntent.PasswordChanged("secretpass"),
            ),
            intents,
        )
    }

    @Test
    fun aPasswordErrorReplacesTheHint() {
        setContent(RegisterState(passwordError = UiText.Resource(R.string.auth_field_too_short, 8)))

        compose.onNodeWithText("Use at least 8 characters").assertIsDisplayed()
        compose.onNodeWithText("At least 8 characters").assertDoesNotExist()
    }

    @Test
    fun aRegisteredEmailOffersSignInInstead() {
        setContent(
            RegisterState(
                emailError = UiText.Resource(R.string.register_email_taken),
                emailTaken = true,
            ),
        )

        compose.onNodeWithText("This email already has an account.", substring = true).assertIsDisplayed()
        compose.onNodeWithText("Sign in instead", substring = true).assertIsDisplayed()
    }

    @Test
    fun submitButtonAndImeDoneSubmit() {
        setContent()

        compose.onNodeWithText("Create account").performClick()
        field(2).performImeAction()

        assertEquals(listOf<RegisterIntent>(RegisterIntent.Submit, RegisterIntent.Submit), intents)
    }

    @Test
    fun theSignInLinkSendsItsIntent() {
        setContent()

        compose.onNodeWithText("Sign in").performClick()

        assertEquals(listOf<RegisterIntent>(RegisterIntent.SignIn), intents)
    }

    @Test
    fun theFieldsAreLockedWhileSubmitting() {
        setContent(RegisterState(isSubmitting = true))

        // A disabled field drops its SetText action, so match the fields by their text instead.
        val fields = compose.onAllNodes(SemanticsMatcher.keyIsDefined(SemanticsProperties.EditableText))
        fields.assertCountEquals(3)
        fields.assertAll(isNotEnabled())
    }

    @Test
    fun aFocusRequestMovesFocusToThatField() {
        setContent()

        compose.runOnIdle { fieldFocus.request(AuthField.EMAIL) }

        field(1).assertIsFocused()
    }
}
