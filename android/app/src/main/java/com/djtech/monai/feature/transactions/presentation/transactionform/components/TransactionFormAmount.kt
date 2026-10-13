package com.djtech.monai.feature.transactions.presentation.transactionform.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.text.font.FontWeight
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.common.format.formatThousands
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.HighlightIcon
import com.djtech.monai.core.designsystem.component.color
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.presentation.common.direction
import com.djtech.monai.feature.transactions.presentation.common.sign

/**
 * The typed amount, "−Rp 35.000" style, colored by type. While editing, the saved amount shows
 * underneath once it differs. [error] is the amount's validation message. A drafted amount shows
 * its [highlight]: a sparkle, or a warning to check it (or type it, when the draft had none).
 */
@Composable
internal fun TransactionFormAmount(
    type: TransactionType,
    amount: Long,
    originalAmount: Long?,
    error: String?,
    modifier: Modifier = Modifier,
    highlight: FieldHighlight = FieldHighlight.None,
) {
    val colors = MonAITheme.colors
    val prefix = when (type.sign()) {
        MoneySign.Negative -> "−Rp"
        MoneySign.Positive -> "+Rp"
        MoneySign.None -> "Rp"
    }
    val spoken = stringResource(R.string.transaction_form_amount, formatRupiahSigned(amount, type.sign()))
    Column(
        modifier
            .fillMaxWidth()
            .padding(vertical = MonAITheme.spacing.x1),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Row(
            Modifier.clearAndSetSemantics {
                contentDescription = spoken
                liveRegion = LiveRegionMode.Polite
            },
            verticalAlignment = Alignment.Bottom,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            Text(
                prefix,
                Modifier.padding(bottom = MonAITheme.spacing.x1_5),
                style = MonAITheme.typography.headlineSmall,
                color = colors.textTertiary,
            )
            Text(
                formatThousands(amount),
                style = MonAITheme.typography.displayLarge.copy(fontWeight = FontWeight.Bold).tabular(),
                color = if (amount == 0L) colors.textDisabled else type.direction().color(),
                maxLines = 1,
            )
            if (error == null && highlight == FieldHighlight.Ai) {
                HighlightIcon(highlight, Modifier.padding(bottom = MonAITheme.spacing.x2))
            }
        }
        when {
            error != null -> Text(error, style = MonAITheme.typography.bodySmall, color = colors.errorText)
            highlight == FieldHighlight.Low -> Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
            ) {
                HighlightIcon(highlight)
                Text(
                    stringResource(if (amount == 0L) R.string.ai_hint_amount_missing else R.string.ai_hint_check),
                    style = MonAITheme.typography.bodySmall,
                    color = colors.onWarningContainer,
                )
            }
            originalAmount != null && originalAmount != amount -> Text(
                stringResource(R.string.transaction_form_was, formatRupiah(originalAmount)),
                style = MonAITheme.typography.bodySmall.tabular(),
                color = colors.textTertiary,
            )
        }
    }
}
