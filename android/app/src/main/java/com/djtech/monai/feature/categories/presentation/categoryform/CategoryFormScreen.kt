package com.djtech.monai.feature.categories.presentation.categoryform

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.presentation.categoryform.components.CategoryFormColors
import com.djtech.monai.feature.categories.presentation.categoryform.components.CategoryFormIcons
import com.djtech.monai.feature.categories.presentation.categoryform.components.CategoryFormName
import com.djtech.monai.feature.categories.presentation.categoryform.components.CategoryFormPreview
import com.djtech.monai.feature.categories.presentation.categoryform.preview.CategoryFormPreviewData
import kotlinx.coroutines.launch

/**
 * @param type the type the new category gets.
 * @param categoryId the category to edit; null creates one.
 * @param onClose the category was saved, or the form was closed.
 * @param isSideSheet shown as a side sheet over the screen behind it: no status-bar inset.
 */
@Composable
fun CategoryFormRoute(
    type: CategoryType,
    onClose: () -> Unit,
    modifier: Modifier = Modifier,
    categoryId: String? = null,
    isSideSheet: Boolean = false,
    viewModel: CategoryFormViewModel =
        hiltViewModel<CategoryFormViewModel, CategoryFormViewModel.Factory>(key = categoryId ?: type.name) {
            it.create(type, categoryId)
        },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            CategoryFormEffect.Close -> onClose()
            is CategoryFormEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    CategoryFormScreen(
        state,
        viewModel::onIntent,
        modifier,
        isSideSheet = isSideSheet,
        snackbarHostState = snackbarHostState,
    )
}

/** A new or edited category: a preview, then its name, icon and color. Save sits in the top bar. */
@Composable
fun CategoryFormScreen(
    state: CategoryFormState,
    onIntent: (CategoryFormIntent) -> Unit,
    modifier: Modifier = Modifier,
    isSideSheet: Boolean = false,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
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
                    if (state.isEditing) R.string.category_form_edit_title else R.string.category_form_new_title,
                ),
                navigation = MonAITopBarNavigation.Close,
                onNavigationClick = { onIntent(CategoryFormIntent.Close) },
                navigationContentDescription = stringResource(R.string.category_form_close),
                windowInsets = if (isSideSheet) WindowInsets(0) else WindowInsets.statusBars,
                actions = {
                    MonAIButton(
                        stringResource(R.string.category_form_save),
                        onClick = { onIntent(CategoryFormIntent.Save) },
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
                    .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
                verticalArrangement = Arrangement.spacedBy(spacing.x5),
            ) {
                CategoryFormPreview(state.name, state.icon, state.color)
                CategoryFormName(
                    state.name,
                    state.type,
                    state.maxNameLength,
                    state.nameError,
                    onNameChange = { onIntent(CategoryFormIntent.NameChanged(it)) },
                )
                CategoryFormIcons(
                    state.icon,
                    CategoryColors.parse(state.color.hex),
                    onPick = { onIntent(CategoryFormIntent.PickIcon(it)) },
                )
                CategoryFormColors(state.color, onPick = { onIntent(CategoryFormIntent.PickColor(it)) })
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
}

@PreviewLightDark
@Composable
private fun CategoryFormScreenPreview() {
    MonAITheme {
        CategoryFormScreen(CategoryFormPreviewData.state, onIntent = {})
    }
}
