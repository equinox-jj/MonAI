package com.djtech.monai.feature.auth.presentation.common

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.common.format.MoneySign
import com.djtech.monai.core.common.format.formatRupiahSigned
import com.djtech.monai.core.designsystem.component.MonAIAmountText
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.component.MoneyDirection
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme

// Cards drawn on the auth illustrations: the onboarding pages and the tablet auth hero.

/** The sample expense's category color: the server's default Food hex. */
internal val SampleFoodColor = CategoryColors.parse("#F97316")

private const val SampleExpense = 35_000L
private val IllustrationElevation = 12.dp

/** A white card floating on the gradient. */
@Composable
internal fun AuthIllustrationCard(
    shape: Shape,
    modifier: Modifier = Modifier,
    contentPadding: PaddingValues = PaddingValues(
        horizontal = MonAITheme.spacing.x4,
        vertical = MonAITheme.spacing.x3_5,
    ),
    content: @Composable () -> Unit,
) {
    Surface(
        modifier = modifier.fillMaxWidth(),
        shape = shape,
        color = MonAITheme.colors.surface,
        contentColor = MonAITheme.colors.textPrimary,
        shadowElevation = IllustrationElevation,
    ) {
        Box(Modifier.padding(contentPadding)) { content() }
    }
}

/** Icon, text and trailing content in a row, for the cards' content. */
@Composable
internal fun AuthIllustrationRow(content: @Composable RowScope.() -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3),
        content = content,
    )
}

/** The sample quick-add sentence. Shared by the onboarding hero and the tablet auth hero. */
@Composable
internal fun AuthSamplePromptCard(modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    AuthIllustrationCard(
        CircleShape,
        modifier = modifier,
        contentPadding = PaddingValues(horizontal = spacing.x4, vertical = spacing.x3),
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(spacing.x2_5),
        ) {
            Icon(
                MonAIIcons.AutoAwesome,
                null,
                Modifier.size(MonAITheme.sizes.iconLg),
                tint = colors.accent,
            )
            Text(
                stringResource(R.string.onboarding_sample_prompt),
                style = MonAITheme.typography.bodyMedium.copy(fontWeight = FontWeight.Medium),
                color = colors.iconStrong,
            )
        }
    }
}

/** The expense the sample sentence becomes. Shared by the onboarding hero and the tablet auth hero. */
@Composable
internal fun AuthSampleExpenseCard(modifier: Modifier = Modifier) {
    AuthIllustrationCard(RoundedCornerShape(MonAITheme.radius.xl), modifier = modifier) {
        AuthIllustrationRow {
            MonAICategoryIcon(MonAIIcons.Restaurant, SampleFoodColor)
            Column(Modifier.weight(1f)) {
                Text(
                    stringResource(R.string.onboarding_sample_title),
                    style = MonAITheme.typography.titleSmall.copy(fontWeight = FontWeight.SemiBold),
                )
                Text(
                    stringResource(R.string.onboarding_sample_meta),
                    style = MonAITheme.typography.bodySmall,
                    color = MonAITheme.colors.textTertiary,
                )
            }
            MonAIAmountText(
                formatRupiahSigned(SampleExpense, MoneySign.Negative),
                MoneyDirection.Expense,
            )
        }
    }
}
