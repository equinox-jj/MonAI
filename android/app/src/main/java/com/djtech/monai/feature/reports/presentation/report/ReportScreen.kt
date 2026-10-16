package com.djtech.monai.feature.reports.presentation.report

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.rememberMonAIMessenger
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.reports.presentation.report.components.ReportBudgetCard
import com.djtech.monai.feature.reports.presentation.report.components.ReportCategoryBreakdown
import com.djtech.monai.feature.reports.presentation.report.components.ReportLoadError
import com.djtech.monai.feature.reports.presentation.report.components.ReportMonthSwitcher
import com.djtech.monai.feature.reports.presentation.report.components.ReportSkeleton
import com.djtech.monai.feature.reports.presentation.report.components.ReportTotals
import com.djtech.monai.feature.reports.presentation.report.preview.ReportPreviewData
import java.time.YearMonth

/** @param initialMonth the month to open on; null for the current one. */
@Composable
fun ReportRoute(
    initialMonth: YearMonth?,
    onOpenBudget: (YearMonth) -> Unit,
    onBack: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: ReportViewModel =
        hiltViewModel<ReportViewModel, ReportViewModel.Factory>(key = initialMonth.toString()) {
            it.create(initialMonth)
        },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val messenger = rememberMonAIMessenger()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            ReportEffect.NavigateBack -> onBack()
            is ReportEffect.OpenBudget -> onOpenBudget(effect.month)
            is ReportEffect.ShowMessage -> messenger.show(effect.message)
        }
    }
    ReportScreen(
        state,
        viewModel::onIntent,
        modifier,
        snackbarHostState = messenger.hostState,
    )
}

/** A month's totals, its spending by category and its budget, with a switcher between months. */
@Composable
fun ReportScreen(
    state: ReportState,
    onIntent: (ReportIntent) -> Unit,
    modifier: Modifier = Modifier,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        Column(Modifier.fillMaxSize()) {
            MonAITopBar(
                title = stringResource(R.string.report_title),
                onNavigationClick = { onIntent(ReportIntent.Back) },
            )
            Column(
                Modifier
                    .weight(1f)
                    .verticalScroll(rememberScrollState())
                    .navigationBarsPadding()
                    .padding(start = spacing.screenHorizontal, end = spacing.screenHorizontal, bottom = spacing.x6),
                verticalArrangement = Arrangement.spacedBy(spacing.x4),
            ) {
                ReportMonthSwitcher(
                    state.month,
                    state.canGoNext,
                    onPrevious = { onIntent(ReportIntent.PreviousMonth) },
                    onNext = { onIntent(ReportIntent.NextMonth) },
                )
                val totals = state.totals
                when {
                    totals != null -> {
                        ReportTotals(totals)
                        ReportCategoryBreakdown(state.categories, totals.expense, state.month)
                        state.budget?.let {
                            ReportBudgetCard(it, state.month, onClick = { onIntent(ReportIntent.OpenBudget) })
                        }
                    }

                    state.loadError != null -> ReportLoadError(
                        state.loadError,
                        onRetry = { onIntent(ReportIntent.Retry) },
                    )

                    else -> ReportSkeleton()
                }
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
}

@PreviewLightDark
@Composable
private fun ReportScreenPreview() {
    MonAITheme {
        ReportScreen(ReportPreviewData.state, onIntent = {})
    }
}

@Preview
@Composable
private fun ReportScreenLoadingPreview() {
    MonAITheme {
        ReportScreen(ReportState(month = YearMonth.of(2026, 10)), onIntent = {})
    }
}

@Preview
@Composable
private fun ReportScreenErrorPreview() {
    MonAITheme {
        ReportScreen(
            ReportState(
                month = YearMonth.of(2026, 8),
                canGoNext = true,
                isLoading = false,
                loadError = UiText.Resource(R.string.report_load_failed_network),
            ),
            onIntent = {},
        )
    }
}
