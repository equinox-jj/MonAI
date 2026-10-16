package com.djtech.monai.feature.transactions.presentation.transactiondetail

import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.common.ui.rememberTakePicture
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.component.MonAISnackbarHost
import com.djtech.monai.core.designsystem.component.MonAIStateMessage
import com.djtech.monai.core.designsystem.component.MonAITopBar
import com.djtech.monai.core.designsystem.component.ScreenPlacement
import com.djtech.monai.core.designsystem.component.rememberMonAIMessenger
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.transactions.presentation.transactiondetail.components.TransactionDetailActions
import com.djtech.monai.feature.transactions.presentation.transactiondetail.components.TransactionDetailFields
import com.djtech.monai.feature.transactions.presentation.transactiondetail.components.TransactionDetailHero
import com.djtech.monai.feature.transactions.presentation.transactiondetail.components.TransactionDetailPhotoSheet
import com.djtech.monai.feature.transactions.presentation.transactiondetail.components.TransactionDetailReceipt
import com.djtech.monai.feature.transactions.presentation.transactiondetail.components.TransactionDetailReceiptViewer
import com.djtech.monai.feature.transactions.presentation.transactiondetail.preview.TransactionDetailPreviewData

@Composable
fun TransactionDetailRoute(
    transactionId: String,
    onBack: () -> Unit,
    onEdit: (String) -> Unit,
    modifier: Modifier = Modifier,
    placement: ScreenPlacement = ScreenPlacement.FullScreen,
    viewModel: TransactionDetailViewModel =
        hiltViewModel<TransactionDetailViewModel, TransactionDetailViewModel.Factory>(key = transactionId) {
            it.create(transactionId)
        },
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val messenger = rememberMonAIMessenger()
    val takePicture = rememberTakePicture(
        onDenied = { messenger.show(UiText.Resource(R.string.camera_permission_denied)) },
        onResult = { viewModel.onIntent(TransactionDetailIntent.ReceiptPhotoPicked(it)) },
    )
    val gallery = rememberLauncherForActivityResult(ActivityResultContracts.PickVisualMedia()) { uri ->
        viewModel.onIntent(TransactionDetailIntent.ReceiptPhotoPicked(uri?.toString()))
    }
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is TransactionDetailEffect.LaunchCamera -> takePicture(effect.uri)

            TransactionDetailEffect.LaunchGallery ->
                gallery.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly))

            TransactionDetailEffect.NavigateBack -> onBack()
            is TransactionDetailEffect.OpenEdit -> onEdit(effect.id)
            is TransactionDetailEffect.ShowMessage -> messenger.show(effect.message)
        }
    }
    TransactionDetailScreen(
        state,
        viewModel::onIntent,
        modifier,
        placement = placement,
        snackbarHostState = messenger.hostState,
    )
}

@Composable
fun TransactionDetailScreen(
    state: TransactionDetailState,
    onIntent: (TransactionDetailIntent) -> Unit,
    modifier: Modifier = Modifier,
    placement: ScreenPlacement = ScreenPlacement.FullScreen,
    snackbarHostState: SnackbarHostState = remember { SnackbarHostState() },
) {
    val transaction = state.transaction
    Box(
        modifier
            .fillMaxSize()
            .background(MonAITheme.colors.background),
    ) {
        Column(Modifier.fillMaxSize()) {
            MonAITopBar(
                title = stringResource(R.string.transaction_detail_title),
                onNavigationClick = { onIntent(TransactionDetailIntent.Back) },
                navigationContentDescription = stringResource(R.string.transaction_detail_back),
                placement = placement,
            ) {
                if (transaction != null) {
                    MonAIIconButton(
                        MonAIIcons.Edit,
                        stringResource(R.string.transaction_detail_edit_description),
                        onClick = { onIntent(TransactionDetailIntent.Edit) },
                    )
                    MonAIIconButton(
                        MonAIIcons.Delete,
                        stringResource(R.string.transaction_detail_delete_description),
                        onClick = { onIntent(TransactionDetailIntent.Delete) },
                        tint = MonAITheme.colors.error,
                        enabled = !state.isDeleting,
                    )
                }
            }
            when {
                transaction != null -> DetailContent(state, onIntent, Modifier.weight(1f))
                state.loadError != null -> DetailError(state.loadError, placement, onIntent, Modifier.weight(1f))
                else -> {
                    val description = stringResource(R.string.transaction_detail_loading)
                    Box(
                        Modifier
                            .weight(1f)
                            .fillMaxWidth()
                            .semantics { contentDescription = description },
                        contentAlignment = Alignment.Center,
                    ) { CircularProgressIndicator() }
                }
            }
        }
        MonAISnackbarHost(snackbarHostState, Modifier.align(Alignment.BottomCenter))
    }
    val receiptUrl = transaction?.receiptUrl
    if (state.isReceiptOpen && receiptUrl != null) {
        TransactionDetailReceiptViewer(receiptUrl, onClose = { onIntent(TransactionDetailIntent.CloseReceipt) })
    }
    if (state.isPhotoSourceOpen) {
        TransactionDetailPhotoSheet(
            onTakePhoto = { onIntent(TransactionDetailIntent.TakeReceiptPhoto) },
            onChoosePhoto = { onIntent(TransactionDetailIntent.ChooseReceiptPhoto) },
            onDismiss = { onIntent(TransactionDetailIntent.DismissPhotoSource) },
        )
    }
}

@Composable
private fun DetailContent(
    state: TransactionDetailState,
    onIntent: (TransactionDetailIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val transaction = state.transaction ?: return
    Column(
        modifier
            .fillMaxWidth()
            .navigationBarsPadding()
            .padding(horizontal = MonAITheme.spacing.screenHorizontal)
            .padding(bottom = MonAITheme.spacing.x6),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Column(
            Modifier
                .weight(1f)
                .widthIn(max = 560.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x4),
        ) {
            TransactionDetailHero(transaction, state.lookups)
            TransactionDetailFields(transaction, state.lookups, state.today)
            TransactionDetailReceipt(
                receiptUrl = transaction.receiptUrl,
                upload = state.receiptUpload,
                onView = { onIntent(TransactionDetailIntent.OpenReceipt) },
                onAdd = { onIntent(TransactionDetailIntent.AddReceipt) },
            )
        }
        TransactionDetailActions(
            isDeleting = state.isDeleting,
            onDelete = { onIntent(TransactionDetailIntent.Delete) },
            onEdit = { onIntent(TransactionDetailIntent.Edit) },
            modifier = Modifier
                .widthIn(max = 560.dp)
                .padding(top = MonAITheme.spacing.x4),
        )
    }
}

@Composable
private fun DetailError(
    message: UiText,
    placement: ScreenPlacement,
    onIntent: (TransactionDetailIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    Box(
        modifier
            .fillMaxWidth()
            .padding(horizontal = MonAITheme.spacing.x10),
        contentAlignment = Alignment.Center,
    ) {
        MonAIStateMessage(
            icon = MonAIIcons.Error,
            title = stringResource(R.string.transaction_detail_error_title),
            message = message.asString(),
            tone = MonAIAlertTone.Error,
            actionLabel = stringResource(R.string.transaction_try_again),
            actionIcon = MonAIIcons.Refresh,
            onAction = { onIntent(TransactionDetailIntent.Retry) },
            secondaryActionLabel = stringResource(R.string.transaction_detail_back)
                .takeIf { placement != ScreenPlacement.Pane },
            onSecondaryAction = { onIntent(TransactionDetailIntent.Back) },
        )
    }
}

@PreviewLightDark
@Composable
private fun TransactionDetailPreview() {
    MonAITheme { TransactionDetailScreen(TransactionDetailPreviewData.shopping, onIntent = {}) }
}

@Preview
@Composable
private fun TransactionDetailTransferPreview() {
    MonAITheme { TransactionDetailScreen(TransactionDetailPreviewData.transfer, onIntent = {}) }
}
