package com.djtech.monai.feature.transactions.presentation.transactiondetail.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import coil3.compose.SubcomposeAsyncImage
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIIconButton
import com.djtech.monai.core.designsystem.icon.MonAIIcons
import com.djtech.monai.core.designsystem.theme.MonAITheme

/** The receipt photo over a dark backdrop, fitted to the screen. */
@Composable
internal fun TransactionDetailReceiptViewer(receiptUrl: String, onClose: () -> Unit) {
    Dialog(onDismissRequest = onClose, properties = DialogProperties(usePlatformDefaultWidth = false)) {
        Box(
            Modifier
                .fillMaxSize()
                .background(Color.Black)
                .safeDrawingPadding(),
        ) {
            SubcomposeAsyncImage(
                model = receiptUrl,
                contentDescription = stringResource(R.string.transaction_detail_receipt),
                modifier = Modifier.fillMaxSize(),
                contentScale = ContentScale.Fit,
                loading = {
                    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        CircularProgressIndicator(color = Color.White)
                    }
                },
                error = {
                    Box(
                        Modifier
                            .fillMaxSize()
                            .padding(MonAITheme.spacing.x10),
                        contentAlignment = Alignment.Center,
                    ) {
                        Text(
                            stringResource(R.string.transaction_detail_receipt_failed),
                            style = MonAITheme.typography.bodyMedium,
                            color = Color.White,
                            textAlign = TextAlign.Center,
                        )
                    }
                },
            )
            MonAIIconButton(
                MonAIIcons.Close,
                stringResource(R.string.transaction_detail_receipt_close),
                onClose,
                Modifier
                    .align(Alignment.TopEnd)
                    .padding(MonAITheme.spacing.x2),
                tint = Color.White,
            )
        }
    }
}
