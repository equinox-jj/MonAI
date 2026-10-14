package com.djtech.monai.feature.auth.presentation.changepassword

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIInlineAlert
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.auth.presentation.changepassword.components.ChangePasswordFields
import com.djtech.monai.feature.auth.presentation.changepassword.preview.ChangePasswordPreviewData
import com.djtech.monai.feature.auth.presentation.common.AuthFieldFocus
import com.djtech.monai.feature.auth.presentation.common.AuthFormError
import com.djtech.monai.feature.auth.presentation.common.rememberAuthFieldFocus

/** @param onClose back was pressed. */
@Composable
fun ChangePasswordRoute(
    onClose: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: ChangePasswordViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val fieldFocus = rememberAuthFieldFocus()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            ChangePasswordEffect.Close -> onClose()
            is ChangePasswordEffect.FocusField -> fieldFocus.request(effect.field)
        }
    }
    ChangePasswordScreen(state, viewModel::onIntent, modifier, fieldFocus = fieldFocus)
}

/** The current and new password, with a note that every device gets signed out. Save sits in the top bar. */
@Composable
fun ChangePasswordScreen(
    state: ChangePasswordState,
    onIntent: (ChangePasswordIntent) -> Unit,
    modifier: Modifier = Modifier,
    fieldFocus: AuthFieldFocus = rememberAuthFieldFocus(),
) {
    val spacing = MonAITheme.spacing
    val focusManager = LocalFocusManager.current
    val save = {
        focusManager.clearFocus()
        onIntent(ChangePasswordIntent.Save)
    }
    Column(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.surface)
            .imePadding(),
    ) {
        MonAITopBar(
            title = stringResource(R.string.change_password_title),
            navigation = MonAITopBarNavigation.Back,
            onNavigationClick = { onIntent(ChangePasswordIntent.Back) },
            navigationContentDescription = stringResource(R.string.change_password_back),
            actions = {
                MonAIButton(
                    stringResource(R.string.change_password_save),
                    onClick = save,
                    size = MonAIButtonSize.Small,
                    enabled = state.canSave,
                    loading = state.isSaving,
                )
            },
        )
        Column(
            Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .navigationBarsPadding()
                .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2)
                .widthIn(max = 640.dp),
            verticalArrangement = Arrangement.spacedBy(spacing.sectionGap),
        ) {
            AuthFormError(state.formError)
            ChangePasswordFields(state, onIntent, fieldFocus, onSubmit = { if (state.canSave) save() })
            MonAIInlineAlert(stringResource(R.string.change_password_sign_out_note))
        }
    }
}

@PreviewLightDark
@Composable
private fun ChangePasswordScreenPreview() {
    MonAITheme {
        ChangePasswordScreen(ChangePasswordPreviewData.filled, onIntent = {})
    }
}

@PreviewLightDark
@Composable
private fun ChangePasswordScreenErrorPreview() {
    MonAITheme {
        ChangePasswordScreen(ChangePasswordPreviewData.wrongCurrent, onIntent = {})
    }
}
