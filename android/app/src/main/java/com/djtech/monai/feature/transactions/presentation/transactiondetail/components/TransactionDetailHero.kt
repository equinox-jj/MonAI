package com.djtech.monai.feature.transactions.presentation.transactiondetail.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.component.MonAIAmountText
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MonAIDirectionPill
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.designsystem.theme.tabular
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.transactions.presentation.common.amountText
import com.djtech.monai.feature.transactions.presentation.common.direction
import com.djtech.monai.feature.transactions.presentation.common.iconAndColor
import com.djtech.monai.feature.transactions.presentation.common.label
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import com.djtech.monai.feature.transactions.presentation.common.title

/** Category icon, title, the signed amount and the direction pill. */
@Composable
internal fun TransactionDetailHero(
    transaction: Transaction,
    lookups: TransactionLookups,
    modifier: Modifier = Modifier,
) {
    val sizes = MonAITheme.sizes
    val (icon, color) = transaction.iconAndColor(lookups)
    Column(
        modifier
            .fillMaxWidth()
            .padding(vertical = MonAITheme.spacing.x2),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        MonAICategoryIcon(
            icon,
            color,
            size = 56.dp,
            iconSize = sizes.iconXl,
        )
        Text(
            transaction.title(lookups),
            style = MonAITheme.typography.titleMedium,
            color = MonAITheme.colors.textPrimary,
            textAlign = TextAlign.Center,
        )
        MonAIAmountText(
            transaction.amountText(),
            transaction.type.direction(),
            style = MonAITheme.typography.displaySmall.copy(
                letterSpacing = MonAITheme.typography.headlineMedium.letterSpacing,
            ).tabular(),
        )
        MonAIDirectionPill(transaction.type.label(), transaction.type.direction())
    }
}
