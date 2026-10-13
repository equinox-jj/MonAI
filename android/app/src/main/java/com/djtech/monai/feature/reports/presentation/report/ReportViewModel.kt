package com.djtech.monai.feature.reports.presentation.report

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.budgets.domain.usecase.ObserveBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.RefreshBudgetUseCase
import com.djtech.monai.feature.reports.domain.model.ReportError
import com.djtech.monai.feature.reports.domain.usecase.ObserveMonthlyReportUseCase
import com.djtech.monai.feature.reports.domain.usecase.RefreshMonthlyReportUseCase
import com.djtech.monai.feature.reports.presentation.report.mapper.toRow
import com.djtech.monai.feature.reports.presentation.report.mapper.toTotals
import com.djtech.monai.feature.reports.presentation.report.model.ReportBudgetCard
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import java.time.YearMonth

/**
 * One month's income, expense and spending by category, compared with the month before, and its
 * budget. Moves between months up to the current one; each shows its cache at once and refetches.
 */
@OptIn(ExperimentalCoroutinesApi::class)
@HiltViewModel(assistedFactory = ReportViewModel.Factory::class)
class ReportViewModel @AssistedInject constructor(
    @Assisted initialMonth: YearMonth?,
    private val observeMonthlyReport: ObserveMonthlyReportUseCase,
    private val refreshMonthlyReport: RefreshMonthlyReportUseCase,
    observeBudget: ObserveBudgetUseCase,
    private val refreshBudget: RefreshBudgetUseCase,
    clock: AppClock,
) : ViewModel() {

    /** [initialMonth] null opens the current month. */
    @AssistedFactory
    interface Factory {
        fun create(initialMonth: YearMonth?): ReportViewModel
    }

    private val currentMonth = clock.currentMonth()
    private val month = MutableStateFlow(initialMonth?.coerceAtMost(currentMonth) ?: currentMonth)
    private val fetch = MutableStateFlow(Fetch(month.value))
    private var fetchJob: Job? = null

    val state: StateFlow<ReportState> = month.flatMapLatest { month ->
        combine(observeMonthlyReport(month), observeBudget(month), fetch) { report, budget, fetch ->
            // A fetch still answering for the previous month counts as loading this one.
            val fetching = fetch.month != month || fetch.isFetching
            ReportState(
                month = month,
                canGoNext = month < currentMonth,
                totals = report?.toTotals(),
                categories = report?.categories?.map { it.toRow() }.orEmpty(),
                budget = report?.let { budget?.let(ReportBudgetCard::Set) ?: ReportBudgetCard.NotSet },
                isLoading = report == null && fetching,
                loadError = if (report == null && !fetching) fetch.error?.loadMessage() else null,
            )
        }
    }.stateIn(viewModelScope, WhileUiSubscribed, ReportState(month = month.value))

    private val effectChannel = Channel<ReportEffect>(Channel.BUFFERED)
    val effects: Flow<ReportEffect> = effectChannel.receiveAsFlow()

    init {
        fetch(month.value)
    }

    fun onIntent(intent: ReportIntent) {
        when (intent) {
            ReportIntent.PreviousMonth -> show(month.value.minusMonths(1))
            ReportIntent.NextMonth -> if (month.value < currentMonth) show(month.value.plusMonths(1))
            ReportIntent.OpenBudget -> send(ReportEffect.OpenBudget(month.value))
            ReportIntent.Retry -> fetch(month.value)
            ReportIntent.Back -> send(ReportEffect.NavigateBack)
        }
    }

    private fun show(newMonth: YearMonth) {
        month.value = newMonth
        fetch(newMonth)
    }

    private fun fetch(month: YearMonth) {
        // Only the shown month's answer matters; a slower one for a month left behind is dropped.
        fetchJob?.cancel()
        fetch.value = Fetch(month, isFetching = true)
        fetchJob = viewModelScope.launch {
            // The budget card just keeps what is cached when this fails.
            launch { refreshBudget(month) }
            val error = (refreshMonthlyReport(month) as? Outcome.Failure)?.error
            fetch.value = Fetch(month, isFetching = false, error = error)
            // With the report cached it stays on screen; say it may be out of date.
            if (error != null && observeMonthlyReport(month).first() != null) {
                send(ReportEffect.ShowMessage(error.refreshMessage()))
            }
        }
    }

    private fun send(effect: ReportEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

/** The latest fetch, for [month]. */
private data class Fetch(
    val month: YearMonth,
    val isFetching: Boolean = false,
    val error: ReportError? = null,
)

private fun ReportError.loadMessage(): UiText = UiText.Resource(
    when (this) {
        ReportError.Network -> R.string.report_load_failed_network
        ReportError.Unexpected -> R.string.report_load_failed_unexpected
    },
)

private fun ReportError.refreshMessage(): UiText = UiText.Resource(
    when (this) {
        ReportError.Network -> R.string.report_refresh_failed_network
        ReportError.Unexpected -> R.string.report_refresh_failed_unexpected
    },
)
