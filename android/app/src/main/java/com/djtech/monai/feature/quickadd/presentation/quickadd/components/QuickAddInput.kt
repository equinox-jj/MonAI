package com.djtech.monai.feature.quickadd.presentation.quickadd.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiah
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.quickadd.presentation.common.dayText
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.ChipKind
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddChip
import java.time.LocalDate

/**
 * The phrase box: a sparkle, the text (focused on open, Done submits) and the chips of what the
 * phone understood underneath.
 */
@OptIn(ExperimentalLayoutApi::class)
@Composable
internal fun QuickAddInput(
    text: String,
    chips: List<QuickAddChip>,
    today: LocalDate,
    onTextChange: (String) -> Unit,
    onSubmit: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.lg)
    val focusRequester = remember { FocusRequester() }
    val description = stringResource(R.string.quick_add_input_description)
    LaunchedEffect(Unit) { focusRequester.requestFocus() }
    Column(
        modifier
            .fillMaxWidth()
            .background(colors.surface, shape)
            .border(MonAITheme.sizes.borderFocused, colors.focus, shape)
            .padding(horizontal = MonAITheme.spacing.x4, vertical = MonAITheme.spacing.x3_5),
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
    ) {
        Row(horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5)) {
            Icon(
                MonAIIcons.AutoAwesome,
                null,
                Modifier
                    .padding(top = MonAITheme.spacing.x0_5)
                    .size(22.dp),
                tint = colors.accent,
            )
            BasicTextField(
                value = text,
                onValueChange = onTextChange,
                modifier = Modifier
                    .weight(1f)
                    .focusRequester(focusRequester)
                    .semantics { contentDescription = description },
                textStyle = MonAITheme.typography.titleMedium.copy(
                    color = colors.textPrimary,
                    fontWeight = FontWeight.Medium,
                ),
                cursorBrush = SolidColor(colors.focus),
                keyboardOptions = KeyboardOptions(
                    capitalization = KeyboardCapitalization.None,
                    imeAction = ImeAction.Done,
                ),
                keyboardActions = KeyboardActions(onDone = { onSubmit() }),
                decorationBox = { field ->
                    if (text.isEmpty()) {
                        Text(
                            stringResource(R.string.quick_add_placeholder),
                            style = MonAITheme.typography.titleMedium,
                            color = colors.textTertiary,
                        )
                    }
                    field()
                },
            )
        }
        if (chips.isNotEmpty()) {
            val understood = stringResource(R.string.quick_add_understood)
            FlowRow(
                Modifier.semantics { contentDescription = understood },
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
                verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
            ) {
                chips.forEach { QuickAddChipPill(it, today) }
            }
        }
    }
}

@Composable
private fun QuickAddChipPill(chip: QuickAddChip, today: LocalDate) {
    val colors = MonAITheme.colors
    val (container, content) = if (chip.unsure) {
        colors.warningContainer to colors.onWarningContainer
    } else {
        colors.primaryContainer to colors.onPrimaryContainer
    }
    val icon = when {
        chip.unsure -> MonAIIcons.Help
        chip.kind == ChipKind.AMOUNT -> MonAIIcons.Payments
        chip.kind == ChipKind.CATEGORY -> MonAIIcons.Category
        chip.kind == ChipKind.WALLET -> MonAIIcons.AccountBalanceWallet
        else -> MonAIIcons.CalendarToday
    }
    Row(
        Modifier
            .heightIn(min = 28.dp)
            .background(container, CircleShape)
            .padding(horizontal = MonAITheme.spacing.x2_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1),
    ) {
        Icon(icon, null, Modifier.size(MonAITheme.sizes.iconXs), tint = content)
        Text(chipText(chip, today), style = MonAITheme.typography.labelSmall, color = content)
    }
}

@Composable
private fun chipText(chip: QuickAddChip, today: LocalDate): String = when (chip.kind) {
    ChipKind.AMOUNT -> chip.amount?.let(::formatRupiah) ?: stringResource(R.string.quick_add_chip_amount)
    ChipKind.CATEGORY -> chip.name?.takeUnless { chip.unsure } ?: stringResource(R.string.quick_add_chip_category)
    ChipKind.WALLET -> chip.name ?: stringResource(R.string.quick_add_chip_wallet)
    ChipKind.DATE -> dayText(chip.date ?: today, today)
}
