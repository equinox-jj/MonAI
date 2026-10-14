package com.djtech.monai.feature.export.presentation.exportcsv

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.feature.export.domain.model.ExportRange
import com.djtech.monai.feature.export.domain.usecase.ExportTransactionsCsvUseCase
import com.djtech.monai.feature.export.presentation.exportcsv.mapper.message
import com.djtech.monai.feature.export.presentation.exportcsv.mapper.withFrom
import com.djtech.monai.feature.export.presentation.exportcsv.mapper.withTo
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Job
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/** The CSV export sheet: a range of months and a delimiter, then the file for the share sheet. */
@HiltViewModel
class ExportCsvViewModel @Inject constructor(
    private val exportTransactionsCsv: ExportTransactionsCsvUseCase,
    clock: AppClock,
) : ViewModel() {

    private val currentMonth = clock.currentMonth()
    private val mutableState = MutableStateFlow(
        ExportCsvState(range = ExportRange(currentMonth, currentMonth), currentMonth = currentMonth),
    )
    val state: StateFlow<ExportCsvState> = mutableState.asStateFlow()

    private val effectChannel = Channel<ExportCsvEffect>(Channel.BUFFERED)
    val effects: Flow<ExportCsvEffect> = effectChannel.receiveAsFlow()

    private var exportJob: Job? = null

    fun onIntent(intent: ExportCsvIntent) {
        when (intent) {
            is ExportCsvIntent.MoveFrom -> editRange { range ->
                range.withFrom(range.from.plusMonths(intent.months.toLong()), currentMonth)
            }

            is ExportCsvIntent.MoveTo -> editRange { range ->
                range.withTo(range.to.plusMonths(intent.months.toLong()), currentMonth)
            }

            is ExportCsvIntent.PickDelimiter -> mutableState.update {
                it.copy(delimiter = intent.delimiter, error = null)
            }

            ExportCsvIntent.Export -> export()
            ExportCsvIntent.Cancel -> {
                exportJob?.cancel()
                mutableState.update { it.copy(isExporting = false, error = null) }
            }
        }
    }

    private fun editRange(change: (ExportRange) -> ExportRange) {
        if (mutableState.value.isExporting) return
        mutableState.update { it.copy(range = change(it.range), error = null) }
    }

    private fun export() {
        val current = mutableState.value
        if (current.isExporting) return
        mutableState.update { it.copy(isExporting = true, error = null) }
        exportJob = viewModelScope.launch {
            when (val result = exportTransactionsCsv(current.range, current.delimiter)) {
                is Outcome.Success -> {
                    mutableState.update { it.copy(isExporting = false) }
                    effectChannel.send(ExportCsvEffect.Share(result.data.uri, result.data.isComplete))
                }

                is Outcome.Failure -> mutableState.update {
                    it.copy(isExporting = false, error = result.error.message())
                }
            }
        }
    }
}
