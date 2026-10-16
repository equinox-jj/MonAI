package com.djtech.monai.feature.budgets.presentation.budget

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.ScreenPlacement
import com.djtech.monai.core.designsystem.component.monthName
import com.djtech.monai.core.designsystem.component.rememberMonAIMessenger
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.budgets.presentation.budget.components.BudgetActions
import com.djtech.monai.feature.budgets.presentation.budget.components.BudgetLegend
import com.djtech.monai.feature.budgets.presentation.budget.components.BudgetLimitField
import com.djtech.monai.feature.budgets.presentation.budget.components.BudgetPresets
import com.djtech.monai.feature.budgets.presentation.budget.components.BudgetPreviewCard
import com.djtech.monai.feature.budgets.presentation.budget.components.BudgetRemoveDialog
import com.djtech.monai.feature.budgets.presentation.budget.model.BudgetPresetLimits
import com.djtech.monai.feature.budgets.presentation.budget.preview.BudgetPreviewData
import java.time.YearMonth

/**
 * @param onClose the budget was saved or removed, or the user went back.
 */
@Composable
fun BudgetRoute(
    month: YearMonth,
    onClose: () -> Unit,
    modifier: Modifier = Modifier,
    placement: ScreenPlacement = ScreenPlacement.FullScreen,
    viewModel: BudgetViewModel = hiltViewModel<BudgetViewModel, BudgetViewModel.Factory>(key = month.toString()) {
        it.create(
            month,
        )
    },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val messenger = rememberMonAIMessenger()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            BudgetEffect.Close -> onClose()
            is BudgetEffect.ShowMessage -> messenger.show(effect.message)
        }
    }
    BudgetScreen(
        state,
        viewModel::onIntent,
        modifier,
        placement = placement,
        snackbarHostState = messenger.hostState,
    )
}

/** One month's spending limit: the field and presets, a live preview, and save or remove. */
@Composable
fun BudgetScreen(
    state: BudgetState,
    onIntent: (BudgetIntent) -> Unit,
    modifier: Modifier = Modifier,
    placement: ScreenPlacement = ScreenPlacement.FullScreen,
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
                title = stringResource(R.string.budget_title, state.month.monthName()),
                onNavigationClick = { onIntent(BudgetIntent.Back) },
                placement = placement,
            )
            Column(
                Modifier
                    .weight(1f)
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x2),
                verticalArrangement = Arrangement.spacedBy(spacing.sectionGap),
            ) {
                Text(
                    stringResource(R.string.budget_intro),
                    style = MonAITheme.typography.bodyMedium,
                    color = MonAITheme.colors.textSecondary,
                )
                BudgetLimitField(
                    state.limit,
                    state.limitError?.asString(),
                    onLimitChange = { onIntent(BudgetIntent.LimitChanged(it)) },
                )
                BudgetPresets(
                    BudgetPresetLimits,
                    state.limit,
                    onPick = { onIntent(BudgetIntent.PickPreset(it)) },
                )
                state.preview?.let { BudgetPreviewCard(it) }
                BudgetLegend()
            }
            BudgetActions(
                state,
                onSave = { onIntent(BudgetIntent.Save) },
                onRemove = { onIntent(BudgetIntent.Delete) },
                modifier = Modifier
                    .navigationBarsPadding()
                    .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x4),
            )
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    if (state.isConfirmingDelete) {
        BudgetRemoveDialog(
            state.month,
            onConfirm = { onIntent(BudgetIntent.ConfirmDelete) },
            onDismiss = { onIntent(BudgetIntent.DismissDelete) },
        )
    }
}

@PreviewLightDark
@Composable
private fun BudgetScreenPreview() {
    MonAITheme {
        BudgetScreen(BudgetPreviewData.state, onIntent = {})
    }
}

@PreviewLightDark
@Composable
private fun BudgetScreenEmptyPreview() {
    MonAITheme {
        BudgetScreen(BudgetPreviewData.empty, onIntent = {})
    }
}
