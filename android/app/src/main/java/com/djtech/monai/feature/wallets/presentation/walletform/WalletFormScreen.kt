package com.djtech.monai.feature.wallets.presentation.walletform

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
import com.djtech.monai.core.designsystem.component.MonAIButtonSize
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.MonAITopBarNavigation
import com.djtech.monai.core.designsystem.component.label
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormBalance
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormColors
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormDefault
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormDialogs
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormManageActions
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormName
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormPreviewCard
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormProviderGrid
import com.djtech.monai.feature.wallets.presentation.walletform.components.WalletFormType
import com.djtech.monai.feature.wallets.presentation.walletform.preview.WalletFormPreviewData
import kotlinx.coroutines.launch

/**
 * @param walletId the wallet to edit; null adds a new one.
 * @param onDeleted the edited wallet was deleted from here; close its screens.
 * @param isSideSheet shown as a side sheet over the list on a wide screen, below no status bar.
 */
@Composable
fun WalletFormRoute(
    walletId: String?,
    onClose: () -> Unit,
    onDeleted: (String) -> Unit,
    modifier: Modifier = Modifier,
    isSideSheet: Boolean = false,
    viewModel: WalletFormViewModel =
        hiltViewModel<WalletFormViewModel, WalletFormViewModel.Factory>(key = walletId ?: "new") {
            it.create(walletId)
        },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            WalletFormEffect.Close -> onClose()
            is WalletFormEffect.Deleted -> onDeleted(effect.id)
            is WalletFormEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    BackHandler { viewModel.onIntent(WalletFormIntent.Close) }
    WalletFormScreen(
        state,
        viewModel::onIntent,
        modifier,
        isSideSheet = isSideSheet,
        snackbarHostState = snackbarHostState,
    )
}

@Composable
fun WalletFormScreen(
    state: WalletFormState,
    onIntent: (WalletFormIntent) -> Unit,
    modifier: Modifier = Modifier,
    isSideSheet: Boolean = false,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val isReady = !state.isLoading && state.loadError == null
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
                    if (state.isEdit) R.string.wallet_form_edit_title else R.string.wallet_form_add_title,
                ),
                navigation = MonAITopBarNavigation.Close,
                onNavigationClick = { onIntent(WalletFormIntent.Close) },
                navigationContentDescription = stringResource(R.string.wallet_form_close),
                titleStyle = MonAITheme.typography.headlineSmall,
                windowInsets = if (isSideSheet) WindowInsets(0) else WindowInsets.statusBars,
            ) {
                if (state.isEdit && isReady) {
                    MonAIButton(
                        stringResource(R.string.wallet_form_save),
                        onClick = { onIntent(WalletFormIntent.Save) },
                        size = MonAIButtonSize.Small,
                        loading = state.isSaving,
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
                        title = stringResource(R.string.wallet_detail_error_title),
                        message = state.loadError.asString(),
                        tone = MonAIAlertTone.Error,
                        actionLabel = stringResource(R.string.wallets_try_again),
                        actionIcon = MonAIIcons.Refresh,
                        onAction = { onIntent(WalletFormIntent.Retry) },
                    )
                }

                state.isLoading -> {
                    val description = stringResource(R.string.wallet_form_loading)
                    Box(
                        Modifier
                            .weight(1f)
                            .fillMaxWidth()
                            .semantics { contentDescription = description },
                        contentAlignment = Alignment.Center,
                    ) { CircularProgressIndicator(color = MonAITheme.colors.primary) }
                }

                else -> FormContent(state, onIntent, Modifier.weight(1f))
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    WalletFormDialogs(state.dialog, state.wallet?.name ?: state.name, onIntent)
}

@Composable
private fun FormContent(
    state: WalletFormState,
    onIntent: (WalletFormIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    val wallet = state.wallet
    val provider = state.providers.firstOrNull { it.slug == state.providerSlug }
    Column(
        modifier
            .fillMaxWidth()
            .padding(horizontal = spacing.screenHorizontal)
            .padding(bottom = spacing.x6),
        verticalArrangement = Arrangement.spacedBy(spacing.x4),
    ) {
        // Everything but the add button scrolls, so the button stays put above the keyboard.
        Column(
            Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(spacing.x4),
        ) {
            if (wallet != null) {
                WalletFormPreviewCard(
                    wallet,
                    state.name,
                    state.color,
                    balance = state.balanceShift?.to ?: wallet.currentBalance,
                )
            } else {
                WalletFormProviderGrid(state.providers, state.providerSlug, onIntent)
            }
            val hint = when {
                wallet != null && state.isTypeLocked -> stringResource(
                    R.string.wallet_form_type_from_provider,
                    wallet.type.label(),
                )

                provider != null -> stringResource(R.string.wallet_form_name_help_provider, provider.name)
                else -> stringResource(R.string.wallet_form_name_help_custom)
            }
            WalletFormName(
                state.name,
                hint,
                state.errors[WalletField.NAME],
                onNameChange = { onIntent(WalletFormIntent.NameChanged(it)) },
            )
            // An edited provider wallet names its type under the name instead.
            if (wallet == null || !state.isTypeLocked) {
                WalletFormType(
                    state.type,
                    state.isTypeLocked,
                    state.errors[WalletField.TYPE],
                    onSelect = { onIntent(WalletFormIntent.SelectType(it)) },
                )
            }
            if (wallet != null) {
                WalletFormColors(state.color, onPick = { onIntent(WalletFormIntent.PickColor(it)) })
            }
            WalletFormBalance(
                state.initialBalance,
                isEdit = state.isEdit,
                shift = state.balanceShift,
                error = state.errors[WalletField.INITIAL_BALANCE],
                onChange = { onIntent(WalletFormIntent.BalanceChanged(it)) },
            )
            WalletFormDefault(
                checked = state.isDefault,
                isEdit = state.isEdit,
                enabled = state.canChangeDefault,
                defaultWalletName = state.defaultWalletName,
                onChange = { onIntent(WalletFormIntent.DefaultChanged(it)) },
            )
        }
        if (wallet != null) {
            WalletFormManageActions(
                canArchive = state.canArchive,
                canDelete = state.canDelete,
                enabled = !state.isSaving,
                onArchive = { onIntent(WalletFormIntent.Archive) },
                onDelete = { onIntent(WalletFormIntent.Delete) },
            )
        } else {
            MonAIButton(
                stringResource(R.string.wallet_form_add),
                onClick = { onIntent(WalletFormIntent.Save) },
                modifier = Modifier.fillMaxWidth(),
                loading = state.isSaving,
            )
        }
    }
}

@PreviewLightDark
@Composable
private fun WalletFormAddPreview() {
    MonAITheme { WalletFormScreen(WalletFormPreviewData.add, onIntent = {}) }
}

@Preview
@Composable
private fun WalletFormEditPreview() {
    MonAITheme { WalletFormScreen(WalletFormPreviewData.edit, onIntent = {}) }
}
