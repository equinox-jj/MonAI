package com.djtech.monai.feature.auth.presentation.register

import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.autofill.ContentType
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIFieldTone
import com.djtech.monai.core.designsystem.component.MonAIInlineAlert
import com.djtech.monai.core.designsystem.component.MonAIPasswordField
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.auth.domain.model.AuthField
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator
import com.djtech.monai.feature.auth.presentation.common.AuthActions
import com.djtech.monai.feature.auth.presentation.common.AuthFieldFocus
import com.djtech.monai.feature.auth.presentation.common.AuthFormError
import com.djtech.monai.feature.auth.presentation.common.AuthHeader
import com.djtech.monai.feature.auth.presentation.common.AuthScaffold
import com.djtech.monai.feature.auth.presentation.common.fieldTone
import com.djtech.monai.feature.auth.presentation.common.isExpandedAuthWidth
import com.djtech.monai.feature.auth.presentation.common.rememberAuthFieldFocus

/** @param initialEmail the email typed on Sign in, if the user came from there. */
@Composable
fun RegisterRoute(
    initialEmail: String,
    onNavigateToSignIn: (email: String) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: RegisterViewModel = hiltViewModel<RegisterViewModel, RegisterViewModel.Factory>(
        creationCallback = { it.create(initialEmail) },
    ),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val fieldFocus = rememberAuthFieldFocus()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is RegisterEffect.NavigateToSignIn -> onNavigateToSignIn(effect.email)
            is RegisterEffect.FocusField -> fieldFocus.request(effect.field)
        }
    }
    RegisterScreen(state, viewModel::onIntent, modifier, fieldFocus = fieldFocus)
}

/** A successful register needs no effect: the saved session switches the app to the main graph. */
@Composable
fun RegisterScreen(
    state: RegisterState,
    onIntent: (RegisterIntent) -> Unit,
    modifier: Modifier = Modifier,
    expanded: Boolean = isExpandedAuthWidth(),
    fieldFocus: AuthFieldFocus = rememberAuthFieldFocus(),
) {
    val focusManager = LocalFocusManager.current
    val submit = {
        focusManager.clearFocus()
        onIntent(RegisterIntent.Submit)
    }
    val next = KeyboardActions(onNext = { focusManager.moveFocus(FocusDirection.Down) })
    AuthScaffold(
        expanded = expanded,
        modifier = modifier,
        form = {
            AuthHeader(stringResource(R.string.register_title), stringResource(R.string.register_subtitle))
            AuthFormError(state.formError)
            MonAITextField(
                value = state.name,
                onValueChange = { onIntent(RegisterIntent.NameChanged(it)) },
                modifier = Modifier.focusRequester(fieldFocus.requester(AuthField.NAME)),
                enabled = !state.isSubmitting,
                label = stringResource(R.string.auth_name_label),
                placeholder = stringResource(R.string.auth_name_placeholder),
                leadingIcon = MonAIIcons.Person,
                supportingText = state.nameError?.asString(),
                tone = state.nameError.fieldTone(),
                keyboardOptions = KeyboardOptions(
                    capitalization = KeyboardCapitalization.Words,
                    imeAction = ImeAction.Next,
                ),
                keyboardActions = next,
                contentType = ContentType.PersonFullName,
            )
            MonAITextField(
                value = state.email,
                onValueChange = { onIntent(RegisterIntent.EmailChanged(it)) },
                modifier = Modifier.focusRequester(fieldFocus.requester(AuthField.EMAIL)),
                enabled = !state.isSubmitting,
                label = stringResource(R.string.auth_email_label),
                placeholder = stringResource(R.string.auth_email_placeholder),
                leadingIcon = MonAIIcons.Mail,
                supportingText = state.emailError?.asString(),
                supportingLinkLabel = if (state.emailTaken) stringResource(R.string.register_sign_in_instead) else null,
                onSupportingLinkClick = { onIntent(RegisterIntent.SignIn) },
                tone = state.emailError.fieldTone(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email, imeAction = ImeAction.Next),
                keyboardActions = next,
                contentType = ContentType.EmailAddress,
            )
            // An error replaces the length hint; otherwise the hint turns green once it is met.
            val passwordError = state.passwordError
            MonAIPasswordField(
                value = state.password,
                onValueChange = { onIntent(RegisterIntent.PasswordChanged(it)) },
                modifier = Modifier.focusRequester(fieldFocus.requester(AuthField.PASSWORD)),
                enabled = !state.isSubmitting,
                label = stringResource(R.string.auth_password_label),
                placeholder = stringResource(R.string.register_password_placeholder),
                supportingText = passwordError?.asString()
                    ?: stringResource(R.string.register_password_hint, AuthInputValidator.PASSWORD_MIN),
                tone = when {
                    passwordError != null -> MonAIFieldTone.Error
                    state.passwordLongEnough -> MonAIFieldTone.Success
                    else -> MonAIFieldTone.Neutral
                },
                showPasswordLabel = stringResource(R.string.auth_show_password),
                hidePasswordLabel = stringResource(R.string.auth_hide_password),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password, imeAction = ImeAction.Done),
                keyboardActions = KeyboardActions(onDone = { submit() }),
                contentType = ContentType.NewPassword,
            )
            MonAIInlineAlert(
                stringResource(R.string.register_setup_note),
                tone = MonAIAlertTone.Info,
                icon = MonAIIcons.AutoAwesome,
            )
        },
        actions = {
            AuthActions(
                expanded = expanded,
                submitLabel = stringResource(R.string.register_submit),
                onSubmit = submit,
                loading = state.isSubmitting,
                prompt = stringResource(R.string.register_have_account),
                linkLabel = stringResource(R.string.register_sign_in),
                onLinkClick = { onIntent(RegisterIntent.SignIn) },
            )
        },
    )
}

@PreviewLightDark
@Composable
private fun RegisterScreenPreview() {
    MonAITheme {
        RegisterScreen(
            RegisterState(name = "Joshua Pardede", email = "joshua@example.com", password = "secretpass"),
            onIntent = {},
            expanded = false,
        )
    }
}

@Preview
@Composable
private fun RegisterEmailTakenPreview() {
    MonAITheme {
        RegisterScreen(
            RegisterState(
                name = "Joshua Pardede",
                email = "joshua@example.com",
                password = "secretpass",
                emailError = UiText.Resource(R.string.register_email_taken),
                emailTaken = true,
            ),
            onIntent = {},
            expanded = false,
        )
    }
}

@Preview(widthDp = 1280, heightDp = 800)
@Composable
private fun RegisterTabletPreview() {
    MonAITheme { RegisterScreen(RegisterState(), onIntent = {}, expanded = true) }
}
