package com.djtech.monai.feature.export.presentation.exportcsv

import android.content.ClipData
import android.content.Context
import android.content.Intent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.PreviewLightDark
import androidx.compose.ui.unit.dp
import androidx.core.net.toUri
import androidx.hilt.lifecycle.viewmodel.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.CollectEffects
import com.djtech.monai.core.designsystem.component.MonAIAlertTone
import com.djtech.monai.core.designsystem.component.MonAIBottomSheet
import com.djtech.monai.core.designsystem.component.MonAIButton
import com.djtech.monai.core.designsystem.component.MonAIInlineAlert
import com.djtech.monai.core.designsystem.component.MonAIScreenTitle
import com.djtech.monai.core.designsystem.component.MonAISheetButtons
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.export.presentation.exportcsv.components.ExportCsvDelimiterOptions
import com.djtech.monai.feature.export.presentation.exportcsv.components.ExportCsvRangeRow
import com.djtech.monai.feature.export.presentation.exportcsv.preview.ExportCsvPreviewData

/**
 * The export as a bottom sheet over Settings. Once the file is written it opens the share sheet,
 * reports [onExported] and closes.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExportCsvSheetRoute(
    onDismiss: () -> Unit,
    onExported: (isComplete: Boolean) -> Unit,
    viewModel: ExportCsvViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    CollectShareEffects(viewModel) { isComplete ->
        onExported(isComplete)
        onDismiss()
    }
    val cancel = {
        viewModel.onIntent(ExportCsvIntent.Cancel)
        onDismiss()
    }
    MonAIBottomSheet(onDismissRequest = cancel, title = stringResource(R.string.export_title)) {
        ExportCsvScreen(state, viewModel::onIntent)
        MonAISheetButtons(
            stringResource(R.string.export_cancel),
            onSecondary = cancel,
            primaryLabel = stringResource(R.string.export_action),
            onPrimary = { viewModel.onIntent(ExportCsvIntent.Export) },
            primaryLoading = state.isExporting,
        )
    }
}

/** The export in the wide Settings layout's detail pane. */
@Composable
fun ExportCsvPaneRoute(
    onExported: (isComplete: Boolean) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: ExportCsvViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    CollectShareEffects(viewModel, onExported)
    Column(
        modifier.widthIn(max = 560.dp),
        verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.sectionGap),
    ) {
        MonAIScreenTitle(stringResource(R.string.export_title))
        ExportCsvScreen(state, viewModel::onIntent)
        MonAIButton(
            stringResource(R.string.export_action),
            onClick = { viewModel.onIntent(ExportCsvIntent.Export) },
            modifier = Modifier.fillMaxWidth(),
            loading = state.isExporting,
        )
    }
}

/** The range, the delimiter and why the last export failed; the routes add the buttons. */
@Composable
fun ExportCsvScreen(
    state: ExportCsvState,
    onIntent: (ExportCsvIntent) -> Unit,
    modifier: Modifier = Modifier,
) {
    val spacing = MonAITheme.spacing
    Column(modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(spacing.x4)) {
        Column(verticalArrangement = Arrangement.spacedBy(spacing.x2)) {
            ExportCsvRangeRow(
                stringResource(R.string.export_from),
                state.range.from,
                canMoveForward = state.canMoveFromForward,
                enabled = !state.isExporting,
                onMove = { onIntent(ExportCsvIntent.MoveFrom(it)) },
            )
            ExportCsvRangeRow(
                stringResource(R.string.export_to),
                state.range.to,
                canMoveForward = state.canMoveToForward,
                enabled = !state.isExporting,
                onMove = { onIntent(ExportCsvIntent.MoveTo(it)) },
            )
            Text(
                stringResource(R.string.export_range_note),
                style = MonAITheme.typography.bodySmall,
                color = MonAITheme.colors.textTertiary,
            )
        }
        ExportCsvDelimiterOptions(state.delimiter, onPick = { onIntent(ExportCsvIntent.PickDelimiter(it)) })
        state.error?.let { MonAIInlineAlert(it.asString(), tone = MonAIAlertTone.Error) }
    }
}

@Composable
private fun CollectShareEffects(viewModel: ExportCsvViewModel, onShared: (isComplete: Boolean) -> Unit) {
    val context = LocalContext.current
    val title = stringResource(R.string.export_share_title)
    CollectEffects(viewModel.effects) { effect ->
        when (effect) {
            is ExportCsvEffect.Share -> {
                context.shareCsv(effect.uri, title)
                onShared(effect.isComplete)
            }
        }
    }
}

/** Opens the share sheet with read access to the file for whichever app is picked. */
private fun Context.shareCsv(uri: String, title: String) {
    val contentUri = uri.toUri()
    val send = Intent(Intent.ACTION_SEND)
        .setType("text/csv")
        .putExtra(Intent.EXTRA_STREAM, contentUri)
        .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    // The chooser passes the grant on only for URIs in the ClipData.
    send.clipData = ClipData.newRawUri(null, contentUri)
    startActivity(Intent.createChooser(send, title))
}

@PreviewLightDark
@Composable
private fun ExportCsvScreenPreview() {
    MonAITheme {
        Column(
            Modifier
                .background(MonAITheme.colors.surface)
                .padding(MonAITheme.spacing.x4),
        ) {
            ExportCsvScreen(ExportCsvPreviewData.quarter, onIntent = {})
        }
    }
}

@PreviewLightDark
@Composable
private fun ExportCsvScreenErrorPreview() {
    MonAITheme {
        Column(
            Modifier
                .background(MonAITheme.colors.surface)
                .padding(MonAITheme.spacing.x4),
        ) {
            ExportCsvScreen(ExportCsvPreviewData.failed, onIntent = {})
        }
    }
}
