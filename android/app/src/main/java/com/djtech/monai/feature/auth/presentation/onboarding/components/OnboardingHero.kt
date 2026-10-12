package com.djtech.monai.feature.auth.presentation.onboarding.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAIMonogram
import com.djtech.monai.core.designsystem.component.MonAIPill
import com.djtech.monai.core.designsystem.component.MonAIProgressBar
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.WalletGradients
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.feature.auth.presentation.common.AuthIllustrationCard
import com.djtech.monai.feature.auth.presentation.common.AuthIllustrationRow
import com.djtech.monai.feature.auth.presentation.common.AuthSampleExpenseCard
import com.djtech.monai.feature.auth.presentation.common.AuthSamplePromptCard
import com.djtech.monai.feature.auth.presentation.common.SampleFoodColor
import com.djtech.monai.feature.auth.presentation.onboarding.model.OnboardingPage

// Sample data drawn in the illustrations. Category colors are the server's default category hexes.
private val BillsColor = CategoryColors.parse("#8B5CF6")
private val TransportColor = CategoryColors.parse("#0EA5E9")

private const val BcaBalance = 8_250_000L
private const val GoPayBalance = 1_185_000L
private const val CashBalance = 450_000L
private const val BudgetLeft = 585_000L

private val BreakdownLabelWidth = 64.dp
private val BreakdownPercentWidth = 32.dp

/** The indigo panel at the top of each page. The illustration is decorative, so it is hidden from TalkBack. */
@Composable
internal fun OnboardingHero(
    page: OnboardingPage,
    onSkip: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    Box(
        modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(MonAITheme.radius.xxxl))
            .background(MonAITheme.colors.heroGradient),
    ) {
        when (page) {
            OnboardingPage.Capture -> {
                DecorCircle(
                    Alignment.TopStart,
                    x = (-60).dp,
                    y = (-60).dp,
                    size = 220.dp,
                    alpha = 0.07f,
                )
                DecorCircle(
                    Alignment.BottomEnd,
                    x = 40.dp,
                    y = 80.dp,
                    size = 240.dp,
                    alpha = 0.06f,
                )
            }

            OnboardingPage.Wallets -> DecorCircle(
                Alignment.TopEnd,
                x = 60.dp,
                y = (-60).dp,
                size = 220.dp,
                alpha = 0.07f,
            )

            OnboardingPage.Insights -> DecorCircle(
                Alignment.BottomStart,
                x = (-60).dp,
                y = 60.dp,
                size = 220.dp,
                alpha = 0.07f,
            )
        }
        val gap = when (page) {
            OnboardingPage.Capture -> spacing.x3_5
            OnboardingPage.Wallets -> spacing.x2_5
            OnboardingPage.Insights -> spacing.x3
        }
        Column(
            Modifier
                .fillMaxSize()
                .padding(spacing.x6)
                .clearAndSetSemantics {},
            verticalArrangement = Arrangement.spacedBy(gap, Alignment.CenterVertically),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            when (page) {
                OnboardingPage.Capture -> CaptureIllustration()
                OnboardingPage.Wallets -> WalletsIllustration()
                OnboardingPage.Insights -> InsightsIllustration()
            }
        }
        if (page == OnboardingPage.Wallets) {
            SkipButton(
                onSkip,
                Modifier
                    .align(Alignment.TopEnd)
                    .padding(top = spacing.x2_5, end = spacing.x4),
            )
        }
    }
}

@Composable
private fun BoxScope.DecorCircle(
    alignment: Alignment,
    x: Dp,
    y: Dp,
    size: Dp,
    alpha: Float,
) {
    Box(
        Modifier
            .align(alignment)
            .offset(x, y)
            .size(size)
            .clip(CircleShape)
            .background(Color.White.copy(alpha = alpha)),
    )
}

@Composable
private fun SkipButton(onClick: () -> Unit, modifier: Modifier = Modifier) {
    Box(
        modifier
            .defaultMinSize(MonAITheme.sizes.touchTarget, MonAITheme.sizes.touchTarget)
            .clip(RoundedCornerShape(MonAITheme.radius.sm))
            .clickable(role = Role.Button, onClick = onClick)
            .padding(horizontal = MonAITheme.spacing.x1_5),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = stringResource(R.string.onboarding_skip),
            style = MonAITheme.typography.labelLarge,
            color = MonAITheme.colors.onGradientMuted,
        )
    }
}

/** Page 1: a typed sentence becomes a categorised expense. */
@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun CaptureIllustration() {
    val spacing = MonAITheme.spacing
    AuthSamplePromptCard()
    Icon(
        MonAIIcons.South,
        null,
        Modifier.size(MonAITheme.sizes.iconXl),
        tint = MonAITheme.colors.highlight,
    )
    AuthSampleExpenseCard()
    FlowRow(
        horizontalArrangement = Arrangement.spacedBy(spacing.x2, Alignment.CenterHorizontally),
        verticalArrangement = Arrangement.spacedBy(spacing.x2),
    ) {
        // Wallet and provider names are brands, so they stay untranslated.
        listOf(
            "Cash",
            "BCA",
            "GoPay",
            "OVO",
            "DANA",
        ).forEach { MonAIPill(it) }
    }
}

/** Page 2: wallets stacked into one total. */
@Composable
private fun WalletsIllustration() {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    val dark = colors.isDark
    WalletRow(
        "BCA",
        colors.primary,
        stringResource(R.string.onboarding_sample_bca),
        BcaBalance,
        indent = 0.dp,
    )
    WalletRow(
        "GP",
        WalletGradients.eWallet(dark).start,
        stringResource(R.string.onboarding_sample_gopay),
        GoPayBalance,
        indent = spacing.x4,
    )
    WalletRow(
        "Rp",
        WalletGradients.cash(dark).start,
        stringResource(R.string.onboarding_sample_cash),
        CashBalance,
        indent = spacing.x8,
    )
    Spacer(Modifier.height(spacing.x2))
    Row(
        Modifier
            .clip(CircleShape)
            .background(colors.highlight)
            .padding(horizontal = spacing.x4, vertical = spacing.x2),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(spacing.x2),
    ) {
        Text(
            stringResource(R.string.onboarding_sample_total),
            style = MonAITheme.typography.labelMedium,
            color = colors.onHighlight,
        )
        Text(
            formatRupiah(BcaBalance + GoPayBalance + CashBalance),
            style = MonAITheme.typography.titleMedium.copy(fontWeight = FontWeight.Bold).tabular(),
            color = colors.onHighlight,
        )
    }
}

@Composable
private fun WalletRow(
    monogram: String,
    monogramColor: Color,
    name: String,
    balance: Long,
    indent: Dp,
) {
    val labelStyle = MonAITheme.typography.labelLarge
    AuthIllustrationCard(
        RoundedCornerShape(MonAITheme.radius.lg),
        modifier = Modifier.padding(start = indent),
        contentPadding = PaddingValues(
            horizontal = MonAITheme.spacing.x3_5,
            vertical = MonAITheme.spacing.x3,
        ),
    ) {
        AuthIllustrationRow {
            MonAIMonogram(
                monogram,
                containerColor = monogramColor,
                contentColor = Color.White,
                size = 36.dp,
            )
            Text(name, Modifier.weight(1f), style = labelStyle)
            Text(formatRupiah(balance), style = labelStyle.tabular())
        }
    }
}

/** Page 3: a budget nearing its limit and where the money went. */
@Composable
private fun InsightsIllustration() {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    val type = MonAITheme.typography
    val cardShape = RoundedCornerShape(MonAITheme.radius.xl)
    AuthIllustrationCard(cardShape) {
        Column(verticalArrangement = Arrangement.spacedBy(spacing.x2_5)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    stringResource(R.string.onboarding_sample_budget),
                    Modifier.weight(1f),
                    style = type.labelLarge,
                )
                Text(
                    "80%",
                    style = type.titleMedium.copy(fontWeight = FontWeight.Bold).tabular(),
                    color = colors.warning,
                )
            }
            MonAIProgressBar(0.8f, color = colors.warning)
            Text(
                stringResource(R.string.onboarding_sample_budget_left, formatRupiah(BudgetLeft)),
                style = type.bodySmall.tabular(),
                color = colors.textSecondary,
            )
        }
    }
    AuthIllustrationCard(cardShape) {
        Column(verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
            Text(stringResource(R.string.onboarding_sample_breakdown), style = type.labelLarge)
            BreakdownRow(
                stringResource(R.string.onboarding_sample_food),
                SampleFoodColor,
                fill = 1f,
                percent = 36,
            )
            BreakdownRow(
                stringResource(R.string.onboarding_sample_bills),
                BillsColor,
                fill = 0.7f,
                percent = 25,
            )
            BreakdownRow(
                stringResource(R.string.onboarding_sample_transport),
                TransportColor,
                fill = 0.48f,
                percent = 17,
            )
        }
    }
    MonAIPill(stringResource(R.string.onboarding_sample_comparison))
}

/** One category bar. [fill] is relative to the largest category, as in the report. */
@Composable
private fun BreakdownRow(
    label: String,
    color: Color,
    fill: Float,
    percent: Int,
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        Text(label, Modifier.width(BreakdownLabelWidth), style = MonAITheme.typography.bodySmall)
        MonAIProgressBar(
            fill,
            Modifier.weight(1f),
            color = CategoryColors.content(color, MonAITheme.colors.isDark),
        )
        Text(
            "$percent%",
            Modifier.width(BreakdownPercentWidth),
            style = MonAITheme.typography.labelMedium.tabular(),
            textAlign = TextAlign.End,
        )
    }
}
