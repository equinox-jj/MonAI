package com.djtech.monai.feature.auth.presentation.signin

import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.autofill.ContentType
import androidx.compose.ui.focus.FocusDirection
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.input.ImeAction
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
import com.djtech.monai.feature.auth.presentation.common.AuthActions
import com.djtech.monai.feature.auth.presentation.common.AuthHeader
import com.djtech.monai.feature.auth.presentation.common.AuthLogoTile
import com.djtech.monai.feature.auth.presentation.common.AuthScaffold
import com.djtech.monai.feature.auth.presentation.common.isExpandedAuthWidth

@Composable
fun SignInRoute(
    onNavigateToRegister: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: SignInViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            SignInEffect.NavigateToRegister -> onNavigateToRegister()
        }
    }
    SignInScreen(state, viewModel::onIntent, modifier)
}

/** A successful sign-in needs no effect: the saved session switches the app to the main graph. */
@Composable
fun SignInScreen(
    state: SignInState,
    onIntent: (SignInIntent) -> Unit,
    modifier: Modifier = Modifier,
    expanded: Boolean = isExpandedAuthWidth(),
) {
    val focusManager = LocalFocusManager.current
    val submit = {
        focusManager.clearFocus()
        onIntent(SignInIntent.Submit)
    }
    AuthScaffold(
        expanded = expanded,
        modifier = modifier,
        form = {
            if (!expanded) AuthLogoTile()
            AuthHeader(
                stringResource(R.string.sign_in_title),
                stringResource(if (expanded) R.string.sign_in_subtitle_tablet else R.string.sign_in_subtitle),
            )
            state.formError?.let { error ->
                MonAIInlineAlert(
                    error.asString(),
                    Modifier.semantics { liveRegion = LiveRegionMode.Polite },
                    tone = MonAIAlertTone.Error,
                )
            }
            MonAITextField(
                value = state.email,
                onValueChange = { onIntent(SignInIntent.EmailChanged(it)) },
                label = stringResource(R.string.auth_email_label),
                placeholder = stringResource(R.string.auth_email_placeholder),
                leadingIcon = MonAIIcons.Mail,
                supportingText = state.emailError?.asString(),
                tone = state.emailError.tone(),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Email,
                    imeAction = ImeAction.Next
                ),
                keyboardActions = KeyboardActions(onNext = { focusManager.moveFocus(FocusDirection.Down) }),
                contentType = ContentType.EmailAddress,
            )
            MonAIPasswordField(
                value = state.password,
                onValueChange = { onIntent(SignInIntent.PasswordChanged(it)) },
                label = stringResource(R.string.auth_password_label),
                placeholder = stringResource(R.string.auth_password_placeholder),
                supportingText = state.passwordError?.asString(),
                tone = state.passwordError.tone(),
                showPasswordLabel = stringResource(R.string.auth_show_password),
                hidePasswordLabel = stringResource(R.string.auth_hide_password),
                keyboardOptions = KeyboardOptions(
                    keyboardType = KeyboardType.Password,
                    imeAction = ImeAction.Done
                ),
                keyboardActions = KeyboardActions(onDone = { submit() }),
                contentType = ContentType.Password,
            )
        },
        actions = {
            AuthActions(
                expanded = expanded,
                submitLabel = stringResource(R.string.sign_in_submit),
                onSubmit = submit,
                loading = state.isSubmitting,
                prompt = stringResource(R.string.sign_in_new_here),
                linkLabel = stringResource(R.string.sign_in_create_account),
                onLinkClick = { onIntent(SignInIntent.CreateAccount) },
            )
        },
    )
}

private fun UiText?.tone(): MonAIFieldTone =
    if (this == null) MonAIFieldTone.Neutral else MonAIFieldTone.Error

@PreviewLightDark
@Composable
private fun SignInScreenPreview() {
    MonAITheme {
        SignInScreen(
            SignInState(email = "joshua@example.com", password = "password1"),
            onIntent = {},
            expanded = false,
        )
    }
}

@Preview
@Composable
private fun SignInErrorPreview() {
    MonAITheme {
        SignInScreen(
            SignInState(
                email = "joshua@example.com",
                password = "password1",
                formError = UiText.Resource(R.string.auth_error_invalid_credentials),
            ),
            onIntent = {},
            expanded = false,
        )
    }
}

@Preview(widthDp = 1280, heightDp = 800)
@Composable
private fun SignInTabletPreview() {
    MonAITheme {
        SignInScreen(
            SignInState(email = "joshua@example.com", password = "password1"),
            onIntent = {},
            expanded = true,
        )
    }
}
