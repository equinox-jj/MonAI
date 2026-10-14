package com.djtech.monai.feature.categories.presentation.categories

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.component.MonAISegment
import com.djtech.monai.core.designsystem.component.MonAISegmentedControl
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.presentation.categories.components.CategoriesDeleteSheet
import com.djtech.monai.feature.categories.presentation.categories.components.CategoriesRow
import com.djtech.monai.feature.categories.presentation.categories.preview.CategoriesPreviewData
import kotlinx.coroutines.launch

/** @param isPane shown beside the Settings menu: no back button, no status-bar inset. */
@Composable
fun CategoriesRoute(
    onNavigate: (CategoriesDestination) -> Unit,
    onBack: () -> Unit,
    modifier: Modifier = Modifier,
    isPane: Boolean = false,
    viewModel: CategoriesViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            CategoriesEffect.Close -> onBack()
            is CategoriesEffect.Navigate -> onNavigate(effect.destination)
            is CategoriesEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    CategoriesScreen(
        state,
        viewModel::onIntent,
        modifier,
        isPane = isPane,
        snackbarHostState = snackbarHostState,
    )
}

/** Expense and income categories, each with its action, and a note on what can't be removed. */
@Composable
fun CategoriesScreen(
    state: CategoriesState,
    onIntent: (CategoriesIntent) -> Unit,
    modifier: Modifier = Modifier,
    isPane: Boolean = false,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
    val types = remember { listOf(CategoryType.EXPENSE, CategoryType.INCOME) }
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        Column(Modifier.fillMaxSize()) {
            MonAITopBar(
                title = stringResource(R.string.categories_title),
                navigation = if (isPane) MonAITopBarNavigation.None else MonAITopBarNavigation.Back,
                onNavigationClick = { onIntent(CategoriesIntent.Back) },
                navigationContentDescription = stringResource(R.string.categories_back),
                windowInsets = if (isPane) WindowInsets(0) else WindowInsets.statusBars,
                actions = {
                    MonAIButton(
                        stringResource(R.string.categories_new),
                        onClick = { onIntent(CategoriesIntent.Add) },
                        variant = MonAIButtonVariant.Tonal,
                        size = MonAIButtonSize.Small,
                        leadingIcon = MonAIIcons.Add,
                    )
                },
            )
            MonAISegmentedControl(
                segments = listOf(
                    MonAISegment(stringResource(R.string.categories_expense)),
                    MonAISegment(stringResource(R.string.categories_income)),
                ),
                selectedIndex = types.indexOf(state.type),
                onSelect = { onIntent(CategoriesIntent.SelectType(types[it])) },
                modifier = Modifier.padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
            )
            when {
                state.isLoading -> CategoriesSkeleton()
                state.loadError != null -> MonAIStateMessage(
                    icon = MonAIIcons.CloudOff,
                    title = stringResource(R.string.categories_load_error_title),
                    message = state.loadError.asString(),
                    modifier = Modifier.padding(spacing.screenHorizontal),
                    tone = MonAIAlertTone.Error,
                    actionLabel = stringResource(R.string.categories_retry),
                    actionIcon = MonAIIcons.Refresh,
                    onAction = { onIntent(CategoriesIntent.Retry) },
                )

                else -> CategoriesList(state, onIntent)
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    state.deletion?.let { deletion ->
        CategoriesDeleteSheet(
            deletion,
            onPickTarget = { onIntent(CategoriesIntent.PickTarget(it)) },
            onConfirm = { onIntent(CategoriesIntent.ConfirmDelete) },
            onDismiss = { onIntent(CategoriesIntent.DismissDelete) },
        )
    }
}

@Composable
private fun CategoriesList(state: CategoriesState, onIntent: (CategoriesIntent) -> Unit) {
    val spacing = MonAITheme.spacing
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.lg)
    val lastIndex = state.rows.lastIndex
    LazyColumn(
        contentPadding = PaddingValues(
            start = spacing.screenHorizontal,
            end = spacing.screenHorizontal,
            top = spacing.x2,
            bottom = spacing.x6 + WindowInsets.navigationBars.asPaddingValues().calculateBottomPadding(),
        ),
    ) {
        if (state.rows.isEmpty()) {
            item(key = "empty") {
                Text(
                    stringResource(R.string.categories_empty),
                    Modifier.padding(vertical = spacing.x6),
                    style = MonAITheme.typography.bodyMedium,
                    color = colors.textTertiary,
                )
            }
        }
        // One card drawn row by row: the first and last round its corners.
        itemsIndexed(state.rows, key = { _, row -> row.id }) { index, row ->
            val itemShape = when {
                lastIndex == 0 -> shape
                index == 0 -> RoundedCornerShape(topStart = MonAITheme.radius.lg, topEnd = MonAITheme.radius.lg)
                index == lastIndex -> RoundedCornerShape(
                    bottomStart = MonAITheme.radius.lg,
                    bottomEnd = MonAITheme.radius.lg,
                )

                else -> RoundedCornerShape(0)
            }
            Column(
                Modifier
                    .clip(itemShape)
                    .background(colors.surface),
            ) {
                CategoriesRow(
                    row,
                    onEdit = { onIntent(CategoriesIntent.Edit(row.id)) },
                    onSetHidden = { onIntent(CategoriesIntent.SetHidden(row.id, it)) },
                    onDelete = { onIntent(CategoriesIntent.Delete(row.id)) },
                )
                if (index != lastIndex) MonAIDivider()
            }
        }
        item(key = "footnote") {
            Text(
                stringResource(R.string.categories_footnote),
                Modifier.padding(top = spacing.x4),
                style = MonAITheme.typography.bodySmall,
                color = colors.textTertiary,
            )
        }
    }
}

@Composable
private fun CategoriesSkeleton() {
    val spacing = MonAITheme.spacing
    Column(
        Modifier.padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
        verticalArrangement = Arrangement.spacedBy(spacing.x3),
    ) {
        repeat(SKELETON_ROWS) {
            MonAISkeleton(height = MonAITheme.sizes.listRowMin, modifier = Modifier.fillMaxWidth())
        }
    }
}

@PreviewLightDark
@Composable
private fun CategoriesScreenPreview() {
    MonAITheme {
        CategoriesScreen(CategoriesPreviewData.state, onIntent = {})
    }
}

private const val SKELETON_ROWS = 6
