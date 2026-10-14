package com.djtech.monai.feature.export.presentation.exportcsv.components

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import com.djtech.monai.R
import com.djtech.monai.core.designsystem.component.MonAIRadioOption
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.export.domain.model.CsvDelimiter

/** Comma or semicolon, with a hint for spreadsheets that expect the other one. */
@Composable
internal fun ExportCsvDelimiterOptions(
    selected: CsvDelimiter,
    onPick: (CsvDelimiter) -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
        Text(
            stringResource(R.string.export_delimiter),
            style = MonAITheme.typography.titleSmall,
            color = MonAITheme.colors.textPrimary,
        )
        Column(Modifier.selectableGroup(), verticalArrangement = Arrangement.spacedBy(MonAITheme.spacing.x2)) {
            CsvDelimiter.entries.forEach { delimiter ->
                MonAIRadioOption(
                    title = delimiter.label(),
                    selected = delimiter == selected,
                    onClick = { onPick(delimiter) },
                )
            }
        }
        Text(
            stringResource(R.string.export_delimiter_note),
            style = MonAITheme.typography.bodySmall,
            color = MonAITheme.colors.textTertiary,
        )
    }
}

@Composable
private fun CsvDelimiter.label(): String = stringResource(
    when (this) {
        CsvDelimiter.COMMA -> R.string.export_delimiter_comma
        CsvDelimiter.SEMICOLON -> R.string.export_delimiter_semicolon
    },
)
