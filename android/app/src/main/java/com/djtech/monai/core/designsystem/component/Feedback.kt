package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.SheetState
import androidx.compose.material3.SnackbarData
import androidx.compose.material3.SnackbarDuration
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SnackbarVisuals
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.paneTitle
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

enum class MonAIAlertTone { Info, Success, Warning, Error }

private data class ToneColors(
    val container: Color,
    val border: Color?,
    val icon: Color,
    val content: Color,
)

@Composable
private fun MonAIAlertTone.colors(): ToneColors {
    val c = MonAITheme.colors
    return when (this) {
        MonAIAlertTone.Info -> ToneColors(
            c.primaryContainer,
            null,
            c.accent,
            c.onPrimaryContainer,
        )

        MonAIAlertTone.Success -> ToneColors(
            c.incomeContainer,
            null,
            c.success,
            c.successText,
        )

        MonAIAlertTone.Warning -> ToneColors(
            c.warningContainer,
            c.warningContainerBorder,
            c.warning,
            c.onWarningContainer,
        )

        MonAIAlertTone.Error -> ToneColors(
            c.errorContainer,
            c.errorContainerBorder,
            c.error,
            c.onErrorContainer,
        )
    }
}

@Composable
private fun MonAIAlertTone.defaultIcon(): ImageVector = when (this) {
    MonAIAlertTone.Info -> MonAIIcons.AutoAwesome
    MonAIAlertTone.Success -> MonAIIcons.CheckCircle
    MonAIAlertTone.Warning -> MonAIIcons.Warning
    MonAIAlertTone.Error -> MonAIIcons.Error
}

/** Inline message box, e.g. the sign-in error or the "We'll set up a Cash wallet" note. */
@Composable
fun MonAIInlineAlert(
    message: String,
    modifier: Modifier = Modifier,
    tone: MonAIAlertTone = MonAIAlertTone.Info,
    icon: ImageVector = tone.defaultIcon(),
) {
    val t = tone.colors()
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    Row(
        modifier = modifier
            .fillMaxWidth()
            .clip(shape)
            .background(t.container)
            .then(
                if (t.border != null) Modifier.border(
                    MonAITheme.sizes.border,
                    t.border,
                    shape,
                ) else Modifier,
            )
            .padding(MonAITheme.spacing.x3)
            .semantics { if (tone == MonAIAlertTone.Error) liveRegion = LiveRegionMode.Assertive },
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5),
    ) {
        Icon(
            icon,
            null,
            Modifier.size(MonAITheme.sizes.iconLg),
            tint = t.icon,
        )
        Text(message, style = MonAITheme.extendedTypography.bodyCompact, color = t.content)
    }
}

/** Full-width 40dp strip under a screen title: "**You're offline** · Showing saved data". */
@Composable
fun MonAIStatusStrip(
    title: String,
    modifier: Modifier = Modifier,
    detail: String? = null,
    icon: ImageVector = MonAIIcons.CloudOff,
    tone: MonAIAlertTone = MonAIAlertTone.Warning,
) {
    val t = tone.colors()
    val borderColor = t.border ?: t.container
    Column(modifier.fillMaxWidth()) {
        Box(
            Modifier
                .fillMaxWidth()
                .height(MonAITheme.sizes.border)
                .background(borderColor),
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .height(40.dp)
                .background(t.container)
                .padding(horizontal = MonAITheme.spacing.x4)
                .semantics { liveRegion = LiveRegionMode.Polite },
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
        ) {
            Icon(
                icon,
                null,
                Modifier.size(MonAITheme.sizes.iconMd),
                tint = t.icon,
            )
            Text(
                text = buildAnnotatedString {
                    withStyle(SpanStyle(fontWeight = FontWeight.SemiBold)) { append(title) }
                    if (detail != null) append(" · $detail")
                },
                style = MonAITheme.extendedTypography.bodyCompact,
                color = t.content,
            )
        }
        Box(
            Modifier
                .fillMaxWidth()
                .height(MonAITheme.sizes.border)
                .background(borderColor),
        )
    }
}

/** Dark floating message with an optional leading icon and action ("Undo"). */
@Composable
fun MonAISnackbar(
    message: String,
    modifier: Modifier = Modifier,
    icon: ImageVector? = null,
    iconTint: Color = MonAITheme.colors.warning,
    actionLabel: String? = null,
    onAction: () -> Unit = {},
) {
    val colors = MonAITheme.colors
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    Row(
        modifier = modifier
            .fillMaxWidth()
            .shadow(12.dp, shape)
            .clip(shape)
            .background(colors.inverseSurface)
            .padding(
                start = MonAITheme.spacing.x3_5,
                end = if (actionLabel != null) MonAITheme.spacing.x1_5 else MonAITheme.spacing.x3_5,
                top = if (actionLabel != null) MonAITheme.spacing.x1_5 else MonAITheme.spacing.x3,
                bottom = if (actionLabel != null) MonAITheme.spacing.x1_5 else MonAITheme.spacing.x3,
            ),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5),
    ) {
        if (icon != null) Icon(
            icon,
            null,
            Modifier.size(MonAITheme.sizes.iconLg),
            tint = iconTint,
        )
        Text(
            message,
            Modifier.weight(1f),
            style = MonAITheme.typography.bodyMedium,
            color = colors.onInverseSurface,
        )
        if (actionLabel != null) {
            TextButton(
                onClick = onAction,
                shape = RoundedCornerShape(MonAITheme.radius.sm),
                modifier = Modifier.height(MonAITheme.sizes.touchTarget),
            ) {
                Text(
                    actionLabel,
                    style = MonAITheme.typography.labelLarge.copy(fontWeight = FontWeight.Bold),
                    color = colors.inverseAccent,
                )
            }
        }
    }
}

/**
 * [SnackbarVisuals] that also carries an icon, for [MonAISnackbarHost]. [iconTint] defaults to
 * the warning amber; pass e.g. the success green for a confirmation.
 */
data class MonAISnackbarVisuals(
    override val message: String,
    override val actionLabel: String? = null,
    val icon: ImageVector? = null,
    val iconTint: Color = Color.Unspecified,
    override val withDismissAction: Boolean = false,
    override val duration: SnackbarDuration =
        if (actionLabel == null) SnackbarDuration.Short else SnackbarDuration.Long,
) : SnackbarVisuals

/**
 * Renders [SnackbarHostState] messages as [MonAISnackbar] at [snackbarPlacement]. Routes show them with
 * [rememberMonAIMessenger]; [MonAISnackbarVisuals] carries the icon. A screen with controls pinned to
 * its bottom passes an [anchor] so the snackbar sits above them.
 */
@Composable
fun MonAISnackbarHost(
    hostState: SnackbarHostState,
    modifier: Modifier = Modifier,
    anchor: SnackbarAnchor? = null,
) {
    SnackbarHost(hostState, modifier.snackbarPlacement(anchor)) { data: SnackbarData ->
        val visuals = data.visuals as? MonAISnackbarVisuals
        MonAISnackbar(
            message = data.visuals.message,
            icon = visuals?.icon,
            iconTint = visuals?.iconTint?.takeIf { it != Color.Unspecified } ?: MonAITheme.colors.warning,
            actionLabel = data.visuals.actionLabel,
            onAction = data::performAction,
        )
    }
}

/**
 * Where a snackbar sits at the bottom of the screen: within the side margins, 20dp above the system
 * navigation bar or the keyboard, or above the controls marked for [anchor]. Content above a bar that
 * already clears the navigation bar (the tab shell's bottom bar) consumes those insets, so the snackbar
 * keeps just the 20dp above that bar.
 */
fun Modifier.snackbarPlacement(anchor: SnackbarAnchor? = null): Modifier = composed {
    val clearance = if (anchor?.hasControls == true) {
        Modifier.liftAboveSnackbarAnchor(anchor)
    } else {
        Modifier
            .navigationBarsPadding()
            .imePadding()
    }
    (if (anchor != null) trackSnackbarAnchor(anchor) else this)
        .then(clearance)
        .padding(horizontal = MonAITheme.spacing.screenHorizontal)
        .padding(bottom = MonAITheme.spacing.x5)
}

/**
 * Centered 312dp dialog: tone icon, title, body, optional extra content, then
 * dismiss + confirm buttons aligned to the end.
 */
@Composable
fun MonAIAlertDialog(
    title: String,
    message: String,
    confirmLabel: String,
    onConfirm: () -> Unit,
    onDismissRequest: () -> Unit,
    modifier: Modifier = Modifier,
    dismissLabel: String? = null,
    icon: ImageVector? = null,
    tone: MonAIAlertTone = MonAIAlertTone.Warning,
    destructive: Boolean = false,
    properties: DialogProperties = DialogProperties(),
    content: (@Composable ColumnScope.() -> Unit)? = null,
) {
    val colors = MonAITheme.colors
    Dialog(onDismissRequest = onDismissRequest, properties = properties) {
        Column(
            modifier = modifier
                .width(MonAITheme.sizes.dialogWidth)
                .clip(RoundedCornerShape(MonAITheme.radius.xxl))
                .background(colors.surface)
                .padding(MonAITheme.spacing.x6)
                .semantics { paneTitle = title },
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3_5),
        ) {
            if (icon != null) {
                val t = tone.colors()
                Box(
                    Modifier
                        .size(MonAITheme.sizes.dialogIcon)
                        .clip(CircleShape)
                        .background(t.container),
                    contentAlignment = Alignment.Center,
                ) { Icon(icon, null, tint = t.icon) }
            }
            Text(title, style = MonAITheme.typography.headlineSmall, color = colors.textPrimary)
            Text(message, style = MonAITheme.typography.bodyMedium, color = colors.textSecondary)
            content?.invoke(this)
            Row(
                Modifier
                    .fillMaxWidth()
                    .padding(top = MonAITheme.spacing.x1),
                horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2, Alignment.End),
            ) {
                if (dismissLabel != null) {
                    MonAIButton(
                        dismissLabel,
                        onDismissRequest,
                        variant = MonAIButtonVariant.Text,
                        size = MonAIButtonSize.Compact,
                    )
                }
                // A lone action spans the dialog, as in "Session expired".
                val single = dismissLabel == null
                MonAIButton(
                    confirmLabel,
                    onConfirm,
                    modifier = if (single) Modifier.weight(1f) else Modifier,
                    variant = if (destructive) MonAIButtonVariant.Destructive else MonAIButtonVariant.Primary,
                    size = if (single) MonAIButtonSize.Medium else MonAIButtonSize.Compact,
                )
            }
        }
    }
}

/**
 * Modal bottom sheet with the design's 24dp top corners, 32×4 handle, 24dp side padding and
 * optional title.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MonAIBottomSheet(
    onDismissRequest: () -> Unit,
    modifier: Modifier = Modifier,
    title: String? = null,
    sheetState: SheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true),
    content: @Composable ColumnScope.() -> Unit,
) {
    val colors = MonAITheme.colors
    ModalBottomSheet(
        onDismissRequest = onDismissRequest,
        modifier = modifier,
        sheetState = sheetState,
        shape = RoundedCornerShape(
            topStart = MonAITheme.radius.xxl,
            topEnd = MonAITheme.radius.xxl,
        ),
        containerColor = colors.surface,
        contentColor = colors.textPrimary,
        scrimColor = colors.scrim,
        dragHandle = {
            Box(
                Modifier
                    .padding(top = MonAITheme.spacing.x3, bottom = MonAITheme.spacing.x0_5)
                    .size(MonAITheme.sizes.sheetHandleWidth, MonAITheme.sizes.sheetHandleHeight)
                    .clip(CircleShape)
                    .background(colors.borderStrong),
            )
        },
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = MonAITheme.spacing.screenHorizontalWide)
                .padding(top = MonAITheme.spacing.x3, bottom = MonAITheme.spacing.x6)
                .navigationBarsPadding(),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3_5),
        ) {
            if (title != null) {
                Text(title, style = MonAITheme.typography.headlineSmall, color = colors.textPrimary)
            }
            content()
        }
    }
}

@PreviewLightDark
@Composable
private fun FeedbackPreview() {
    MonAITheme {
        Column(
            Modifier
                .background(MonAITheme.colors.background)
                .padding(vertical = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            MonAIStatusStrip("You're offline", detail = "Showing saved data")
            Column(
                Modifier.padding(horizontal = 16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                MonAIInlineAlert(
                    "Email or password is incorrect. Check them and try again.",
                    tone = MonAIAlertTone.Error,
                )
                MonAIInlineAlert("We'll set up a Cash wallet and starter categories for you.")
                MonAISnackbar("Connect to the internet to add or edit.", icon = MonAIIcons.CloudOff)
                MonAISnackbar("Transaction deleted", actionLabel = "Undo")
            }
        }
    }
}
