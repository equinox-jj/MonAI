package com.djtech.monai.feature.quickadd.presentation.quickadd.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.EngineNote

/** Who read the phrase, or which guess to know about, under the input. */
@Composable
internal fun QuickAddEngineLine(note: EngineNote, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val (icon, tint) = when (note) {
        EngineNote.OnPhone -> MonAIIcons.OfflineBolt to colors.success
        is EngineNote.DefaultWallet -> MonAIIcons.Info to colors.accent
        EngineNote.WillAskAi, EngineNote.AskedAi -> MonAIIcons.AutoAwesome to colors.accent
    }
    val text = when (note) {
        EngineNote.OnPhone -> stringResource(R.string.quick_add_engine_phone)
        is EngineNote.DefaultWallet -> stringResource(R.string.quick_add_engine_default_wallet, note.walletName)
        EngineNote.WillAskAi -> stringResource(R.string.quick_add_engine_will_ask)
        EngineNote.AskedAi -> stringResource(R.string.quick_add_engine_asked)
    }
    Row(
        modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        Icon(icon, null, Modifier.size(MonAITheme.sizes.iconSm), tint = tint)
        Text(text, style = MonAITheme.typography.bodySmall, color = colors.textSecondary)
    }
}
