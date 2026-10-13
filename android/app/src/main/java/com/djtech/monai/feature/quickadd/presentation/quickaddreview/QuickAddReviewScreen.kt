package com.djtech.monai.feature.quickadd.presentation.quickaddreview

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.MonAIAmountEntrySheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAICategoryPickerSheet
import com.djtech.monai.core.designsystem.component.MonAIDatePickerSheet
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAIWalletPickerSheet
import com.djtech.monai.core.designsystem.component.MoneyDirection
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionDraft
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.quickadd.presentation.common.dayText
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.components.QuickAddReviewFields
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.components.QuickAddReviewHero
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.components.QuickAddReviewProgress
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.components.QuickAddReviewSummary
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSheet
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewWalletTarget
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.preview.QuickAddReviewPreviewData
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import kotlinx.coroutines.launch

/**
 * @param onBack back to quick add (also "Start over").
 * @param onFinish "Back to home" after the last draft.
 */
@Composable
fun QuickAddReviewRoute(
    phrase: String,
    drafts: List<TransactionDraft>,
    onBack: () -> Unit,
    onFinish: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: QuickAddReviewViewModel = hiltViewModel<QuickAddReviewViewModel, QuickAddReviewViewModel.Factory>(
        key = "review-$phrase-${drafts.hashCode()}",
    ) {
        it.create(phrase, drafts)
    },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            QuickAddReviewEffect.Back -> onBack()
            QuickAddReviewEffect.Finish -> onFinish()
            is QuickAddReviewEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    QuickAddReviewScreen(state, viewModel::onIntent, modifier, snackbarHostState)
}

@Composable
fun QuickAddReviewScreen(
    state: QuickAddReviewState,
    onIntent: (QuickAddReviewIntent) -> Unit,
    modifier: Modifier = Modifier,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.surface),
    ) {
        Column(
            Modifier
                .fillMaxSize()
                .navigationBarsPadding()
                .imePadding(),
        ) {
            MonAITopBar(
                title = stringResource(R.string.quick_add_review_title),
                onNavigationClick = { onIntent(QuickAddReviewIntent.Back) },
                navigationContentDescription = stringResource(R.string.quick_add_review_back),
            ) {
                Text(
                    if (state.isDone) {
                        stringResource(R.string.quick_add_review_done)
                    } else {
                        stringResource(R.string.quick_add_review_counter, state.index + 1, state.total)
                    },
                    Modifier.padding(end = spacing.x3),
                    style = MonAITheme.typography.labelMedium,
                    color = MonAITheme.colors.textSecondary,
                )
            }
            Column(
                Modifier
                    .weight(1f)
                    .verticalScroll(rememberScrollState())
                    .padding(horizontal = spacing.screenHorizontal),
                verticalArrangement = Arrangement.spacedBy(spacing.x4),
            ) {
                QuickAddReviewProgress(state.phrase, state.index, state.total)
                val draft = state.draft
                if (draft != null) {
                    QuickAddReviewHero(
                        type = draft.type,
                        amount = draft.amount,
                        category = state.category,
                        highlight = draft.highlights[TransactionField.AMOUNT] ?: FieldHighlight.None,
                        error = state.errors[TransactionField.AMOUNT]?.asString(),
                        onEditAmount = { onIntent(QuickAddReviewIntent.OpenAmount) },
                    )
                    QuickAddReviewFields(state, draft, onIntent)
                } else {
                    QuickAddReviewSummary(state.summary, state.savedCount, state.today)
                }
            }
            Actions(state, onIntent, Modifier.padding(horizontal = spacing.screenHorizontal, vertical = spacing.x4))
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    ReviewSheets(state, onIntent)
}

@Composable
private fun Actions(
    state: QuickAddReviewState,
    onIntent: (QuickAddReviewIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    Row(modifier, horizontalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x3)) {
        if (state.isDone) {
            MonAIButton(
                stringResource(R.string.quick_add_review_start_over),
                onClick = { onIntent(QuickAddReviewIntent.Back) },
                modifier = Modifier.weight(1f),
                variant = MonAIButtonVariant.Outlined,
            )
            MonAIButton(
                stringResource(R.string.quick_add_review_home),
                onClick = { onIntent(QuickAddReviewIntent.Finish) },
                modifier = Modifier.weight(2f),
            )
        } else {
            MonAIButton(
                stringResource(R.string.quick_add_review_skip),
                onClick = { onIntent(QuickAddReviewIntent.Skip) },
                modifier = Modifier.weight(1f),
                variant = MonAIButtonVariant.Outlined,
                enabled = !state.isSaving,
            )
            MonAIButton(
                stringResource(
                    if (state.isLast) R.string.quick_add_review_save else R.string.quick_add_review_save_next,
                ),
                onClick = { onIntent(QuickAddReviewIntent.Save) },
                modifier = Modifier.weight(2f),
                leadingIcon = MonAIIcons.Check,
                loading = state.isSaving,
            )
        }
    }
}

@Composable
private fun ReviewSheets(state: QuickAddReviewState, onIntent: (QuickAddReviewIntent) -> Unit) {
    val type = state.draft?.type ?: return
    val confirm = { onIntent(QuickAddReviewIntent.ConfirmSheet) }
    val dismiss = { onIntent(QuickAddReviewIntent.DismissSheet) }
    when (val sheet = state.sheet) {
        is ReviewSheet.Amount -> MonAIAmountEntrySheet(
            title = stringResource(R.string.ai_amount_title),
            amount = sheet.amount,
            onAmountChange = { onIntent(QuickAddReviewIntent.SheetAmount(it)) },
            onConfirm = confirm,
            onDismiss = dismiss,
        )

        is ReviewSheet.Category -> MonAICategoryPickerSheet(
            categories = state.categories,
            selectedId = sheet.selectedId,
            typeLabel = stringResource(
                if (type == TransactionType.INCOME) {
                    R.string.transaction_type_income
                } else {
                    R.string.transaction_type_expense
                },
            ),
            direction = if (type == TransactionType.INCOME) MoneyDirection.Income else MoneyDirection.Expense,
            onSelect = { onIntent(QuickAddReviewIntent.SheetPickCategory(it)) },
            onConfirm = confirm,
            onDismiss = dismiss,
        )

        is ReviewSheet.Wallet -> MonAIWalletPickerSheet(
            title = stringResource(
                when {
                    sheet.target == ReviewWalletTarget.DESTINATION -> R.string.transaction_picker_transfer_to
                    type == TransactionType.TRANSFER -> R.string.transaction_picker_transfer_from
                    type == TransactionType.INCOME -> R.string.transaction_picker_receive_into
                    else -> R.string.transaction_picker_pay_from
                },
            ),
            wallets = state.wallets,
            selectedId = sheet.selectedId,
            onSelect = { onIntent(QuickAddReviewIntent.SheetPickWallet(it)) },
            onConfirm = confirm,
            onDismiss = dismiss,
        )

        is ReviewSheet.Date -> MonAIDatePickerSheet(
            selected = sheet.selected,
            shownMonth = sheet.shownMonth,
            today = state.today,
            selectedLabel = dayText(sheet.selected, state.today),
            onSelect = { onIntent(QuickAddReviewIntent.SheetPickDate(it)) },
            onShowMonth = { onIntent(QuickAddReviewIntent.SheetShowMonth(it)) },
            onConfirm = confirm,
            onDismiss = dismiss,
        )

        null -> Unit
    }
}

@PreviewLightDark
@Composable
private fun QuickAddReviewPreview() {
    MonAITheme { QuickAddReviewScreen(QuickAddReviewPreviewData.reviewing, onIntent = {}) }
}

@Preview
@Composable
private fun QuickAddReviewDonePreview() {
    MonAITheme { QuickAddReviewScreen(QuickAddReviewPreviewData.done, onIntent = {}) }
}
