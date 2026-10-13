package com.djtech.monai.feature.quickadd.presentation.quickadd

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.pluralStringResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.feature.quickadd.presentation.quickadd.components.QuickAddDraftList
import com.djtech.monai.feature.quickadd.presentation.quickadd.components.QuickAddEngineLine
import com.djtech.monai.feature.quickadd.presentation.quickadd.components.QuickAddExamples
import com.djtech.monai.feature.quickadd.presentation.quickadd.components.QuickAddFallbackBanner
import com.djtech.monai.feature.quickadd.presentation.quickadd.components.QuickAddInput
import com.djtech.monai.feature.quickadd.presentation.quickadd.preview.QuickAddPreviewData

/**
 * @param onOpenForm one draft: open the add form prefilled with it.
 * @param onOpenReview several drafts from [String] (the phrase): review them one by one.
 */
@Composable
fun QuickAddRoute(
    onClose: () -> Unit,
    onOpenForm: (TransactionDraft) -> Unit,
    onOpenReview: (String, List<TransactionDraft>) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: QuickAddViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            QuickAddEffect.Close -> onClose()
            is QuickAddEffect.OpenForm -> onOpenForm(effect.draft)
            is QuickAddEffect.OpenReview -> onOpenReview(effect.phrase, effect.drafts)
        }
    }
    QuickAddScreen(state, viewModel::onIntent, modifier)
}

@Composable
fun QuickAddScreen(
    state: QuickAddState,
    onIntent: (QuickAddIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    Column(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background)
            .navigationBarsPadding()
            .imePadding(),
    ) {
        MonAITopBar(
            title = stringResource(R.string.quick_add_title),
            navigation = MonAITopBarNavigation.Close,
            onNavigationClick = { onIntent(QuickAddIntent.Close) },
            navigationContentDescription = stringResource(R.string.quick_add_close),
            titleStyle = MonAITheme.typography.headlineSmall,
        )
        Column(
            Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = spacing.screenHorizontal),
            verticalArrangement = Arrangement.spacedBy(spacing.x4),
        ) {
            QuickAddInput(
                text = state.text,
                chips = state.chips,
                today = state.today,
                onTextChange = { onIntent(QuickAddIntent.TextChanged(it)) },
                onSubmit = { onIntent(QuickAddIntent.Submit) },
            )
            state.engineNote?.let { QuickAddEngineLine(it) }
            if (state.showFallback) QuickAddFallbackBanner()
            if (state.text.isBlank()) QuickAddExamples(onPick = { onIntent(QuickAddIntent.PickExample(it)) })
            if (state.drafts.isNotEmpty()) QuickAddDraftList(state.drafts, state.amountMissing, state.today)
        }
        Column(
            Modifier.padding(horizontal = spacing.screenHorizontal, vertical = spacing.x4),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(spacing.x2),
        ) {
            MonAIButton(
                text = if (state.isAsking) {
                    stringResource(R.string.quick_add_asking)
                } else {
                    val count = state.drafts.size.coerceAtLeast(1)
                    pluralStringResource(R.plurals.quick_add_review, count, count)
                },
                onClick = { onIntent(QuickAddIntent.Submit) },
                modifier = Modifier.fillMaxWidth(),
                trailingIcon = MonAIIcons.ArrowForward,
                enabled = state.text.isNotBlank(),
                loading = state.isAsking,
            )
            Text(
                stringResource(R.string.quick_add_footnote),
                style = MonAITheme.typography.bodySmall,
                color = MonAITheme.colors.textTertiary,
                textAlign = TextAlign.Center,
            )
        }
    }
}

@PreviewLightDark
@Composable
private fun QuickAddSinglePreview() {
    MonAITheme { QuickAddScreen(QuickAddPreviewData.single, onIntent = {}) }
}

@Preview
@Composable
private fun QuickAddEmptyPreview() {
    MonAITheme { QuickAddScreen(QuickAddPreviewData.empty, onIntent = {}) }
}

@Preview
@Composable
private fun QuickAddFallbackPreview() {
    MonAITheme { QuickAddScreen(QuickAddPreviewData.fallback, onIntent = {}) }
}
