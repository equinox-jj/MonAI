package com.djtech.monai.feature.home.presentation.home

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.pulltorefresh.PullToRefreshBox
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.rememberMonAIMessenger
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.home.presentation.home.components.HomeBalanceCard
import com.djtech.monai.feature.home.presentation.home.components.HomeBudgetCard
import com.djtech.monai.feature.home.presentation.home.components.HomeHeader
import com.djtech.monai.feature.home.presentation.home.components.HomeLoadError
import com.djtech.monai.feature.home.presentation.home.components.HomeQuickAdd
import com.djtech.monai.feature.home.presentation.home.components.HomeRecent
import com.djtech.monai.feature.home.presentation.home.components.HomeSkeleton
import com.djtech.monai.feature.home.presentation.home.components.HomeSpendingCard
import com.djtech.monai.feature.home.presentation.home.components.HomeWallets
import com.djtech.monai.feature.home.presentation.home.model.Greeting
import com.djtech.monai.feature.home.presentation.home.model.SpendingSlice
import com.djtech.monai.feature.home.presentation.home.preview.HomePreviewData

internal object HomeTestTags {
    const val LIST = "home_list"
    const val WALLETS = "home_wallets"
}

@Composable
fun HomeRoute(
    onNavigate: (HomeDestination) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: HomeViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val messenger = rememberMonAIMessenger()
    val offlineIcon = MonAIIcons.CloudOff
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is HomeEffect.Navigate -> onNavigate(effect.destination)
            is HomeEffect.ShowMessage ->
                messenger.show(effect.message, icon = if (effect.isOffline) offlineIcon else null)
        }
    }
    HomeScreen(
        state,
        viewModel::onIntent,
        modifier,
        snackbarHostState = messenger.hostState,
    )
}

/** The dashboard, its skeleton while the first load runs, or the error when that load failed. */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    state: HomeState,
    onIntent: (HomeIntent) -> Unit,
    modifier: Modifier = Modifier,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val statusBar = WindowInsets.statusBars.asPaddingValues()
    val contentPadding = PaddingValues(
        top = statusBar.calculateTopPadding() + MonAITheme.spacing.screenTop,
        bottom = MonAITheme.spacing.screenTop,
    )
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        when {
            state.isLoading -> HomeSkeleton(contentPadding)
            state.loadError != null -> HomeLoadError(state.loadError, onIntent, contentPadding)
            else -> PullToRefreshBox(
                isRefreshing = state.isRefreshing,
                onRefresh = { onIntent(HomeIntent.Refresh) },
                modifier = Modifier.fillMaxSize(),
            ) {
                HomeDashboard(state, onIntent, contentPadding)
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
}

/**
 * The sections, top to bottom. A month with nothing recorded shows the first-run layout: no
 * quick add, and the empty prompt in place of "Recent".
 */
@Composable
private fun HomeDashboard(
    state: HomeState,
    onIntent: (HomeIntent) -> Unit,
    contentPadding: PaddingValues,
) {
    val horizontal = Modifier.padding(horizontal = MonAITheme.spacing.screenHorizontal)
    val isFirstRun = state.greeting == Greeting.WELCOME
    LazyColumn(
        Modifier
            .fillMaxSize()
            .testTag(HomeTestTags.LIST),
        contentPadding = contentPadding,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.sectionGap),
    ) {
        item(key = "header") {
            HomeHeader(
                state.greeting,
                state.userName,
                state.initials,
                state.avatarUrl,
                onIntent,
                horizontal,
            )
        }
        item(key = "balance") { HomeBalanceCard(state, onIntent, horizontal) }
        if (!isFirstRun) {
            item(key = "quickAdd") { HomeQuickAdd(onIntent, horizontal) }
        }
        if (state.wallets.size > 1) {
            item(key = "wallets") { HomeWallets(state.wallets, state.isBalanceHidden, onIntent) }
        }
        state.budget?.let { budget ->
            item(key = "budget") {
                HomeBudgetCard(
                    budget,
                    state.month,
                    onClick = { onIntent(HomeIntent.Open(HomeDestination.Budget(state.month))) },
                    modifier = horizontal,
                )
            }
        }
        if (state.spending.isNotEmpty()) {
            item(key = "spending") {
                HomeSpendingCard(
                    state.spending,
                    expenseTotal = state.summary?.expenseTotal ?: state.spending.sumOf(SpendingSlice::amount),
                    month = state.month,
                    onOpenReport = { onIntent(HomeIntent.Open(HomeDestination.Report(state.month))) },
                    modifier = horizontal,
                )
            }
        }
        item(key = "recent") { HomeRecent(state.recent, onIntent, horizontal) }
    }
}

@PreviewLightDark
@Composable
private fun HomeScreenPreview() {
    MonAITheme { HomeScreen(HomePreviewData.dashboard, onIntent = {}) }
}

@Preview
@Composable
private fun HomeFirstRunPreview() {
    MonAITheme { HomeScreen(HomePreviewData.firstRun, onIntent = {}) }
}

@Preview
@Composable
private fun HomeLoadingPreview() {
    MonAITheme { HomeScreen(HomeState(month = HomePreviewData.dashboard.month), onIntent = {}) }
}

@Preview
@Composable
private fun HomeErrorPreview() {
    MonAITheme {
        HomeScreen(
            HomeState(
                month = HomePreviewData.dashboard.month,
                isLoading = false,
                loadError = UiText.Resource(R.string.home_load_failed_unexpected),
            ),
            onIntent = {},
        )
    }
}
