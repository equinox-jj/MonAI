package com.djtech.monai.feature.wallets.presentation.walletdetail.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAISkeleton
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Placeholder blocks in the detail's shape while an uncached wallet loads. */
@Composable
internal fun WalletDetailSkeleton(modifier: Modifier = Modifier) {
    val spacing = MonAITheme.spacing
    val description = stringResource(R.string.wallet_detail_loading)
    Column(
        modifier
            .fillMaxSize()
            .padding(spacing.screenHorizontal)
            .clearAndSetSemantics { contentDescription = description },
        verticalArrangement = Arrangement.spacedBy(spacing.x4),
    ) {
        MonAISkeleton(176.dp, shape = RoundedCornerShape(MonAITheme.radius.lg))
        Row(horizontalArrangement = Arrangement.spacedBy(spacing.x2)) {
            repeat(3) { MonAISkeleton(64.dp, Modifier.weight(1f), shape = RoundedCornerShape(MonAITheme.radius.md)) }
        }
        MonAISkeleton(180.dp, shape = RoundedCornerShape(MonAITheme.radius.lg))
    }
}

/** Replaces the detail when the wallet couldn't be loaded or no longer exists. */
@Composable
internal fun WalletDetailLoadError(message: UiText, onRetry: () -> Unit, modifier: Modifier = Modifier) {
    Box(
        modifier
            .fillMaxSize()
            .padding(horizontal = MonAITheme.spacing.x10),
        contentAlignment = Alignment.Center,
    ) {
        MonAIStateMessage(
            icon = MonAIIcons.Error,
            title = stringResource(R.string.wallet_detail_error_title),
            message = message.asString(),
            tone = MonAIAlertTone.Error,
            actionLabel = stringResource(R.string.wallets_try_again),
            actionIcon = MonAIIcons.Refresh,
            onAction = onRetry,
        )
    }
}
