package com.djtech.monai.feature.transactions.presentation.transactions

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.paging.PagingData
import androidx.paging.cachedIn
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveVisibleCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.RefreshCategoriesUseCase
import com.djtech.monai.feature.reports.domain.usecase.ObserveCachedExpenseTotalsUseCase
import com.djtech.monai.feature.reports.domain.usecase.ObserveMonthlyReportUseCase
import com.djtech.monai.feature.reports.domain.usecase.RefreshMonthlyReportUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.usecase.DeleteTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveDailyNetsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionDeletionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionsUseCase
import com.djtech.monai.feature.transactions.presentation.common.mapper.FilterState
import com.djtech.monai.feature.transactions.presentation.common.mapper.reduce
import com.djtech.monai.feature.transactions.presentation.common.mapper.toMessage
import com.djtech.monai.feature.transactions.presentation.common.mapper.withDayHeaders
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.MonthTotals
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionListItem
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletsUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.YearMonth
import javax.inject.Inject

/**
 * One month of transactions, newest first, filtered by wallet, category and type. The list pages
 * from the cache while the API fills it; totals come from the month's report.
 */
@OptIn(ExperimentalCoroutinesApi::class)
@HiltViewModel
class TransactionsViewModel @Inject constructor(
    private val observeTransactions: ObserveTransactionsUseCase,
    private val observeDailyNets: ObserveDailyNetsUseCase,
    private val deleteTransaction: DeleteTransactionUseCase,
    private val observeTransactionDeletions: ObserveTransactionDeletionsUseCase,
    private val observeAllWallets: ObserveAllWalletsUseCase,
    private val refreshWallets: RefreshWalletsUseCase,
    private val observeCategories: ObserveCategoriesUseCase,
    private val observeVisibleCategories: ObserveVisibleCategoriesUseCase,
    private val refreshCategories: RefreshCategoriesUseCase,
    private val observeMonthlyReport: ObserveMonthlyReportUseCase,
    private val refreshMonthlyReport: RefreshMonthlyReportUseCase,
    private val observeCachedExpenseTotals: ObserveCachedExpenseTotalsUseCase,
    private val clock: AppClock,
) : ViewModel() {

    private val filters = MutableStateFlow(FilterState(month = clock.currentMonth(), filter = TransactionFilter()))
    private val selectedId = MutableStateFlow<String?>(null)

    /** Day headers and transactions of the shown month and filters. */
    val transactions: Flow<PagingData<TransactionListItem>> = filters
        .map { it.month to it.filter }
        .distinctUntilChanged()
        .flatMapLatest { (month, filter) -> observeTransactions(month, filter).map { it.withDayHeaders() } }
        .cachedIn(viewModelScope)

    private val lookups: Flow<TransactionLookups> =
        combine(observeCategories(), observeAllWallets(), TransactionLookups::of)

    private val filterCategories: Flow<List<Category>> = combine(
        observeVisibleCategories(CategoryType.EXPENSE),
        observeVisibleCategories(CategoryType.INCOME),
    ) { expense, income -> expense + income }

    private val monthData: Flow<MonthData> = filters
        .map { it.month to it.filter }
        .distinctUntilChanged()
        .flatMapLatest { (month, filter) ->
            combine(observeMonthlyReport(month), observeDailyNets(month, filter)) { report, nets ->
                MonthData(report?.let { MonthTotals(it.incomeTotal, it.expenseTotal) }, nets)
            }
        }

    private val monthPickerTotals: Flow<Map<YearMonth, Long>> = filters
        .map { (it.sheet as? FilterSheet.Month)?.year }
        .distinctUntilChanged()
        .flatMapLatest { year -> if (year == null) flowOf(emptyMap()) else observeCachedExpenseTotals(year) }

    val state: StateFlow<TransactionsState> = combine(
        filters,
        combine(lookups, observeAllWallets(), filterCategories, ::Triple),
        monthData,
        monthPickerTotals,
        selectedId,
    ) { filters, (lookups, wallets, categories), monthData, pickerTotals, selected ->
        initialState().copy(
            month = filters.month,
            filter = filters.filter,
            sheet = filters.sheet,
            lookups = lookups,
            wallets = wallets,
            categories = categories,
            totals = monthData.totals,
            dailyNets = monthData.dailyNets,
            monthPickerTotals = pickerTotals,
            selectedId = selected,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, initialState())

    private val effectChannel = Channel<TransactionsEffect>(Channel.BUFFERED)
    val effects: Flow<TransactionsEffect> = effectChannel.receiveAsFlow()

    init {
        refreshSupportingData()
        viewModelScope.launch {
            // A deleted transaction can't stay in the detail pane.
            observeTransactionDeletions().collect { deleted ->
                selectedId.update { if (it == deleted.id) null else it }
            }
        }
    }

    fun onIntent(intent: TransactionsIntent) {
        when (intent) {
            is TransactionsIntent.Filter -> updateFilters { it.reduce(intent.intent, clock.currentMonth()) }
            TransactionsIntent.PreviousMonth -> updateFilters { it.copy(month = it.month.minusMonths(1)) }
            TransactionsIntent.NextMonth -> updateFilters {
                if (it.month < clock.currentMonth()) it.copy(month = it.month.plusMonths(1)) else it
            }

            TransactionsIntent.Refresh -> refreshSupportingData()
            is TransactionsIntent.Select -> selectedId.value = intent.id
            is TransactionsIntent.Delete -> delete(intent.id)
            is TransactionsIntent.Open -> send(TransactionsEffect.Navigate(intent.destination))
        }
    }

    private fun updateFilters(update: (FilterState) -> FilterState) {
        val before = filters.value.month
        filters.update(update)
        val month = filters.value.month
        if (month != before) {
            selectedId.value = null
            viewModelScope.launch { refreshMonthlyReport(month) }
        }
    }

    // The paged list refreshes itself; these feed the names and totals around it. Failures are
    // quiet: the list reports being offline, and cached names and totals stay on screen.
    private fun refreshSupportingData() {
        val month = filters.value.month
        viewModelScope.launch { refreshWallets() }
        viewModelScope.launch { refreshCategories() }
        viewModelScope.launch { refreshMonthlyReport(month) }
    }

    private fun delete(id: String) {
        viewModelScope.launch {
            val result = deleteTransaction(id)
            if (result is Outcome.Failure) {
                send(TransactionsEffect.ShowMessage(result.error.toMessage(), result.error == TransactionError.Network))
            }
        }
    }

    private fun initialState(): TransactionsState {
        val today: LocalDate = clock.today()
        return TransactionsState(
            month = filters.value.month,
            currentMonth = YearMonth.from(today),
            today = today,
            zone = clock.zone(),
        )
    }

    private fun send(effect: TransactionsEffect) {
        viewModelScope.launch { effectChannel.send(effect) }
    }
}

private data class MonthData(val totals: MonthTotals?, val dailyNets: Map<LocalDate, Long>)
