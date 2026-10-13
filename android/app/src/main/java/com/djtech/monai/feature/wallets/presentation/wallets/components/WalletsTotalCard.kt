package com.djtech.monai.feature.wallets.presentation.wallets.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.gradient
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.wallets.domain.model.WalletTypeShare
import kotlin.math.roundToInt

/** "Total across N wallets", the sum, and a stacked bar of how it splits by wallet type. */
@Composable
internal fun WalletsTotalCard(
    totalBalance: Long,
    walletCount: Int,
    shares: List<WalletTypeShare>,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    MonAICard(modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1)) {
        Text(
            pluralStringResource(R.plurals.wallets_total, walletCount, walletCount),
            style = MonAITheme.extendedTypography.bodyCompact,
            color = colors.textTertiary,
        )
        Text(
            formatRupiah(totalBalance),
            style = MonAITheme.extendedTypography.amountLarge,
            color = colors.textPrimary,
        )
        if (shares.isNotEmpty()) ShareBar(shares)
    }
}

@Composable
private fun ShareBar(shares: List<WalletTypeShare>) {
    val spacing = MonAITheme.spacing
    val dark = MonAITheme.colors.isDark
    val legend = shares.map { share ->
        stringResource(R.string.wallets_type_share, share.type.label(), (share.share * 100).roundToInt())
    }
    val description = stringResource(R.string.wallets_balance_split) + ": " + legend.joinToString(", ")
    Column(
        Modifier.clearAndSetSemantics { contentDescription = description },
        verticalArrangement = Arrangement.spacedBy(spacing.x1_5),
    ) {
        Row(
            Modifier
                .padding(top = spacing.x2)
                .fillMaxWidth()
                .height(MonAITheme.sizes.progressTrack)
                .clip(RoundedCornerShape(MonAITheme.radius.xs)),
            horizontalArrangement = Arrangement.spacedBy(2.dp),
        ) {
            shares.forEach { share ->
                Box(
                    Modifier
                        .weight(share.share)
                        .fillMaxHeight()
                        .background(share.type.barColor(dark)),
                )
            }
        }
        FlowRow(horizontalArrangement = Arrangement.spacedBy(spacing.x3)) {
            shares.forEachIndexed { index, share ->
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(spacing.x1),
                ) {
                    Box(
                        Modifier
                            .size(spacing.x2)
                            .clip(CircleShape)
                            .background(share.type.barColor(dark)),
                    )
                    Text(
                        legend[index],
                        style = MonAITheme.typography.bodySmall,
                        color = MonAITheme.colors.textSecondary,
                    )
                }
            }
        }
    }
}

private fun WalletType.barColor(dark: Boolean): Color = gradient(dark).end
