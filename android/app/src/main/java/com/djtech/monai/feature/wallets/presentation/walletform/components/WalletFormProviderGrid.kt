package com.djtech.monai.feature.wallets.presentation.walletform.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import com.djtech.monai.R
import com.djtech.monai.core.common.format.walletMonogram
import com.djtech.monai.core.designsystem.component.gradient
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.feature.wallets.presentation.walletform.WalletFormIntent

private const val COLUMNS = 5
private val LOGO_SIZE = 48.dp

/** "Pick where your money is": a logo grid of the catalog, then "Custom". */
@Composable
internal fun WalletFormProviderGrid(
    providers: List<PaymentProvider>,
    selectedSlug: String?,
    onIntent: (WalletFormIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    // Null stands for the "Custom" tile after the providers.
    val tiles: List<PaymentProvider?> = providers + null
    Column(modifier, verticalArrangement = Arrangement.spacedBy(spacing.x2_5)) {
        Text(
            stringResource(R.string.wallet_form_pick_provider),
            style = MonAITheme.typography.labelLarge,
            color = MonAITheme.colors.textSecondary,
        )
        Column(Modifier.selectableGroup(), verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
            tiles.chunked(COLUMNS).forEach { row ->
                Row(horizontalArrangement = Arrangement.spacedBy(spacing.x1)) {
                    row.forEach { provider ->
                        ProviderTile(
                            provider,
                            selected = provider?.slug == selectedSlug,
                            onClick = {
                                val pick = provider?.let { WalletFormIntent.PickProvider(it.slug) }
                                onIntent(pick ?: WalletFormIntent.PickCustom)
                            },
                            modifier = Modifier.weight(1f),
                        )
                    }
                    repeat(COLUMNS - row.size) { Spacer(Modifier.weight(1f)) }
                }
            }
        }
    }
}

@Composable
private fun ProviderTile(
    provider: PaymentProvider?,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val name = provider?.name ?: stringResource(R.string.wallet_form_custom)
    Column(
        modifier
            .heightIn(min = 76.dp)
            .clip(RoundedCornerShape(MonAITheme.radius.md))
            .selectable(selected = selected, role = Role.RadioButton, onClick = onClick)
            .padding(vertical = MonAITheme.spacing.x1),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        Box {
            Box(
                Modifier
                    .size(LOGO_SIZE)
                    .clip(CircleShape)
                    .background(if (selected) colors.primaryContainer else colors.background)
                    .border(
                        if (selected) MonAITheme.sizes.borderFocused else MonAITheme.sizes.border,
                        if (selected) colors.focus else colors.border,
                        CircleShape,
                    ),
                contentAlignment = Alignment.Center,
            ) {
                when {
                    provider == null -> Icon(
                        MonAIIcons.Add,
                        contentDescription = null,
                        tint = colors.textSecondary,
                    )

                    provider.logoUrl != null -> AsyncImage(
                        model = provider.logoUrl,
                        contentDescription = null,
                        modifier = Modifier
                            .size(LOGO_SIZE)
                            .clip(CircleShape),
                        contentScale = ContentScale.Crop,
                    )

                    else -> Text(
                        walletMonogram(provider.name),
                        style = MonAITheme.typography.labelSmall,
                        // The type's deep shade reads on the light circle; dark mode keeps the text color.
                        color = if (colors.isDark) colors.textPrimary else provider.type.gradient(false).start,
                    )
                }
            }
            if (selected) {
                Icon(
                    MonAIIcons.Check,
                    contentDescription = null,
                    modifier = Modifier
                        .align(Alignment.BottomEnd)
                        .offset(4.dp, 4.dp)
                        .size(20.dp)
                        .clip(CircleShape)
                        .background(colors.primary)
                        .border(2.dp, colors.surface, CircleShape)
                        .padding(3.dp),
                    tint = Color.White,
                )
            }
        }
        Text(
            name,
            style = MonAITheme.typography.labelMedium,
            color = colors.textSecondary,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            textAlign = TextAlign.Center,
        )
    }
}
