package com.djtech.monai.feature.settings.presentation.providerform

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.settings.presentation.providerform.components.ProviderFormActive
import com.djtech.monai.feature.settings.presentation.providerform.components.ProviderFormAliases
import com.djtech.monai.feature.settings.presentation.providerform.components.ProviderFormDialogs
import com.djtech.monai.feature.settings.presentation.providerform.components.ProviderFormLogo
import com.djtech.monai.feature.settings.presentation.providerform.components.ProviderFormName
import com.djtech.monai.feature.settings.presentation.providerform.components.ProviderFormSortOrder
import com.djtech.monai.feature.settings.presentation.providerform.components.ProviderFormType
import com.djtech.monai.feature.settings.presentation.providerform.preview.ProviderFormPreviewData
import kotlinx.coroutines.launch
import java.time.format.DateTimeFormatter

/**
 * @param providerId the provider to edit; null adds one.
 * @param onClose saved, deleted or closed.
 * @param isSideSheet shown as a side sheet over the screen behind it: no status-bar inset.
 */
@Composable
fun ProviderFormRoute(
    providerId: String?,
    onClose: () -> Unit,
    modifier: Modifier = Modifier,
    isSideSheet: Boolean = false,
    viewModel: ProviderFormViewModel =
        hiltViewModel<ProviderFormViewModel, ProviderFormViewModel.Factory>(key = providerId ?: "new") {
            it.create(providerId)
        },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    val logoPicker = rememberLauncherForActivityResult(ActivityResultContracts.PickVisualMedia()) { uri: Uri? ->
        viewModel.onIntent(ProviderFormIntent.LogoPicked(uri?.toString()))
    }
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            ProviderFormEffect.Close -> onClose()
            ProviderFormEffect.LaunchLogoPicker -> logoPicker.launch(
                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly),
            )

            is ProviderFormEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    ProviderFormScreen(
        state,
        viewModel::onIntent,
        modifier,
        isSideSheet = isSideSheet,
        snackbarHostState = snackbarHostState,
    )
}

/** Logo, name, type, aliases, sort order and status; Delete and when it was last edited at the end. */
@Composable
fun ProviderFormScreen(
    state: ProviderFormState,
    onIntent: (ProviderFormIntent) -> Unit,
    modifier: Modifier = Modifier,
    isSideSheet: Boolean = false,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
    val editable = state.canSave && !state.isWorking
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.surface),
    ) {
        Column(
            Modifier
                .fillMaxSize()
                .imePadding(),
        ) {
            MonAITopBar(
                title = stringResource(
                    if (state.isEditing) R.string.provider_form_edit_title else R.string.provider_form_new_title,
                ),
                navigation = MonAITopBarNavigation.Close,
                onNavigationClick = { onIntent(ProviderFormIntent.Close) },
                navigationContentDescription = stringResource(R.string.provider_form_close),
                windowInsets = if (isSideSheet) WindowInsets(0) else WindowInsets.statusBars,
                actions = {
                    if (state.isEditing) {
                        MonAIButton(
                            stringResource(R.string.provider_form_save),
                            onClick = { onIntent(ProviderFormIntent.Save) },
                            size = MonAIButtonSize.Small,
                            enabled = state.isReady,
                            loading = state.isSaving,
                        )
                    }
                },
            )
            when {
                state.isLoading -> FormSkeleton()
                state.loadError != null -> MonAIStateMessage(
                    icon = MonAIIcons.CloudOff,
                    title = stringResource(R.string.providers_load_error_title),
                    message = state.loadError.asString(),
                    modifier = Modifier.padding(spacing.screenHorizontal),
                    tone = MonAIAlertTone.Error,
                    actionLabel = stringResource(R.string.providers_retry),
                    actionIcon = MonAIIcons.Refresh,
                    onAction = { onIntent(ProviderFormIntent.Retry) },
                )

                else -> Column(
                    Modifier
                        .weight(1f)
                        .verticalScroll(rememberScrollState())
                        .navigationBarsPadding()
                        .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
                    verticalArrangement = Arrangement.spacedBy(spacing.sectionGap),
                ) {
                    FormFields(state, onIntent, editable)
                    if (!state.isEditing) {
                        CreateButton(state, onIntent)
                    } else {
                        EditFooter(state, onIntent)
                    }
                }
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    ProviderFormDialogs(
        state.dialog,
        state.name,
        onConfirm = { onIntent(ProviderFormIntent.ConfirmDialog) },
        onDismiss = { onIntent(ProviderFormIntent.DismissDialog) },
    )
}

@Composable
private fun FormFields(
    state: ProviderFormState,
    onIntent: (ProviderFormIntent) -> Unit,
    editable: Boolean,
) {
    ProviderFormLogo(
        state.monogram,
        state.logoUrl,
        state.newLogoUri,
        enabled = editable,
        onPick = { onIntent(ProviderFormIntent.PickLogo) },
    )
    ProviderFormName(
        state.name,
        state.slug,
        state.nameError?.asString(),
        enabled = editable,
        onNameChange = { onIntent(ProviderFormIntent.NameChanged(it)) },
    )
    ProviderFormType(state.type, enabled = editable, onPick = { onIntent(ProviderFormIntent.PickType(it)) })
    ProviderFormAliases(
        aliases = state.aliases,
        input = state.aliasInput,
        error = state.aliasError?.asString(),
        enabled = editable,
        onInputChange = { onIntent(ProviderFormIntent.AliasInputChanged(it)) },
        onAdd = { onIntent(ProviderFormIntent.AddAlias) },
        onRemove = { onIntent(ProviderFormIntent.RemoveAlias(it)) },
    )
    ProviderFormSortOrder(
        state.sortOrder,
        enabled = editable,
        onChange = { onIntent(ProviderFormIntent.SortOrderChanged(it)) },
    )
    ProviderFormActive(
        isActive = state.isActive,
        isEditing = state.isEditing,
        isSystem = state.isSystem,
        enabled = editable,
        onChange = { onIntent(ProviderFormIntent.SetActive(it)) },
    )
}

@Composable
private fun CreateButton(state: ProviderFormState, onIntent: (ProviderFormIntent) -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        MonAIButton(
            stringResource(R.string.provider_form_create),
            onClick = { onIntent(ProviderFormIntent.Save) },
            modifier = Modifier.fillMaxWidth(),
            enabled = state.isReady,
            loading = state.isSaving,
        )
        Text(
            stringResource(if (state.isReady) R.string.provider_form_hint_ready else R.string.provider_form_hint),
            Modifier.fillMaxWidth(),
            style = MonAITheme.typography.bodySmall,
            color = MonAITheme.colors.textTertiary,
            textAlign = TextAlign.Center,
        )
    }
}

@Composable
private fun EditFooter(state: ProviderFormState, onIntent: (ProviderFormIntent) -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        if (state.canDelete) {
            MonAIButton(
                stringResource(R.string.provider_form_delete, state.name),
                onClick = { onIntent(ProviderFormIntent.Delete) },
                modifier = Modifier.fillMaxWidth(),
                variant = MonAIButtonVariant.Text,
                leadingIcon = MonAIIcons.Delete,
                enabled = !state.isWorking,
                loading = state.isDeleting,
            )
        }
        state.lastEdited?.let { date ->
            val locale = LocalConfiguration.current.locales[0]
            Text(
                stringResource(
                    R.string.provider_form_last_edited,
                    date.format(DateTimeFormatter.ofPattern("d MMM yyyy", locale)),
                ),
                Modifier.fillMaxWidth(),
                style = MonAITheme.typography.bodySmall,
                color = MonAITheme.colors.textTertiary,
                textAlign = TextAlign.Center,
            )
        }
    }
}

@Composable
private fun FormSkeleton() {
    val spacing = MonAITheme.spacing
    Column(
        Modifier.padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
        verticalArrangement = Arrangement.spacedBy(spacing.sectionGap),
    ) {
        repeat(SKELETON_FIELDS) {
            MonAISkeleton(height = MonAITheme.sizes.input, modifier = Modifier.fillMaxWidth())
        }
    }
}

@PreviewLightDark
@Composable
private fun ProviderFormNewPreview() {
    MonAITheme {
        ProviderFormScreen(ProviderFormPreviewData.new, onIntent = {})
    }
}

@PreviewLightDark
@Composable
private fun ProviderFormEditPreview() {
    MonAITheme {
        ProviderFormScreen(ProviderFormPreviewData.edit, onIntent = {})
    }
}

private const val SKELETON_FIELDS = 5
