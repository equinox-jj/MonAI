package com.djtech.monai.feature.wallets.presentation.wallets.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentHeight
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
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Placeholder blocks in the list's shape while the first load runs. Read out as one label. */
@Composable
internal fun WalletsSkeleton(contentPadding: PaddingValues, modifier: Modifier = Modifier) {
    val spacing = MonAITheme.spacing
    val description = stringResource(R.string.wallets_loading)
    Column(
        modifier
            .fillMaxSize()
            .clipToBounds()
            .wrapContentHeight(Alignment.Top, unbounded = true)
            .padding(contentPadding)
            .padding(horizontal = spacing.screenHorizontal)
            .clearAndSetSemantics { contentDescription = description },
        verticalArrangement = Arrangement.spacedBy(spacing.x4),
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            MonAISkeleton(28.dp, width = 120.dp)
            Spacer(Modifier.weight(1f))
            MonAISkeleton(
                MonAITheme.sizes.buttonSmall,
                width = 120.dp,
                shape = RoundedCornerShape(MonAITheme.radius.xxxl),
            )
        }
        MonAICard(Modifier.fillMaxWidth()) {
            MonAISkeleton(14.dp, width = 140.dp)
            MonAISkeleton(32.dp, width = 200.dp)
            MonAISkeleton(MonAITheme.sizes.progressTrack)
        }
        repeat(3) {
            MonAISkeleton(WALLET_CARD_HEIGHT, shape = RoundedCornerShape(MonAITheme.radius.lg))
        }
    }
}
