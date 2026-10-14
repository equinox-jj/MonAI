package com.djtech.monai.feature.transactions.presentation.transactionform

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.isImeVisible
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAIButtonVariant
import com.djtech.monai.core.designsystem.component.MonAICategoryPickerSheet
import com.djtech.monai.core.designsystem.component.MonAIDatePickerSheet
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAIInlineAlert
import com.djtech.monai.core.designsystem.component.MonAISegmentedControl
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.component.MonAIWalletPickerSheet
import com.djtech.monai.core.designsystem.component.transactionTypeSegments
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.presentation.common.dateText
import com.djtech.monai.feature.transactions.presentation.common.direction
import com.djtech.monai.feature.transactions.presentation.common.label
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormAmount
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormDiscardDialog
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormFields
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormKeypad
import com.djtech.monai.feature.transactions.presentation.transactionform.model.FormSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormPreset
import com.djtech.monai.feature.transactions.presentation.transactionform.model.WalletTarget
import com.djtech.monai.feature.transactions.presentation.transactionform.preview.TransactionFormPreviewData
import kotlinx.coroutines.launch

/**
 * @param transactionId the transaction to edit; null adds a new one.
 * @param preset how a new transaction starts; ignored when editing.
 * @param onDeleted the edited transaction was deleted from here.
 * @param onNewCategory open the category form for a new category of this type.
 * @param onSaved the transaction was saved; closes the form unless the caller does more.
 * @param onScan the add form's Scan chip; hidden when null.
 * @param isSideSheet shown as a side sheet over the list on a wide screen, below no status bar.
 */
@Composable
fun TransactionFormRoute(
    transactionId: String?,
    onClose: () -> Unit,
    onDeleted: (String) -> Unit,
    onNewCategory: (CategoryType) -> Unit,
    modifier: Modifier = Modifier,
    preset: TransactionFormPreset = TransactionFormPreset(),
    onSaved: (String) -> Unit = { onClose() },
    onScan: (() -> Unit)? = null,
    isSideSheet: Boolean = false,
    viewModel: TransactionFormViewModel = hiltViewModel<TransactionFormViewModel, TransactionFormViewModel.Factory>(
        key = transactionId ?: "new-${preset.type}-${preset.walletId}-${preset.draft.hashCode()}",
    ) {
        it.create(transactionId, preset)
    },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            TransactionFormEffect.Close -> onClose()
            is TransactionFormEffect.Saved -> onSaved(effect.id)
            TransactionFormEffect.OpenScan -> onScan?.invoke()
            is TransactionFormEffect.Deleted -> onDeleted(effect.id)
            is TransactionFormEffect.OpenNewCategory -> onNewCategory(effect.type)
            is TransactionFormEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    BackHandler { viewModel.onIntent(TransactionFormIntent.Close) }
    TransactionFormScreen(
        state,
        viewModel::onIntent,
        modifier,
        isSideSheet = isSideSheet,
        canScan = onScan != null,
        snackbarHostState = snackbarHostState,
    )
}

@Composable
fun TransactionFormScreen(
    state: TransactionFormState,
    onIntent: (TransactionFormIntent) -> Unit,
    modifier: Modifier = Modifier,
    isSideSheet: Boolean = false,
    canScan: Boolean = false,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
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
                title = stringResource(
                    if (state.isEdit) R.string.transaction_form_edit else R.string.transaction_form_new,
                ),
                navigation = MonAITopBarNavigation.Close,
                onNavigationClick = { onIntent(TransactionFormIntent.Close) },
                navigationContentDescription = stringResource(
                    if (state.isEdit) {
                        R.string.transaction_form_discard_description
                    } else {
                        R.string.transaction_form_close
                    },
                ),
                titleStyle = MonAITheme.typography.headlineSmall,
                windowInsets = if (isSideSheet) WindowInsets(0) else WindowInsets.statusBars,
            ) {
                if (!state.isEdit && canScan) {
                    MonAIButton(
                        stringResource(R.string.transaction_form_scan),
                        onClick = { onIntent(TransactionFormIntent.Scan) },
                        variant = MonAIButtonVariant.Tonal,
                        size = MonAIButtonSize.Small,
                        leadingIcon = MonAIIcons.DocumentScanner,
                    )
                }
                if (state.isEdit && !state.isLoading && state.loadError == null) {
                    MonAIIconButton(
                        MonAIIcons.Delete,
                        stringResource(R.string.transaction_detail_delete_description),
                        onClick = { onIntent(TransactionFormIntent.Delete) },
                        tint = MonAITheme.colors.error,
                        enabled = !state.isDeleting,
                    )
                }
            }
            when {
                state.loadError != null -> Box(
                    Modifier
                        .weight(1f)
                        .fillMaxWidth()
                        .padding(horizontal = MonAITheme.spacing.x10),
                    contentAlignment = Alignment.Center,
                ) {
                    MonAIStateMessage(
                        icon = MonAIIcons.Error,
                        title = stringResource(R.string.transaction_detail_error_title),
                        message = state.loadError.asString(),
                        tone = MonAIAlertTone.Error,
                        actionLabel = stringResource(R.string.transaction_try_again),
                        actionIcon = MonAIIcons.Refresh,
                        onAction = { onIntent(TransactionFormIntent.Retry) },
                    )
                }

                state.isLoading -> {
                    val description = stringResource(R.string.transaction_form_loading)
                    Box(
                        Modifier
                            .weight(1f)
                            .fillMaxWidth()
                            .semantics { contentDescription = description },
                        contentAlignment = Alignment.Center,
                    ) { CircularProgressIndicator() }
                }

                else -> FormContent(state, onIntent, Modifier.weight(1f))
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    FormSheets(state, onIntent)
    if (state.showDiscardDialog) TransactionFormDiscardDialog(onIntent)
}

@OptIn(ExperimentalLayoutApi::class)
@Composable
private fun FormContent(
    state: TransactionFormState,
    onIntent: (TransactionFormIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    val horizontal = Modifier.padding(horizontal = spacing.screenHorizontal)
    val types = TransactionType.entries
    Column(modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(spacing.x3)) {
        // Everything above the keypad scrolls, so the keypad and Save stay put on short screens.
        Column(
            Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(spacing.x3),
        ) {
            MonAISegmentedControl(
                segments = transactionTypeSegments(
                    stringResource(R.string.transaction_type_expense),
                    stringResource(R.string.transaction_type_income),
                    stringResource(R.string.transaction_type_transfer),
                ),
                selectedIndex = types.indexOf(state.type),
                onSelect = { onIntent(TransactionFormIntent.SelectType(types[it])) },
                modifier = horizontal,
            )
            TransactionFormAmount(
                type = state.type,
                amount = state.amount,
                originalAmount = state.originalAmount,
                error = state.errors[TransactionField.AMOUNT]?.asString(),
                highlight = state.highlights[TransactionField.AMOUNT] ?: FieldHighlight.None,
            )
            TransactionFormFields(state, onIntent)
            if (state.isEdit) {
                MonAIInlineAlert(
                    stringResource(R.string.transaction_form_update_info),
                    horizontal,
                    icon = MonAIIcons.Info,
                )
            }
        }
        // Only the note opens the keyboard; hide the keypad meanwhile so the two don't stack.
        if (!WindowInsets.isImeVisible) TransactionFormKeypad(onIntent, horizontal)
        MonAIButton(
            text = stringResource(state.saveLabel()),
            onClick = { onIntent(TransactionFormIntent.Save) },
            modifier = horizontal
                .fillMaxWidth()
                .padding(bottom = spacing.x4),
            leadingIcon = MonAIIcons.Check,
            loading = state.isSaving,
        )
    }
}

@Composable
private fun FormSheets(state: TransactionFormState, onIntent: (TransactionFormIntent) -> Unit) {
    when (val sheet = state.sheet) {
        is FormSheet.Category -> MonAICategoryPickerSheet(
            categories = state.categories,
            selectedId = sheet.selectedId,
            typeLabel = state.type.label(),
            direction = state.type.direction(),
            onSelect = { onIntent(TransactionFormIntent.SheetPickCategory(it)) },
            onConfirm = { onIntent(TransactionFormIntent.ConfirmSheet) },
            onDismiss = { onIntent(TransactionFormIntent.DismissSheet) },
            onNewCategory = { onIntent(TransactionFormIntent.NewCategory) },
        )

        is FormSheet.Wallet -> MonAIWalletPickerSheet(
            title = stringResource(
                when {
                    sheet.target == WalletTarget.DESTINATION -> R.string.transaction_picker_transfer_to
                    state.type == TransactionType.TRANSFER -> R.string.transaction_picker_transfer_from
                    state.type == TransactionType.INCOME -> R.string.transaction_picker_receive_into
                    else -> R.string.transaction_picker_pay_from
                },
            ),
            wallets = state.wallets,
            selectedId = sheet.selectedId,
            onSelect = { onIntent(TransactionFormIntent.SheetPickWallet(it)) },
            onConfirm = { onIntent(TransactionFormIntent.ConfirmSheet) },
            onDismiss = { onIntent(TransactionFormIntent.DismissSheet) },
        )

        is FormSheet.Date -> MonAIDatePickerSheet(
            selected = sheet.selected,
            shownMonth = sheet.shownMonth,
            today = state.today,
            selectedLabel = dateText(sheet.selected, state.today),
            onSelect = { onIntent(TransactionFormIntent.SheetPickDate(it)) },
            onShowMonth = { onIntent(TransactionFormIntent.SheetShowMonth(it)) },
            onConfirm = { onIntent(TransactionFormIntent.ConfirmSheet) },
            onDismiss = { onIntent(TransactionFormIntent.DismissSheet) },
        )
        null -> Unit
    }
}

private fun TransactionFormState.saveLabel(): Int = when {
    isEdit -> R.string.transaction_form_save_changes
    type == TransactionType.EXPENSE -> R.string.transaction_form_save_expense
    type == TransactionType.INCOME -> R.string.transaction_form_save_income
    else -> R.string.transaction_form_save_transfer
}

@PreviewLightDark
@Composable
private fun TransactionFormAddPreview() {
    MonAITheme { TransactionFormScreen(TransactionFormPreviewData.add, onIntent = {}) }
}

@Preview
@Composable
private fun TransactionFormTransferPreview() {
    MonAITheme { TransactionFormScreen(TransactionFormPreviewData.transfer, onIntent = {}) }
}

@Preview
@Composable
private fun TransactionFormEditPreview() {
    MonAITheme { TransactionFormScreen(TransactionFormPreviewData.edit, onIntent = {}) }
}
