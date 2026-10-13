package com.djtech.monai.feature.wallets.presentation.archivedwallets

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SnackbarResult
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
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAICard
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAISnackbarVisuals
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.archivedwallets.components.ArchivedWalletsRow
import com.djtech.monai.feature.wallets.presentation.archivedwallets.preview.ArchivedWalletsPreviewData
import kotlinx.coroutines.launch

@Composable
fun ArchivedWalletsRoute(
    onBack: () -> Unit,
    onOpenWallet: (String) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: ArchivedWalletsViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()
    val context = LocalContext.current
    val successIcon = MonAIIcons.CheckCircle
    val successTint = MonAITheme.colors.success
    val viewLabel = stringResource(R.string.archived_wallets_view)
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            ArchivedWalletsEffect.NavigateBack -> onBack()
            is ArchivedWalletsEffect.OpenWallet -> onOpenWallet(effect.id)
            is ArchivedWalletsEffect.Restored -> scope.launch {
                val result = snackbarHostState.showSnackbar(
                    MonAISnackbarVisuals(
                        effect.message.asString(context),
                        icon = successIcon,
                        iconTint = successTint,
                        actionLabel = viewLabel,
                    ),
                )
                if (result == SnackbarResult.ActionPerformed) {
                    viewModel.onIntent(ArchivedWalletsIntent.View(effect.id))
                }
            }

            is ArchivedWalletsEffect.ShowMessage -> scope.launch {
                snackbarHostState.showSnackbar(MonAISnackbarVisuals(effect.message.asString(context)))
            }
        }
    }
    ArchivedWalletsScreen(state, viewModel::onIntent, modifier, snackbarHostState)
}

/** Archived wallets with a way to bring each back, or a note that there are none. */
@Composable
fun ArchivedWalletsScreen(
    state: ArchivedWalletsState,
    onIntent: (ArchivedWalletsIntent) -> Unit,
    modifier: Modifier = Modifier,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val spacing = MonAITheme.spacing
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        Column(Modifier.fillMaxSize()) {
            MonAITopBar(
                title = stringResource(R.string.archived_wallets_title),
                onNavigationClick = { onIntent(ArchivedWalletsIntent.Back) },
            )
            Column(
                Modifier
                    .verticalScroll(rememberScrollState())
                    .navigationBarsPadding()
                    .padding(horizontal = spacing.screenHorizontal)
                    .padding(bottom = spacing.x6),
                verticalArrangement = Arrangement.spacedBy(spacing.x4),
            ) {
                Text(
                    stringResource(R.string.archived_wallets_intro),
                    style = MonAITheme.typography.bodyMedium,
                    color = MonAITheme.colors.textSecondary,
                )
                if (state.wallets.isEmpty()) {
                    MonAICard(
                        Modifier.fillMaxWidth(),
                        contentPadding = PaddingValues(horizontal = 24.dp, vertical = 32.dp),
                    ) {
                        MonAIStateMessage(
                            icon = MonAIIcons.Inventory2,
                            title = stringResource(R.string.archived_wallets_empty_title),
                            message = stringResource(R.string.archived_wallets_empty_body),
                            modifier = Modifier.fillMaxWidth(),
                        )
                    }
                } else {
                    MonAICard(
                        Modifier.fillMaxWidth(),
                        contentPadding = PaddingValues(0.dp),
                        verticalArrangement = Arrangement.Top,
                    ) {
                        state.wallets.forEachIndexed { index, wallet ->
                            ArchivedWalletsRow(
                                wallet,
                                isRestoring = wallet.id == state.restoringId,
                                enabled = state.restoringId == null,
                                onUnarchive = { onIntent(ArchivedWalletsIntent.Unarchive(wallet.id)) },
                                showDivider = index < state.wallets.lastIndex,
                            )
                        }
                    }
                }
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
}

@PreviewLightDark
@Composable
private fun ArchivedWalletsScreenPreview() {
    MonAITheme { ArchivedWalletsScreen(ArchivedWalletsPreviewData.list, onIntent = {}) }
}

@Preview
@Composable
private fun ArchivedWalletsEmptyPreview() {
    MonAITheme { ArchivedWalletsScreen(ArchivedWalletsState(), onIntent = {}) }
}
