package com.djtech.monai.feature.receipt.presentation.receiptreview

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import coil3.compose.AsyncImage
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.MonAIAmountEntrySheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAICategoryPickerSheet
import com.djtech.monai.core.designsystem.component.MonAIDatePickerSheet
import com.djtech.monai.core.designsystem.component.MonAISegmentedControl
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAITextField
import com.djtech.monai.core.designsystem.component.MonAITextLink
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAIWalletPickerSheet
import com.djtech.monai.core.designsystem.component.MonAIWidthClass
import com.djtech.monai.core.designsystem.component.MoneyDirection
import com.djtech.monai.core.designsystem.component.currentLocale
import com.djtech.monai.core.designsystem.component.currentWidthClass
import com.djtech.monai.core.designsystem.component.rememberMonAIMessenger
import com.djtech.monai.core.designsystem.component.rememberSnackbarAnchor
import com.djtech.monai.core.designsystem.component.snackbarAnchor
import com.djtech.monai.core.designsystem.component.transactionTypeSegments
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.receipt.presentation.receiptreview.components.ReceiptReviewAmount
import com.djtech.monai.feature.receipt.presentation.receiptreview.components.ReceiptReviewBanner
import com.djtech.monai.feature.receipt.presentation.receiptreview.components.ReceiptReviewFields
import com.djtech.monai.feature.receipt.presentation.receiptreview.components.ReceiptReviewItems
import com.djtech.monai.feature.receipt.presentation.receiptreview.model.ReceiptSheet
import com.djtech.monai.feature.receipt.presentation.receiptreview.preview.ReceiptReviewPreviewData
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import java.time.format.DateTimeFormatter
import kotlin.math.roundToInt

/**
 * @param onSaved the transaction was saved with its photo; its id.
 * @param onRetake back to the camera for another photo.
 */
@Composable
fun ReceiptReviewRoute(
    photoUri: String,
    receipt: ReceiptDraft,
    aiFailed: Boolean,
    onBack: () -> Unit,
    onRetake: () -> Unit,
    onSaved: (String) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: ReceiptReviewViewModel = hiltViewModel<ReceiptReviewViewModel, ReceiptReviewViewModel.Factory>(
        key = "receipt-$photoUri",
    ) {
        it.create(photoUri, receipt, aiFailed)
    },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val messenger = rememberMonAIMessenger()
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is ReceiptReviewEffect.Saved -> onSaved(effect.id)
            ReceiptReviewEffect.Retake -> onRetake()
            ReceiptReviewEffect.Back -> onBack()
            is ReceiptReviewEffect.ShowMessage -> messenger.show(effect.message)
        }
    }
    ReceiptReviewScreen(state, viewModel::onIntent, modifier, messenger.hostState)
}

@Composable
fun ReceiptReviewScreen(
    state: ReceiptReviewState,
    onIntent: (ReceiptReviewIntent) -> Unit,
    modifier: Modifier = Modifier,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
    val snackbarAnchor = rememberSnackbarAnchor()
    // On a wide screen the photo sits beside the form, as on the tablet artboard.
    val wide = currentWidthClass() == MonAIWidthClass.Expanded
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
                title = stringResource(R.string.receipt_review_title),
                onNavigationClick = { onIntent(ReceiptReviewIntent.Back) },
                navigationContentDescription = stringResource(R.string.receipt_review_back),
            ) {
                MonAITextLink(
                    stringResource(R.string.receipt_review_retake),
                    { onIntent(ReceiptReviewIntent.Retake) },
                    Modifier.padding(end = spacing.x3),
                )
            }
            Row(Modifier.weight(1f), horizontalArrangement = Arrangement.spacedBy(spacing.x6)) {
                if (wide) {
                    AsyncImage(
                        state.photoUri,
                        stringResource(R.string.receipt_review_photo),
                        Modifier
                            .weight(1f)
                            .fillMaxHeight()
                            .padding(start = spacing.screenHorizontalWide, bottom = spacing.x4)
                            .clip(RoundedCornerShape(MonAITheme.radius.lg))
                            .background(MonAITheme.colors.surfaceSunken),
                        contentScale = ContentScale.Fit,
                    )
                }
                FormColumn(state, onIntent, wide, Modifier.weight(1f))
            }
            MonAIButton(
                text = state.uploadProgress?.let {
                    stringResource(R.string.receipt_review_uploading, (it * 100).roundToInt())
                } ?: stringResource(
                    if (state.type == TransactionType.INCOME) {
                        R.string.transaction_form_save_income
                    } else {
                        R.string.transaction_form_save_expense
                    },
                ),
                onClick = { onIntent(ReceiptReviewIntent.Save) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = spacing.screenHorizontal, vertical = spacing.x4)
                    .snackbarAnchor(snackbarAnchor),
                leadingIcon = MonAIIcons.Check,
                loading = state.isSaving,
            )
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter), snackbarAnchor)
    }
    ReviewSheets(state, onIntent)
}

@Composable
private fun FormColumn(
    state: ReceiptReviewState,
    onIntent: (ReceiptReviewIntent) -> Unit,
    wide: Boolean,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    val types = listOf(TransactionType.EXPENSE, TransactionType.INCOME)
    Column(
        modifier
            .verticalScroll(rememberScrollState())
            .padding(horizontal = if (wide) spacing.screenHorizontalWide else spacing.screenHorizontal),
        verticalArrangement = Arrangement.spacedBy(spacing.x3_5),
    ) {
        ReceiptReviewBanner(state.photoUri, state.aiFailed, showThumbnail = !wide)
        MonAISegmentedControl(
            segments = transactionTypeSegments(
                stringResource(R.string.transaction_type_expense),
                stringResource(R.string.transaction_type_income),
                stringResource(R.string.transaction_type_transfer),
            ).take(2),
            selectedIndex = types.indexOf(state.type),
            onSelect = { onIntent(ReceiptReviewIntent.SelectType(types[it])) },
        )
        ReceiptReviewAmount(
            type = state.type,
            amount = state.amount,
            highlight = state.highlights[TransactionField.AMOUNT] ?: FieldHighlight.None,
            error = state.errors[TransactionField.AMOUNT]?.asString(),
            onClick = { onIntent(ReceiptReviewIntent.OpenAmount) },
        )
        ReceiptReviewFields(state, onIntent)
        if (state.items.isNotEmpty()) ReceiptReviewItems(state.items, state.amount)
        MonAITextField(
            value = state.note,
            onValueChange = { onIntent(ReceiptReviewIntent.NoteChanged(it)) },
            placeholder = stringResource(R.string.transaction_form_note_hint),
            leadingIcon = MonAIIcons.EditNote,
            supportingText = state.errors[TransactionField.NOTE]?.asString(),
            compact = true,
            contentDescription = stringResource(R.string.transaction_form_note),
        )
    }
}

@Composable
private fun ReviewSheets(state: ReceiptReviewState, onIntent: (ReceiptReviewIntent) -> Unit) {
    val confirm = { onIntent(ReceiptReviewIntent.ConfirmSheet) }
    val dismiss = { onIntent(ReceiptReviewIntent.DismissSheet) }
    val isIncome = state.type == TransactionType.INCOME
    when (val sheet = state.sheet) {
        is ReceiptSheet.Amount -> MonAIAmountEntrySheet(
            title = stringResource(R.string.ai_amount_title),
            amount = sheet.amount,
            onAmountChange = { onIntent(ReceiptReviewIntent.SheetAmount(it)) },
            onConfirm = confirm,
            onDismiss = dismiss,
        )

        is ReceiptSheet.Category -> MonAICategoryPickerSheet(
            categories = state.categories,
            selectedId = sheet.selectedId,
            typeLabel = stringResource(
                if (isIncome) R.string.transaction_type_income else R.string.transaction_type_expense,
            ),
            direction = if (isIncome) MoneyDirection.Income else MoneyDirection.Expense,
            onSelect = { onIntent(ReceiptReviewIntent.SheetPickCategory(it)) },
            onConfirm = confirm,
            onDismiss = dismiss,
        )

        is ReceiptSheet.Wallet -> MonAIWalletPickerSheet(
            title = stringResource(
                if (isIncome) R.string.transaction_picker_receive_into else R.string.transaction_picker_pay_from,
            ),
            wallets = state.wallets,
            selectedId = sheet.selectedId,
            onSelect = { onIntent(ReceiptReviewIntent.SheetPickWallet(it)) },
            onConfirm = confirm,
            onDismiss = dismiss,
        )

        is ReceiptSheet.Date -> MonAIDatePickerSheet(
            selected = sheet.selected,
            shownMonth = sheet.shownMonth,
            today = state.today,
            selectedLabel = sheet.selected.format(DateTimeFormatter.ofPattern("EEE, d MMM yyyy", currentLocale())),
            onSelect = { onIntent(ReceiptReviewIntent.SheetPickDate(it)) },
            onShowMonth = { onIntent(ReceiptReviewIntent.SheetShowMonth(it)) },
            onConfirm = confirm,
            onDismiss = dismiss,
        )

        null -> Unit
    }
}

@PreviewLightDark
@Composable
private fun ReceiptReviewPreview() {
    MonAITheme { ReceiptReviewScreen(ReceiptReviewPreviewData.filled, onIntent = {}) }
}

@Preview
@Composable
private fun ReceiptReviewFailedPreview() {
    MonAITheme { ReceiptReviewScreen(ReceiptReviewPreviewData.aiFailed, onIntent = {}) }
}
