package com.djtech.monai.feature.transactions.presentation.transactionform

import androidx.activity.compose.BackHandler
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
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
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAIInlineAlert
import com.djtech.monai.core.designsystem.component.MonAISegmentedControl
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.component.transactionTypeSegments
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormAmount
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormCategoryPickerSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormDatePickerSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormDiscardDialog
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormFields
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormKeypad
import com.djtech.monai.feature.transactions.presentation.transactionform.components.TransactionFormWalletPickerSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.model.FormSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormPreset
import com.djtech.monai.feature.transactions.presentation.transactionform.preview.TransactionFormPreviewData
import kotlinx.coroutines.launch

/**
 * @param transactionId the transaction to edit; null adds a new one.
 * @param preset how a new transaction starts; ignored when editing.
 * @param onDeleted the edited transaction was deleted from here.
 * @param isSideSheet shown as a side sheet over the list on a wide screen, below no status bar.
 */
@Composable
fun TransactionFormRoute(
    transactionId: String?,
    onClose: () -> Unit,
    onDeleted: (String) -> Unit,
    modifier: Modifier = Modifier,
    preset: TransactionFormPreset = TransactionFormPreset(),
    isSideSheet: Boolean = false,
    viewModel: TransactionFormViewModel = hiltViewModel<TransactionFormViewModel, TransactionFormViewModel.Factory>(
        key = transactionId ?: "new-${preset.type}-${preset.walletId}",
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
            is TransactionFormEffect.Deleted -> onDeleted(effect.id)
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
        snackbarHostState = snackbarHostState,
    )
}

@Composable
fun TransactionFormScreen(
    state: TransactionFormState,
    onIntent: (TransactionFormIntent) -> Unit,
    modifier: Modifier = Modifier,
    isSideSheet: Boolean = false,
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
        TransactionFormKeypad(onIntent, horizontal)
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
        is FormSheet.Category -> TransactionFormCategoryPickerSheet(
            sheet,
            state.type,
            state.categories,
            onIntent,
        )

        is FormSheet.Wallet -> TransactionFormWalletPickerSheet(
            sheet,
            state.type,
            state.wallets,
            onIntent,
        )

        is FormSheet.Date -> TransactionFormDatePickerSheet(sheet, state.today, onIntent)
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
