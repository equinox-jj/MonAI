package com.djtech.monai.feature.auth.presentation.common

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.auth.presentation.onboarding.SampleExpenseCard
import com.djtech.monai.feature.auth.presentation.onboarding.SamplePromptCard

private val HeroPadding = 64.dp
private val HeadlineMaxWidth = 460.dp
private val SamplesMaxWidth = 420.dp
private val BrandTileSize = 40.dp

/** The tablet hero headline is larger than any type token (45/52 in the design). */
private val HeadlineFontSize = 45.sp
private val HeadlineLineHeight = 52.sp

/** Left half of the expanded auth layout. Decorative, so it is hidden from TalkBack. */
@Composable
internal fun AuthHeroPanel(modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    Box(
        modifier
            .clipToBounds()
            .background(colors.heroGradient)
            .clearAndSetSemantics {},
    ) {
        HeroCircle(
            Alignment.TopEnd,
            x = 120.dp,
            y = (-120).dp,
            size = 420.dp,
            alpha = 0.07f,
        )
        HeroCircle(
            Alignment.BottomStart,
            x = (-80).dp,
            y = 140.dp,
            size = 360.dp,
            alpha = 0.05f,
        )
        Column(
            Modifier
                .align(Alignment.CenterStart)
                .padding(HeroPadding),
            verticalArrangement = Arrangement.spacedBy(spacing.x6),
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(spacing.x3),
            ) {
                Box(
                    Modifier
                        .size(BrandTileSize)
                        .clip(RoundedCornerShape(MonAITheme.radius.md))
                        .background(colors.surface),
                    contentAlignment = Alignment.Center,
                ) {
                    Icon(MonAIIcons.AccountBalanceWallet, null, tint = colors.accent)
                }
                Text(
                    stringResource(R.string.auth_brand_name),
                    style = MonAITheme.typography.titleLarge.copy(fontWeight = FontWeight.Bold),
                    color = colors.onPrimary,
                )
            }
            Text(
                stringResource(R.string.auth_hero_title),
                Modifier.widthIn(max = HeadlineMaxWidth),
                style = MonAITheme.typography.displayLarge.copy(
                    fontSize = HeadlineFontSize,
                    lineHeight = HeadlineLineHeight,
                ),
                color = colors.onPrimary,
            )
            Column(
                Modifier.widthIn(max = SamplesMaxWidth),
                verticalArrangement = Arrangement.spacedBy(spacing.x3),
            ) {
                SamplePromptCard()
                SampleExpenseCard()
            }
        }
    }
}

@Composable
private fun BoxScope.HeroCircle(
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
