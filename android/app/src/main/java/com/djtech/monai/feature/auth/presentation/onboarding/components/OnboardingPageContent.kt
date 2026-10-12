package com.djtech.monai.feature.auth.presentation.onboarding.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.auth.presentation.onboarding.model.OnboardingPage

/** One page: the illustration with its Skip button, then the title and body. */
@Composable
internal fun OnboardingPageContent(page: OnboardingPage, onSkip: () -> Unit) {
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
