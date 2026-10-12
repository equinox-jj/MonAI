package com.djtech.monai.core.designsystem.component

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsFocusedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
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
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.error
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

enum class MonAIFieldTone {
    Neutral,

    /** Red 2dp border, trailing error icon, red supporting text. */
    Error,

    /** Green supporting text with a check icon, e.g. "At least 8 characters". */
    Success,
}

/**
 * Filled text field: label above, gray fill, 12dp corners, 2dp indigo ring on focus.
 *
 * @param label shown above the field; pass null for label-less fields like the note input
 *   (then give [placeholder] or a [contentDescription]).
 * @param compact 48dp instead of 56dp, for secondary inputs like the note.
 */
@Composable
fun MonAITextField(
    value: String,
    onValueChange: (String) -> Unit,
    modifier: Modifier = Modifier,
    label: String? = null,
    placeholder: String? = null,
    leadingIcon: ImageVector? = null,
    trailing: (@Composable () -> Unit)? = null,
    supportingText: String? = null,
    tone: MonAIFieldTone = MonAIFieldTone.Neutral,
    compact: Boolean = false,
    enabled: Boolean = true,
    singleLine: Boolean = true,
    visualTransformation: VisualTransformation = VisualTransformation.None,
    keyboardOptions: KeyboardOptions = KeyboardOptions.Default,
    keyboardActions: KeyboardActions = KeyboardActions.Default,
    contentDescription: String? = null,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val spacing = MonAITheme.spacing
    val interaction = remember { MutableInteractionSource() }
    val focused by interaction.collectIsFocusedAsState()
    val shape = RoundedCornerShape(MonAITheme.radius.md)
    val isError = tone == MonAIFieldTone.Error
    val (borderWidth, borderColor) = when {
        isError -> sizes.borderFocused to colors.error
        focused -> sizes.borderFocused to colors.focus
        else -> sizes.border to colors.border
    }

    Column(modifier = modifier, verticalArrangement = Arrangement.spacedBy(spacing.fieldLabelGap)) {
        if (label != null) {
            Text(label, style = MonAITheme.typography.labelMedium, color = colors.textSecondary)
        }
        BasicTextField(
            value = value,
            onValueChange = onValueChange,
            modifier = Modifier
                .fillMaxWidth()
                .semantics {
                    if (contentDescription != null) this.contentDescription = contentDescription
                    if (isError && supportingText != null) error(supportingText)
                },
            enabled = enabled,
            singleLine = singleLine,
            textStyle = MonAITheme.typography.bodyLarge.copy(
                color = if (enabled) colors.textPrimary else colors.textDisabled,
            ),
            cursorBrush = SolidColor(colors.focus),
            visualTransformation = visualTransformation,
            keyboardOptions = keyboardOptions,
            keyboardActions = keyboardActions,
            interactionSource = interaction,
            decorationBox = { inner ->
                Row(
                    modifier = Modifier
                        .height(if (compact) sizes.inputCompact else sizes.input)
                        .clip(shape)
                        .background(colors.surfaceSunken)
                        .border(borderWidth, borderColor, shape)
                        .padding(
                            start = if (compact) spacing.x3 else spacing.x3_5,
                            end = if (trailing != null) spacing.x1 else spacing.x3_5,
                        ),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(if (compact) spacing.x2 else spacing.x2_5),
                ) {
                    if (leadingIcon != null) {
                        Icon(
                            leadingIcon,
                            null,
                            Modifier.size(sizes.iconLg),
                            tint = colors.textTertiary,
                        )
                    }
                    Box(Modifier.weight(1f), contentAlignment = Alignment.CenterStart) {
                        if (value.isEmpty() && placeholder != null) {
                            Text(
                                placeholder,
                                style = MonAITheme.typography.bodyLarge,
                                color = colors.textDisabled,
                                maxLines = 1,
                            )
                        }
                        inner()
                    }
                    when {
                        trailing != null -> trailing()
                        isError -> Icon(
                            MonAIIcons.Error,
                            null,
                            Modifier.size(sizes.iconLg),
                            tint = colors.error,
                        )
                    }
                }
            },
        )
        if (supportingText != null) {
            FieldSupportingText(supportingText, tone)
        }
    }
}

/** [MonAITextField] with a lock icon and a show/hide toggle. */
@Composable
fun MonAIPasswordField(
    value: String,
    onValueChange: (String) -> Unit,
    modifier: Modifier = Modifier,
    label: String? = null,
    supportingText: String? = null,
    tone: MonAIFieldTone = MonAIFieldTone.Neutral,
    showPasswordLabel: String = "Show password",
    hidePasswordLabel: String = "Hide password",
    keyboardOptions: KeyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
    keyboardActions: KeyboardActions = KeyboardActions.Default,
) {
    var visible by rememberSaveable { mutableStateOf(false) }
    MonAITextField(
        value = value,
        onValueChange = onValueChange,
        modifier = modifier,
        label = label,
        leadingIcon = MonAIIcons.Lock,
        trailing = {
            MonAIIconButton(
                icon = if (visible) MonAIIcons.VisibilityOff else MonAIIcons.Visibility,
                contentDescription = if (visible) hidePasswordLabel else showPasswordLabel,
                onClick = { visible = !visible },
                tint = MonAITheme.colors.textSecondary,
            )
        },
        supportingText = supportingText,
        tone = tone,
        visualTransformation = if (visible) VisualTransformation.None else PasswordVisualTransformation(),
        keyboardOptions = keyboardOptions,
        keyboardActions = keyboardActions,
    )
}

@Composable
private fun FieldSupportingText(text: String, tone: MonAIFieldTone) {
    val colors = MonAITheme.colors
    val color = when (tone) {
        MonAIFieldTone.Neutral -> colors.textTertiary
        MonAIFieldTone.Error -> colors.errorText
        MonAIFieldTone.Success -> colors.successText
    }
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5),
    ) {
        if (tone == MonAIFieldTone.Success) {
            Icon(
                MonAIIcons.CheckCircle,
                null,
                Modifier.size(MonAITheme.sizes.iconSm),
                tint = color,
            )
        }
        Text(text, style = MonAITheme.typography.bodySmall, color = color)
    }
}

/** Pill search input on a white surface (Transactions, search results, offline search). */
@Composable
fun MonAISearchField(
    value: String,
    onValueChange: (String) -> Unit,
    placeholder: String,
    modifier: Modifier = Modifier,
    keyboardActions: KeyboardActions = KeyboardActions.Default,
) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    val sizes = MonAITheme.sizes
    BasicTextField(
        value = value,
        onValueChange = onValueChange,
        modifier = modifier.fillMaxWidth(),
        singleLine = true,
        textStyle = MonAITheme.typography.bodyLarge.copy(color = colors.textPrimary),
        cursorBrush = SolidColor(colors.focus),
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Text),
        keyboardActions = keyboardActions,
        decorationBox = { inner ->
            PillFrame(height = sizes.searchField) {
                Icon(
                    MonAIIcons.Search,
                    null,
                    Modifier.size(sizes.iconLg),
                    tint = colors.textTertiary,
                )
                Box(Modifier.weight(1f), contentAlignment = Alignment.CenterStart) {
                    if (value.isEmpty()) {
                        Text(
                            placeholder,
                            style = MonAITheme.typography.bodyLarge,
                            color = colors.textTertiary,
                            maxLines = 1,
                        )
                    }
                    inner()
                }
                if (value.isNotEmpty()) {
                    MonAIIconButton(
                        icon = MonAIIcons.Close,
                        contentDescription = "Clear search",
                        onClick = { onValueChange("") },
                        size = sizes.buttonSmall,
                        iconSize = sizes.iconLg,
                        tint = colors.textTertiary,
                    )
                }
            }
        },
    )
}

/**
 * A pill that looks like an input but opens another screen: the Home search and quick-add
 * entries. [text] is placeholder-colored.
 */
@Composable
fun MonAIPillField(
    text: String,
    leadingIcon: ImageVector,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    leadingIconTint: Color = MonAITheme.colors.textTertiary,
    height: Dp = MonAITheme.sizes.searchField,
) {
    PillFrame(
        height = height,
        modifier = modifier
            .clip(CircleShape)
            .clickable(role = Role.Button, onClick = onClick),
    ) {
        Icon(
            leadingIcon,
            null,
            Modifier.size(MonAITheme.sizes.iconLg),
            tint = leadingIconTint,
        )
        Text(
            text,
            modifier = Modifier.weight(1f),
            style = MonAITheme.typography.bodyMedium,
            color = MonAITheme.colors.textTertiary,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
        )
    }
}

@Composable
private fun PillFrame(
    height: Dp,
    modifier: Modifier = Modifier,
    content: @Composable RowScope.() -> Unit,
) {
    val colors = MonAITheme.colors
    Row(
        modifier = modifier
            .fillMaxWidth()
            .height(height)
            .clip(CircleShape)
            .background(colors.surface)
            .border(MonAITheme.sizes.border, colors.borderStrong, CircleShape)
            .padding(start = MonAITheme.spacing.x4, end = MonAITheme.spacing.x1_5),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2_5),
        content = content,
    )
}

/**
 * Read-only field that opens a picker: wallet, date, transfer From/To.
 *
 * @param label small caption above [value] (transfer From/To); makes the field 56dp tall.
 */
@Composable
fun MonAISelectField(
    value: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    leadingIcon: ImageVector? = null,
    label: String? = null,
    showChevron: Boolean = false,
    enabled: Boolean = true,
) {
    val colors = MonAITheme.colors
    val sizes = MonAITheme.sizes
    val shape: Shape = RoundedCornerShape(MonAITheme.radius.md)
    Row(
        modifier = modifier
            .height(if (label != null) sizes.input else sizes.inputCompact)
            .clip(shape)
            .background(colors.surfaceSunken)
            .border(sizes.border, colors.border, shape)
            .clickable(enabled = enabled, role = Role.Button, onClick = onClick)
            .padding(horizontal = MonAITheme.spacing.x3),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2),
    ) {
        if (leadingIcon != null) {
            Icon(
                leadingIcon,
                null,
                Modifier.size(sizes.iconLg),
                tint = colors.accent,
            )
        }
        Column(Modifier.weight(1f)) {
            if (label != null) {
                Text(
                    label,
                    style = MonAITheme.typography.labelSmall.copy(fontWeight = FontWeight.Normal),
                    color = colors.textTertiary,
                )
            }
            Text(
                value,
                style = MonAITheme.typography.labelLarge,
                color = if (enabled) colors.textPrimary else colors.textDisabled,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        }
        if (showChevron) {
            Icon(
                MonAIIcons.ExpandMore,
                null,
                Modifier.size(sizes.iconMd),
                tint = colors.textTertiary,
            )
        }
    }
}

@PreviewLightDark
@Composable
private fun TextFieldPreview() {
    MonAITheme {
        Column(
            modifier = Modifier
                .background(MonAITheme.colors.surface)
                .padding(24.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            MonAITextField(
                value = "joshua@example.com",
                onValueChange = {},
                label = "Email",
                leadingIcon = MonAIIcons.Mail,
            )
            MonAITextField(
                value = "joshua@example.com",
                onValueChange = {},
                label = "Email",
                leadingIcon = MonAIIcons.Mail,
                tone = MonAIFieldTone.Error,
                supportingText = "This email already has an account.",
            )
            MonAIPasswordField(
                value = "secretpass",
                onValueChange = {},
                label = "Password",
                supportingText = "At least 8 characters",
                tone = MonAIFieldTone.Success,
            )
            MonAITextField(
                value = "",
                onValueChange = {},
                placeholder = "Add a note (optional)",
                leadingIcon = MonAIIcons.EditNote,
                compact = true,
            )
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                MonAISelectField(
                    "BCA Tabungan",
                    onClick = {},
                    leadingIcon = MonAIIcons.AccountBalance,
                    showChevron = true,
                    modifier = Modifier.weight(1f),
                )
                MonAISelectField(
                    "Today, 10 Oct",
                    onClick = {},
                    leadingIcon = MonAIIcons.CalendarToday,
                    modifier = Modifier.weight(1f),
                )
            }
            MonAISelectField("GoPay", onClick = {}, label = "To")
            MonAISearchField(
                value = "",
                onValueChange = {},
                placeholder = "Search note or merchant"
            )
            MonAIPillField(
                "makan siang 35rb pakai gopay",
                MonAIIcons.AutoAwesome,
                onClick = {},
                leadingIconTint = MonAITheme.colors.accent,
                height = 52.dp,
            )
        }
    }
}
