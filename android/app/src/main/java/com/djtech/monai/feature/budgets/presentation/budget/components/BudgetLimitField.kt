package com.djtech.monai.feature.budgets.presentation.budget.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.IntrinsicSize
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.error
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.TextRange
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatThousands
import com.djtech.monai.core.common.format.parseAmount
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular

private val UnderlineWidth = 220.dp

/**
 * The limit in large figures with an underline, typed on the number keyboard and shown with dot
 * grouping. [onLimitChange] gets 0 when cleared; input past the largest amount is ignored.
 */
@Composable
internal fun BudgetLimitField(
    limit: Long,
    error: String?,
    onLimitChange: (Long) -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val text = if (limit == 0L) "" else formatThousands(limit)
    val label = stringResource(R.string.budget_limit_description)
    Column(
        modifier
            .fillMaxWidth()
            .padding(vertical = MonAITheme.spacing.x2),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        Text(
            stringResource(R.string.budget_limit_label),
            style = MonAITheme.typography.labelMedium,
            color = colors.textSecondary,
        )
        Row(
            verticalAlignment = Alignment.Bottom,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            Text(
                stringResource(R.string.budget_currency),
                Modifier.padding(bottom = MonAITheme.spacing.x1_5),
                style = MonAITheme.typography.headlineSmall,
                color = colors.textTertiary,
            )
            val style = MonAITheme.typography.displayLarge.copy(fontWeight = FontWeight.Bold).tabular()
            // The caret always sits at the end, since the text is regrouped on every keystroke.
            BasicTextField(
                value = TextFieldValue(text, TextRange(text.length)),
                onValueChange = { value ->
                    val digits = value.text.filter(Char::isDigit)
                    val parsed = if (digits.isEmpty()) 0L else parseAmount(digits)
                    if (parsed != null && parsed != limit) onLimitChange(parsed)
                },
                modifier = Modifier
                    .width(IntrinsicSize.Min)
                    .widthIn(min = 40.dp)
                    .semantics {
                        contentDescription = label
                        if (error != null) error(error)
                    },
                textStyle = style.copy(color = colors.textPrimary, textAlign = TextAlign.Center),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number, imeAction = ImeAction.Done),
                singleLine = true,
                cursorBrush = SolidColor(colors.focus),
                decorationBox = { field ->
                    Box(contentAlignment = Alignment.Center) {
                        if (text.isEmpty()) Text("0", style = style, color = colors.textDisabled)
                        field()
                    }
                },
            )
        }
        Box(
            Modifier
                .width(UnderlineWidth)
                .height(MonAITheme.sizes.borderFocused)
                .clip(RoundedCornerShape(MonAITheme.sizes.borderFocused))
                .background(if (error != null) colors.error else colors.focus),
        )
        if (error != null) {
            Text(
                error,
                style = MonAITheme.typography.bodySmall,
                color = colors.errorText,
                textAlign = TextAlign.Center,
            )
        }
    }
}
