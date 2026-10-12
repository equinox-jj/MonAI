package com.djtech.monai.feature.auth.presentation.onboarding

import androidx.activity.compose.BackHandler
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberUpdatedState
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.tooling.preview.PreviewScreenSizes
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIPageIndicator
import com.djtech.monai.core.designsystem.component.MonAITextLink
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

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

@Composable
private fun OnboardingPageContent(page: OnboardingPage, onSkip: () -> Unit) {
    val spacing = MonAITheme.spacing
    Column(
        Modifier
            .fillMaxSize()
            .padding(start = spacing.screenHorizontalWide, end = spacing.screenHorizontalWide, top = spacing.x6),
        verticalArrangement = Arrangement.spacedBy(spacing.x6),
    ) {
        OnboardingHero(page, onSkip, Modifier.weight(1f))
        Column(verticalArrangement = Arrangement.spacedBy(spacing.x2_5)) {
            Text(
                text = stringResource(page.titleRes),
                modifier = Modifier.semantics { heading() },
                style = MonAITheme.typography.displaySmall,
                color = MonAITheme.colors.textPrimary,
            )
            Text(
                text = stringResource(page.bodyRes),
                style = MonAITheme.typography.bodyLarge,
                color = MonAITheme.colors.textSecondary,
            )
        }
    }
}

@Composable
private fun OnboardingFooter(
    state: OnboardingState,
    onIntent: (OnboardingIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    val next = stringResource(R.string.onboarding_next)
    Column(modifier, verticalArrangement = Arrangement.spacedBy(spacing.x6)) {
        Row(
            Modifier
                .fillMaxWidth()
                // Fixed to the link's touch height so the pager doesn't jump when it fades out.
                .heightIn(min = MonAITheme.sizes.touchTarget),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            val step = stringResource(R.string.onboarding_step, state.page + 1, state.pageCount)
            MonAIPageIndicator(
                pageCount = state.pageCount,
                currentPage = state.page,
                modifier = Modifier.semantics { contentDescription = step },
            )
            AnimatedVisibility(visible = state.page == 0, enter = fadeIn(), exit = fadeOut()) {
                MonAITextLink(next, { onIntent(OnboardingIntent.Next) }, trailingIcon = MonAIIcons.ArrowForward)
            }
        }
        // The first page can skip ahead, the middle one steps Back/Next, the last offers the account actions.
        AnimatedContent(
            targetState = OnboardingPage.entries[state.page],
            label = "onboardingActions",
        ) { page ->
            when (page) {
                OnboardingPage.Capture -> MonAIButton(
                    text = stringResource(R.string.onboarding_skip),
                    onClick = { onIntent(OnboardingIntent.Skip) },
                    modifier = Modifier.fillMaxWidth(),
                    variant = MonAIButtonVariant.Outlined,
                )

                OnboardingPage.Wallets -> Row(horizontalArrangement = Arrangement.spacedBy(spacing.x3)) {
                    MonAIButton(
                        text = stringResource(R.string.onboarding_back),
                        onClick = { onIntent(OnboardingIntent.Back) },
                        modifier = Modifier.weight(1f),
                        variant = MonAIButtonVariant.Outlined,
                    )
                    MonAIButton(
                        text = next,
                        onClick = { onIntent(OnboardingIntent.Next) },
                        modifier = Modifier.weight(1f),
                        trailingIcon = MonAIIcons.ArrowForward,
                    )
                }

                OnboardingPage.Insights -> Column(verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
                    MonAIButton(
                        text = stringResource(R.string.onboarding_create_account),
                        onClick = { onIntent(OnboardingIntent.CreateAccount) },
                        modifier = Modifier.fillMaxWidth(),
                    )
                    MonAIButton(
                        text = stringResource(R.string.onboarding_sign_in),
                        onClick = { onIntent(OnboardingIntent.SignIn) },
                        modifier = Modifier.fillMaxWidth(),
                        variant = MonAIButtonVariant.Text,
                        size = MonAIButtonSize.Medium,
                    )
                }
            }
        }
    }
}

private val OnboardingPage.titleRes: Int
    get() = when (this) {
        OnboardingPage.Capture -> R.string.onboarding_capture_title
        OnboardingPage.Wallets -> R.string.onboarding_wallets_title
        OnboardingPage.Insights -> R.string.onboarding_insights_title
    }

private val OnboardingPage.bodyRes: Int
    get() = when (this) {
        OnboardingPage.Capture -> R.string.onboarding_capture_body
        OnboardingPage.Wallets -> R.string.onboarding_wallets_body
        OnboardingPage.Insights -> R.string.onboarding_insights_body
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
