package com.djtech.monai.feature.home.presentation.home.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAIDivider
import com.djtech.monai.core.designsystem.component.MonAIGradientCard
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Placeholder blocks in the dashboard's shape while the first load runs. Read out as one label. */
@Composable
internal fun HomeSkeleton(contentPadding: PaddingValues, modifier: Modifier = Modifier) {
    val spacing = MonAITheme.spacing
    val sizes = MonAITheme.sizes
    val description = stringResource(R.string.home_loading)
    // Laid out at full height and clipped, so a short screen cuts the last blocks instead of squeezing them.
    Column(
        modifier
            .fillMaxSize()
            .clipToBounds()
            .wrapContentHeight(Alignment.Top, unbounded = true)
            .padding(contentPadding)
            .clearAndSetSemantics { contentDescription = description },
        verticalArrangement = Arrangement.spacedBy(spacing.sectionGap),
    ) {
        Row(
            Modifier.padding(horizontal = spacing.screenHorizontal),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(spacing.x3),
        ) {
            Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
                MonAISkeleton(14.dp, width = 110.dp)
                MonAISkeleton(22.dp, width = 90.dp)
            }
            MonAISkeleton(sizes.touchTarget, width = sizes.touchTarget, shape = CircleShape)
            MonAISkeleton(sizes.touchTarget, width = sizes.touchTarget, shape = CircleShape)
        }
        MonAIGradientCard(
            Modifier
                .fillMaxWidth()
                .padding(horizontal = spacing.screenHorizontal),
            elevated = false,
            decorated = false,
        ) {
            MonAISkeleton(14.dp, width = 150.dp, onGradient = true)
            MonAISkeleton(
                36.dp,
                width = 180.dp,
                shape = RoundedCornerShape(6.dp),
                onGradient = true,
            )
            Row(horizontalArrangement = Arrangement.spacedBy(spacing.x2)) {
                repeat(2) {
                    MonAISkeleton(
                        52.dp,
                        Modifier.weight(1f),
                        shape = RoundedCornerShape(MonAITheme.radius.lg),
                        onGradient = true,
                    )
                }
            }
        }
        MonAISkeleton(
            sizes.quickAddField,
            Modifier.padding(horizontal = spacing.screenHorizontal),
            shape = CircleShape,
        )
        Column(verticalArrangement = Arrangement.spacedBy(spacing.sectionContentGap)) {
            MonAISkeleton(20.dp, Modifier.padding(horizontal = spacing.screenHorizontal), width = 80.dp)
            Row(
                Modifier.padding(start = spacing.screenHorizontal),
                horizontalArrangement = Arrangement.spacedBy(spacing.x3),
            ) {
                repeat(2) {
                    MonAISkeleton(
                        sizes.walletCardHeight,
                        width = sizes.walletCardWidth,
                        shape = RoundedCornerShape(MonAITheme.radius.lg),
                    )
                }
            }
        }
        MonAICard(
            Modifier
                .fillMaxWidth()
                .padding(horizontal = spacing.screenHorizontal),
        ) {
            Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                MonAISkeleton(16.dp, width = 120.dp)
                MonAISkeleton(16.dp, width = 40.dp)
            }
            MonAISkeleton(sizes.progressTrack)
            MonAISkeleton(12.dp, width = 200.dp)
        }
        MonAICard(
            Modifier
                .fillMaxWidth()
                .padding(horizontal = spacing.screenHorizontal),
            contentPadding = PaddingValues(0.dp),
            verticalArrangement = Arrangement.Top,
        ) {
            RowSkeleton(titleFraction = 0.6f, metaFraction = 0.4f)
            MonAIDivider()
            RowSkeleton(titleFraction = 0.5f, metaFraction = 0.35f)
        }
    }
}

@Composable
private fun RowSkeleton(titleFraction: Float, metaFraction: Float) {
    val spacing = MonAITheme.spacing
    Row(
        Modifier.padding(horizontal = spacing.x4, vertical = spacing.x3_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(spacing.x3),
    ) {
        MonAISkeleton(
            MonAITheme.sizes.avatarMedium,
            width = MonAITheme.sizes.avatarMedium,
            shape = CircleShape,
        )
        Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(spacing.x1_5)) {
            MonAISkeleton(14.dp, Modifier.fillMaxWidth(titleFraction))
            MonAISkeleton(10.dp, Modifier.fillMaxWidth(metaFraction))
        }
        MonAISkeleton(14.dp, width = 70.dp)
    }
}
