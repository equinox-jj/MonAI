package com.djtech.monai.feature.auth.presentation.onboarding.components

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAIPageIndicator
import com.djtech.monai.core.designsystem.component.MonAITextLink
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.auth.presentation.onboarding.OnboardingIntent
import com.djtech.monai.feature.auth.presentation.onboarding.OnboardingState
import com.djtech.monai.feature.auth.presentation.onboarding.model.OnboardingPage

/** The step dots and the page's actions: Skip, Back/Next, or the account buttons. */
@Composable
internal fun OnboardingFooter(
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
