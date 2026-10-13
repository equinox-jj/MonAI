package com.djtech.monai.feature.budgets.presentation.budget

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.usecase.DeleteBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.ObserveBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.RefreshBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.SetBudgetUseCase
import com.djtech.monai.feature.reports.domain.usecase.ObserveMonthlyReportUseCase
import com.djtech.monai.feature.reports.domain.usecase.RefreshMonthlyReportUseCase
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.time.YearMonth

/**
 * Sets, changes or removes one month's spending limit, previewing a typed limit against what the
 * month has spent so far. Shows the cache at once and refetches the budget and the month's report.
 */
@HiltViewModel(assistedFactory = BudgetViewModel.Factory::class)
class BudgetViewModel @AssistedInject constructor(
    @Assisted private val month: YearMonth,
    observeBudget: ObserveBudgetUseCase,
    private val refreshBudget: RefreshBudgetUseCase,
    observeMonthlyReport: ObserveMonthlyReportUseCase,
    private val refreshMonthlyReport: RefreshMonthlyReportUseCase,
    private val setBudget: SetBudgetUseCase,
    private val deleteBudget: DeleteBudgetUseCase,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(month: YearMonth): BudgetViewModel
    }

    private val ui = MutableStateFlow(Ui())

    val state: StateFlow<BudgetState> = combine(
        observeBudget(month),
        observeMonthlyReport(month),
        ui,
    ) { budget, report, ui ->
        BudgetState(
            month = month,
            // The saved limit until the user types, so a budget that arrives late doesn't overwrite typing.
            limit = ui.limit ?: budget?.limitAmount ?: 0,
            spent = budget?.spent ?: report?.expenseTotal ?: 0,
            hasBudget = budget != null,
            isSaving = ui.isSaving,
            isDeleting = ui.isDeleting,
            limitError = ui.limitError,
            isConfirmingDelete = ui.isConfirmingDelete,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, BudgetState(month = month))

    private val effectChannel = Channel<BudgetEffect>(Channel.BUFFERED)
    val effects: Flow<BudgetEffect> = effectChannel.receiveAsFlow()

    init {
        // Failures keep what is cached; the preview just uses older spending.
        viewModelScope.launch { refreshBudget(month) }
        viewModelScope.launch { refreshMonthlyReport(month) }
    }

    fun onIntent(intent: BudgetIntent) {
        when (intent) {
            is BudgetIntent.LimitChanged -> ui.update { it.copy(limit = intent.limit, limitError = null) }
            is BudgetIntent.PickPreset -> ui.update { it.copy(limit = intent.limit, limitError = null) }
            BudgetIntent.Save -> save()
            BudgetIntent.Delete -> ui.update { it.copy(isConfirmingDelete = true) }
            BudgetIntent.ConfirmDelete -> delete()
            BudgetIntent.DismissDelete -> ui.update { it.copy(isConfirmingDelete = false) }
            BudgetIntent.Back -> send(BudgetEffect.Close)
        }
    }

    private fun save() {
        // Read the typed limit from ui: state may not have caught up with an intent sent just before.
        val limit = ui.value.limit ?: state.value.limit
        if (limit <= 0 || ui.value.isWorking) return
        ui.update { it.copy(isSaving = true, limitError = null) }
        viewModelScope.launch {
            val result = setBudget(month, limit)
            ui.update { it.copy(isSaving = false) }
            when (result) {
                is Outcome.Success -> send(BudgetEffect.Close)
                is Outcome.Failure if result.error == BudgetError.InvalidLimit ->
                    ui.update { it.copy(limitError = UiText.Resource(R.string.budget_error_invalid_limit)) }

                is Outcome.Failure -> send(BudgetEffect.ShowMessage(result.error.message()))
            }
        }
    }

    private fun delete() {
        if (ui.value.isWorking) return
        ui.update { it.copy(isDeleting = true, isConfirmingDelete = false) }
        viewModelScope.launch {
            val result = deleteBudget(month)
            ui.update { it.copy(isDeleting = false) }
            when (result) {
                is Outcome.Success -> send(BudgetEffect.Close)
                is Outcome.Failure -> send(BudgetEffect.ShowMessage(result.error.message()))
            }
        }
    }

    private fun send(effect: BudgetEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

/** Screen-local state; the budget and the month's spending come from the cache. */
private data class Ui(
    /** Null until the user types or picks a preset. */
    val limit: Long? = null,
    val isSaving: Boolean = false,
    val isDeleting: Boolean = false,
    val limitError: UiText? = null,
    val isConfirmingDelete: Boolean = false,
) {
    val isWorking: Boolean get() = isSaving || isDeleting
}

private fun BudgetError.message(): UiText = UiText.Resource(
    when (this) {
        BudgetError.Network -> R.string.budget_error_network
        BudgetError.InvalidLimit -> R.string.budget_error_invalid_limit
        BudgetError.Unexpected -> R.string.budget_error_unexpected
    },
)
