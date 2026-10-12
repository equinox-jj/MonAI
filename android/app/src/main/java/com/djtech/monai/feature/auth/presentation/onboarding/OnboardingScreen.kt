package com.djtech.monai.feature.auth.presentation.onboarding

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.tooling.preview.PreviewScreenSizes
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.auth.presentation.onboarding.components.OnboardingFooter
import com.djtech.monai.feature.auth.presentation.onboarding.components.OnboardingPageContent
import com.djtech.monai.feature.auth.presentation.onboarding.model.OnboardingPage

/** Keeps the phone layout readable on tablets, where there is no separate onboarding design. */
private val MaxContentWidth = 480.dp

@Composable
fun OnboardingRoute(
    onNavigateToRegister: () -> Unit,
    onNavigateToSignIn: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: OnboardingViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            OnboardingEffect.NavigateToRegister -> onNavigateToRegister()
            OnboardingEffect.NavigateToSignIn -> onNavigateToSignIn()
        }
    }
    OnboardingScreen(state, viewModel::onIntent, modifier)
}

@Composable
fun OnboardingScreen(
    state: OnboardingState,
    onIntent: (OnboardingIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val pagerState = rememberPagerState(initialPage = state.page) { state.pageCount }
    val currentOnIntent by rememberUpdatedState(onIntent)

    // The ViewModel owns the page: buttons change it and the pager follows. Always animating
    // (rather than only when the page differs) also finishes a scroll a fast tap cut short.
    LaunchedEffect(state.page) { pagerState.animateScrollToPage(state.page) }
    // A swipe reports back once the pager comes to rest.
    LaunchedEffect(pagerState) {
        snapshotFlow { pagerState.settledPage }.collect { currentOnIntent(OnboardingIntent.PageSettled(it)) }
    }
    // System back steps through the pages before leaving the app.
    BackHandler(enabled = state.page > 0) { onIntent(OnboardingIntent.Back) }

    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background)
            .safeDrawingPadding(),
        contentAlignment = Alignment.TopCenter,
    ) {
        Column(
            Modifier
                .widthIn(max = MaxContentWidth)
                .fillMaxHeight(),
        ) {
            HorizontalPager(
                state = pagerState,
                modifier = Modifier.weight(1f),
                key = { OnboardingPage.entries[it] },
            ) { index ->
                OnboardingPageContent(
                    OnboardingPage.entries[index],
                    onSkip = { onIntent(OnboardingIntent.Skip) },
                )
            }
            OnboardingFooter(
                state,
                onIntent,
                Modifier.padding(
                    start = MonAITheme.spacing.screenHorizontalWide,
                    end = MonAITheme.spacing.screenHorizontalWide,
                    top = MonAITheme.spacing.x6,
                    bottom = MonAITheme.spacing.x8,
                ),
            )
        }
    }
}

@PreviewLightDark
@PreviewScreenSizes
@Composable
private fun OnboardingScreenPreview() {
    MonAITheme { OnboardingScreen(OnboardingState(page = 0), onIntent = {}) }
}

@PreviewLightDark
@Composable
private fun OnboardingWalletsPreview() {
    MonAITheme { OnboardingScreen(OnboardingState(page = 1), onIntent = {}) }
}

@PreviewLightDark
@Composable
private fun OnboardingInsightsPreview() {
    MonAITheme { OnboardingScreen(OnboardingState(page = 2), onIntent = {}) }
}
