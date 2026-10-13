package com.djtech.monai.feature.receipt.presentation.scanreceipt.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
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
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.unit.dp
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAITextLink
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Gallery, the shutter and "Type instead" along the bottom of the camera. */
@Composable
internal fun ScanReceiptControls(
    canCapture: Boolean,
    onGallery: () -> Unit,
    onCapture: () -> Unit,
    onTypeInstead: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val shutterDescription = stringResource(R.string.scan_take_photo)
    val galleryDescription = stringResource(R.string.scan_gallery)
    Row(
        modifier
            .fillMaxWidth()
            .padding(start = MonAITheme.spacing.x6, end = MonAITheme.spacing.x6, bottom = MonAITheme.spacing.x10),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Box(Modifier.weight(1f)) {
            Icon(
                MonAIIcons.PhotoLibrary,
                galleryDescription,
                Modifier
                    .size(52.dp)
                    .clip(RoundedCornerShape(MonAITheme.radius.mdl))
                    .background(Color.White.copy(alpha = 0.08f))
                    .border(
                        MonAITheme.sizes.border,
                        Color.White.copy(alpha = 0.3f),
                        RoundedCornerShape(MonAITheme.radius.mdl),
                    )
                    .clickable(role = Role.Button, onClick = onGallery)
                    .padding(MonAITheme.spacing.x3_5),
                tint = Color.White,
            )
        }
        Box(
            Modifier
                .size(72.dp)
                .border(4.dp, Color.White, CircleShape)
                .padding(8.dp)
                .clip(CircleShape)
                .background(if (canCapture) Color.White else Color.White.copy(alpha = 0.4f))
                .clickable(enabled = canCapture, role = Role.Button, onClick = onCapture)
                .semantics { contentDescription = shutterDescription },
        )
        Box(Modifier.weight(1f), contentAlignment = Alignment.CenterEnd) {
            MonAITextLink(stringResource(R.string.scan_type_instead), onTypeInstead)
        }
    }
}

/** The pill telling where to put the receipt. */
@Composable
internal fun ScanReceiptHint(text: String, modifier: Modifier = Modifier) {
    Text(
        text,
        modifier
            .background(Color.Black.copy(alpha = 0.55f), CircleShape)
            .padding(horizontal = MonAITheme.spacing.x3_5, vertical = MonAITheme.spacing.x2),
        style = MonAITheme.typography.bodyMedium,
        color = Color.White,
    )
}

