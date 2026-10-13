package com.djtech.monai.feature.quickadd.presentation.quickaddreview.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.onClick
import androidx.compose.ui.semantics.role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.HighlightIcon
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.moneyColor
import com.djtech.monai.core.designsystem.component.moneySign
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.TransactionType

/**
 * The draft's category icon, its amount (tap to change; amber "Rp —" when missing) and its type.
 * [error] is the amount's validation message.
 */
@Composable
internal fun QuickAddReviewHero(
    type: TransactionType,
    amount: Long?,
    category: Category?,
    highlight: FieldHighlight,
    error: String?,
    onEditAmount: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val colors = MonAITheme.colors
    val amountText = amount?.let { formatRupiahSigned(it, type.moneySign()) }
        ?: stringResource(R.string.quick_add_no_amount)
    val description = stringResource(R.string.quick_add_review_change_amount, amountText)
    Column(
        modifier
            .fillMaxWidth()
            .padding(vertical = MonAITheme.spacing.x2),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        MonAICategoryIcon(
            if (type == TransactionType.TRANSFER) MonAIIcons.SwapHoriz else categoryIcon(category?.icon),
            if (type == TransactionType.TRANSFER) colors.primary else CategoryColors.parse(category?.color),
            size = 56.dp,
            iconSize = MonAITheme.sizes.iconXl,
        )
        Row(
            Modifier
                .clip(RoundedCornerShape(MonAITheme.radius.md))
                .clickable(role = Role.Button, onClick = onEditAmount)
                .padding(horizontal = MonAITheme.spacing.x2)
                .clearAndSetSemantics {
                    contentDescription = description
                    role = Role.Button
                    onClick { onEditAmount(); true }
                },
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            Text(
                amountText,
                style = MonAITheme.typography.displayMedium.copy(fontWeight = FontWeight.Bold).tabular(),
                color = if (amount == null) colors.onWarningContainer else type.moneyColor(),
            )
            if (highlight != FieldHighlight.None) HighlightIcon(highlight)
        }
        Text(
            stringResource(
                when (type) {
                    TransactionType.EXPENSE -> R.string.transaction_type_expense
                    TransactionType.INCOME -> R.string.transaction_type_income
                    TransactionType.TRANSFER -> R.string.transaction_type_transfer
                },
            ),
            style = MonAITheme.typography.bodySmall,
            color = colors.textTertiary,
        )
        if (error != null) Text(error, style = MonAITheme.typography.bodySmall, color = colors.errorText)
    }
}
