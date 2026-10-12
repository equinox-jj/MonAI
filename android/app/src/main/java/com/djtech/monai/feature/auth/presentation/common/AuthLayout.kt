package com.djtech.monai.feature.auth.presentation.common

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalWindowInfo
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAITextLink
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** Material's expanded breakpoint: from here the auth screens use the two-pane tablet layout. */
private val ExpandedMinWidth = 840.dp

/** The phone form's width cap (tablet portrait) and the tablet form card's width. */
private val FormWidth = 480.dp

private val LogoTileSize = 56.dp
private val LogoIconSize = 30.dp
private val TabletSubmitMinWidth = 160.dp

/** Whether the window is wide enough for the two-pane auth layout. Read like MainShell's breakpoints. */
@Composable
internal fun isExpandedAuthWidth(): Boolean {
    val width = with(LocalDensity.current) { LocalWindowInfo.current.containerSize.width.toDp() }
    return width >= ExpandedMinWidth
}

/**
 * Frame shared by Sign in and Register.
 *
 * Sign in and Register are the root of the auth graph, so neither has a back button.
 *
 * Phone: [form] at the top and [actions] pinned to the bottom, scrolling together
 * when the keyboard leaves too little room. Expanded: the gradient hero on the left and [form] plus
 * [actions] in a card on the right.
 */
@Composable
internal fun AuthScaffold(
    expanded: Boolean,
    modifier: Modifier = Modifier,
    form: @Composable ColumnScope.() -> Unit,
    actions: @Composable () -> Unit,
) {
    if (expanded) {
        ExpandedAuthScaffold(modifier, form, actions)
    } else {
        CompactAuthScaffold(modifier, form, actions)
    }
}

@Composable
private fun CompactAuthScaffold(
    modifier: Modifier,
    form: @Composable ColumnScope.() -> Unit,
    actions: @Composable () -> Unit,
) {
    val spacing = MonAITheme.spacing
    BoxWithConstraints(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.surface)
            .safeDrawingPadding(),
        contentAlignment = Alignment.TopCenter,
    ) {
        // A min height of the viewport lets SpaceBetween push the actions to the bottom while
        // the column can still grow and scroll past it.
        Column(
            Modifier
                .widthIn(max = FormWidth)
                .fillMaxWidth()
                .verticalScroll(rememberScrollState())
                .heightIn(min = maxHeight)
                .padding(
                    start = spacing.screenHorizontalWide,
                    end = spacing.screenHorizontalWide,
                    top = spacing.x4,
                    bottom = spacing.x8,
                ),
            verticalArrangement = Arrangement.SpaceBetween,
        ) {
            Column(verticalArrangement = Arrangement.spacedBy(spacing.x5), content = form)
            Box(Modifier.padding(top = spacing.x5)) { actions() }
        }
    }
}

@Composable
private fun ExpandedAuthScaffold(
    modifier: Modifier,
    form: @Composable ColumnScope.() -> Unit,
    actions: @Composable () -> Unit,
) {
    val colors = MonAITheme.colors
    val spacing = MonAITheme.spacing
    val cardShape = RoundedCornerShape(MonAITheme.radius.xxl)
    Row(
        modifier
            .fillMaxSize()
            .background(colors.background),
    ) {
        AuthHeroPanel(
            Modifier
                .weight(1f)
                .fillMaxHeight(),
        )
        Box(
            Modifier
                .weight(1f)
                .fillMaxHeight()
                .safeDrawingPadding()
                .verticalScroll(rememberScrollState())
                .padding(spacing.x8),
            contentAlignment = Alignment.Center,
        ) {
            Column(
                Modifier
                    .width(FormWidth)
                    .clip(cardShape)
                    .background(colors.surface)
                    .border(MonAITheme.sizes.border, colors.border, cardShape)
                    .padding(spacing.x10),
                verticalArrangement = Arrangement.spacedBy(spacing.x5),
            ) {
                form()
                Box(Modifier.padding(top = spacing.x2)) { actions() }
            }
        }
    }
}

/** The 56dp gradient wallet tile above the Sign in title (phone only). */
@Composable
internal fun AuthLogoTile(modifier: Modifier = Modifier) {
    Box(
        modifier
            .size(LogoTileSize)
            .clip(RoundedCornerShape(MonAITheme.radius.xl))
            .background(MonAITheme.colors.heroGradient),
        contentAlignment = Alignment.Center,
    ) {
        Icon(
            MonAIIcons.AccountBalanceWallet,
            contentDescription = null,
            modifier = Modifier.size(LogoIconSize),
            tint = MonAITheme.colors.highlight,
        )
    }
}

@Composable
internal fun AuthHeader(
    title: String,
    subtitle: String,
    modifier: Modifier = Modifier,
) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x1_5)) {
        Text(
            title,
            Modifier.semantics { heading() },
            style = MonAITheme.typography.headlineLarge,
            color = MonAITheme.colors.textPrimary,
        )
        Text(
            subtitle,
            style = MonAITheme.typography.titleSmall.copy(fontWeight = FontWeight.Normal),
            color = MonAITheme.colors.textSecondary,
        )
    }
}

/**
 * The submit button and the link to the other auth screen. Phone: full-width button over a centred
 * "New here? Create an account". Expanded: the link on the left, a compact button on the right.
 */
@Composable
internal fun AuthActions(
    expanded: Boolean,
    submitLabel: String,
    onSubmit: () -> Unit,
    loading: Boolean,
    prompt: String,
    linkLabel: String,
    onLinkClick: () -> Unit,
) {
    val spacing = MonAITheme.spacing
    if (expanded) {
        Row(
            Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            MonAITextLink(linkLabel, onLinkClick)
            MonAIButton(
                submitLabel,
                onSubmit,
                Modifier.widthIn(min = TabletSubmitMinWidth),
                size = MonAIButtonSize.Medium,
                loading = loading,
            )
        }
    } else {
        Column(verticalArrangement = Arrangement.spacedBy(spacing.x3)) {
            MonAIButton(
                submitLabel,
                onSubmit,
                Modifier.fillMaxWidth(),
                loading = loading,
            )
            Row(
                Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(
                    spacing.x1,
                    Alignment.CenterHorizontally
                ),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text(
                    prompt,
                    style = MonAITheme.typography.bodyMedium,
                    color = MonAITheme.colors.textSecondary
                )
                MonAITextLink(linkLabel, onLinkClick)
            }
        }
    }
}
