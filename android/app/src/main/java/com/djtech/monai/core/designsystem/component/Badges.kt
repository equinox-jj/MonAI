package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil3.compose.AsyncImage
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Small uppercase tag with 4dp corners: "ADMIN", "DEFAULT". */
@Composable
fun MonAITag(
    text: String,
    modifier: Modifier = Modifier,
    containerColor: Color = MonAITheme.colors.primaryContainer,
    contentColor: Color = MonAITheme.colors.onPrimaryContainer,
) {
    Text(
        text = text.uppercase(),
        modifier = modifier
            .clip(RoundedCornerShape(MonAITheme.radius.xs))
            .background(containerColor)
            .padding(horizontal = MonAITheme.spacing.x1_5, vertical = MonAITheme.spacing.x0_5),
        style = MonAITheme.typography.labelSmall.copy(letterSpacing = 0.5.sp),
        color = contentColor,
    )
}

/**
 * Rounded pill with optional icon. Defaults to the lime highlight used on gradients
 * ("Default", "10% less spent than September").
 */
@Composable
fun MonAIPill(
    text: String,
    modifier: Modifier = Modifier,
    icon: ImageVector? = null,
    containerColor: Color = MonAITheme.colors.highlight,
    contentColor: Color = MonAITheme.colors.onHighlight,
) {
    Row(
        modifier = modifier
            .clip(CircleShape)
            .background(containerColor)
            .padding(horizontal = MonAITheme.spacing.x2_5, vertical = MonAITheme.spacing.x1),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        if (icon != null) Icon(
            icon,
            null,
            Modifier.size(MonAITheme.sizes.iconXs),
            tint = contentColor,
        )
        Text(text, style = MonAITheme.typography.labelMedium, color = contentColor)
    }
}

/** The Expense/Income pill under a transaction amount. */
@Composable
fun MonAIDirectionPill(text: String, direction: MoneyDirection, modifier: Modifier = Modifier) {
    val colors = MonAITheme.colors
    val (container, content) = when (direction) {
        MoneyDirection.Expense -> colors.expenseContainer to if (colors.isDark) colors.expense else colors.errorText
        MoneyDirection.Income -> colors.incomeContainer to if (colors.isDark) colors.income else colors.successText
        MoneyDirection.Transfer -> colors.primaryContainer to colors.onPrimaryContainer
    }
    MonAIPill(
        text,
        modifier,
        icon = direction.arrowIcon(),
        containerColor = container,
        contentColor = content,
    )
}

/**
 * Initials on a light-indigo circle, or the photo at [imageUrl] once it loads. The initials stay
 * while it loads and when it fails (presigned URLs expire). Font size scales with [size]
 * (44dp → 15sp, 64dp → 22sp).
 */
@Composable
fun MonAIAvatar(
    initials: String,
    modifier: Modifier = Modifier,
    size: Dp = MonAITheme.sizes.avatarLarge,
    imageUrl: String? = null,
) {
    Box(
        modifier = modifier
            .size(size)
            .clip(CircleShape)
            .background(MonAITheme.colors.primaryContainer),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = initials,
            style = MonAITheme.typography.titleMedium.copy(
                fontSize = (size.value * 0.34f).sp,
                lineHeight = (size.value * 0.34f).sp,
                fontWeight = FontWeight.Bold,
            ),
            color = MonAITheme.colors.accent,
        )
        if (imageUrl != null) {
            AsyncImage(
                model = imageUrl,
                contentDescription = null,
                modifier = Modifier.matchParentSize(),
                contentScale = ContentScale.Crop,
            )
        }
    }
}

/** Wallet/provider monogram ("BCA", "GP") on a circle. Default: white circle for gradients. */
@Composable
fun MonAIMonogram(
    text: String,
    modifier: Modifier = Modifier,
    containerColor: Color = Color.White,
    contentColor: Color = MonAITheme.colors.heroGradientStart,
    size: Dp = MonAITheme.sizes.avatarMedium,
) {
    Box(
        modifier = modifier
            .size(size)
            .clip(CircleShape)
            .background(containerColor),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = text,
            style = MonAITheme.typography.labelSmall.copy(
                fontSize = 10.sp,
                lineHeight = 12.sp,
                fontWeight = FontWeight.ExtraBold,
            ),
            color = contentColor,
            maxLines = 1,
        )
    }
}

@PreviewLightDark
@Composable
private fun BadgesPreview() {
    MonAITheme {
        Column(
            Modifier
                .background(MonAITheme.colors.surface)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            Row(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                MonAITag("Admin")
                MonAIPill("Default")
                MonAIDirectionPill("Expense", MoneyDirection.Expense)
                MonAIDirectionPill("Income", MoneyDirection.Income)
            }
            Row(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                MonAIAvatar("JP")
                MonAIAvatar("JP", size = 64.dp)
                MonAIMonogram(
                    "BCA",
                    containerColor = MonAITheme.colors.primary,
                    contentColor = Color.White,
                )
                MonAIPill("Cash", icon = MonAIIcons.Check)
            }
        }
    }
}
