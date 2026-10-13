package com.djtech.monai.feature.categories.presentation.categoryform.components

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAICategoryIcon
import com.djtech.monai.core.designsystem.icon.categoryIcon
import com.djtech.monai.core.designsystem.theme.CategoryColors
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryColorChoice
import com.djtech.monai.feature.categories.presentation.categoryform.model.CategoryIconChoice

/** How the category will look: the large icon, and the chip pickers will show. Decorative for TalkBack. */
@Composable
internal fun CategoryFormPreview(
    name: String,
    icon: CategoryIconChoice,
    color: CategoryColorChoice,
    modifier: Modifier = Modifier,
) {
    val vector = categoryIcon(icon.symbol)
    val tint = CategoryColors.parse(color.hex)
    Column(
        modifier
            .fillMaxWidth()
            .padding(vertical = MonAITheme.spacing.x1)
            .clearAndSetSemantics {},
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        MonAICategoryIcon(
            vector,
            tint,
            size = 72.dp,
            iconSize = 36.dp,
        )
        Row(
            Modifier
                .height(32.dp)
                .border(MonAITheme.sizes.border, MonAITheme.colors.border, CircleShape)
                .padding(start = MonAITheme.spacing.x1, end = MonAITheme.spacing.x3),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
        ) {
            MonAICategoryIcon(
                vector,
                tint,
                size = 24.dp,
                iconSize = MonAITheme.sizes.iconXs,
            )
            Text(
                name.ifBlank { stringResource(R.string.category_form_new_title) },
                style = MonAITheme.extendedTypography.bodyCompact,
                color = MonAITheme.colors.textPrimary,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        }
    }
}
