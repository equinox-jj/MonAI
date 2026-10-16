package com.djtech.monai.feature.transactions.presentation.search

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.paging.PagingData
import androidx.paging.cachedIn
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.time.toYearMonthOrNull
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.datastore.SearchHistoryStore
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveVisibleCategoriesUseCase
import com.djtech.monai.feature.reports.domain.usecase.ObserveCachedExpenseTotalsUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionFilter
import com.djtech.monai.feature.transactions.domain.usecase.SearchTransactionsUseCase
import com.djtech.monai.feature.transactions.presentation.common.mapper.FilterState
import com.djtech.monai.feature.transactions.presentation.common.mapper.reduce
import com.djtech.monai.feature.transactions.presentation.common.model.FilterIntent
import com.djtech.monai.feature.transactions.presentation.common.model.FilterSheet
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import dagger.assisted.Assisted
import dagger.assisted.AssistedFactory
import dagger.assisted.AssistedInject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.time.YearMonth

/** Waits for typing to pause before searching, so each keystroke isn't a request. */
internal const val SEARCH_DEBOUNCE_MS = 300L

/**
 * Searches notes and merchants as the user types: in one month on the server, or across every
 * cached month on the device. [initialMonth] (`YYYY-MM`) is the month the list was showing.
 */
@OptIn(ExperimentalCoroutinesApi::class, FlowPreview::class)
@HiltViewModel(assistedFactory = SearchViewModel.Factory::class)
class SearchViewModel @AssistedInject constructor(
    @Assisted initialMonth: String?,
    private val searchTransactions: SearchTransactionsUseCase,
    observeCategories: ObserveCategoriesUseCase,
    observeVisibleCategories: ObserveVisibleCategoriesUseCase,
    observeAllWallets: ObserveAllWalletsUseCase,
    private val observeCachedExpenseTotals: ObserveCachedExpenseTotalsUseCase,
    private val searchHistoryStore: SearchHistoryStore,
    private val clock: AppClock,
) : ViewModel() {

    @AssistedFactory
    interface Factory {
        fun create(initialMonth: String?): SearchViewModel
    }

    private val query = MutableStateFlow("")
    private val allMonths = MutableStateFlow(false)
    private val filters = MutableStateFlow(
        FilterState(
            month = initialMonth?.toYearMonthOrNull()?.coerceAtMost(clock.currentMonth()) ?: clock.currentMonth(),
            filter = TransactionFilter(),
        ),
    )

    /** Results for the text once typing pauses; nothing while it is blank. */
    val results: Flow<PagingData<Transaction>> = combine(
        query.debounce { if (it.isBlank()) 0 else SEARCH_DEBOUNCE_MS }.map(String::trim).distinctUntilChanged(),
        allMonths,
        filters.map { it.month to it.filter }.distinctUntilChanged(),
    ) { text, all, (month, filter) -> Triple(text, if (all) null else month, filter) }
        .distinctUntilChanged()
        .flatMapLatest { (text, month, filter) -> searchTransactions(text, month, filter) }
        .cachedIn(viewModelScope)

    private val filterCategories: Flow<List<Category>> = combine(
        observeVisibleCategories(CategoryType.EXPENSE),
        observeVisibleCategories(CategoryType.INCOME),
    ) { expense, income -> expense + income }

    private val monthPickerTotals: Flow<Map<YearMonth, Long>> = filters
        .map { (it.sheet as? FilterSheet.Month)?.year }
        .distinctUntilChanged()
        .flatMapLatest { year -> if (year == null) flowOf(emptyMap()) else observeCachedExpenseTotals(year) }

    val state: StateFlow<SearchState> = combine(
        combine(query, allMonths, filters, ::Triple),
        combine(observeCategories(), observeAllWallets(), TransactionLookups::of),
        combine(observeAllWallets(), filterCategories, ::Pair),
        monthPickerTotals,
        searchHistoryStore.recentSearches,
    ) { (query, all, filters), lookups, (wallets, categories), pickerTotals, recent ->
        initialState().copy(
            month = filters.month,
            query = query,
            allMonths = all,
            filter = filters.filter,
            sheet = filters.sheet,
            lookups = lookups,
            wallets = wallets,
            categories = categories,
            monthPickerTotals = pickerTotals,
            recentSearches = recent,
        )
    }.stateIn(viewModelScope, WhileUiSubscribed, initialState())

    private val effectQueue = EffectQueue<SearchEffect>()
    val effects: Flow<SearchEffect> = effectQueue.flow

    fun onIntent(intent: SearchIntent) {
        when (intent) {
            is SearchIntent.QueryChanged -> query.value = intent.query
            SearchIntent.Submit -> remember(query.value)
            SearchIntent.ClearQuery -> query.value = ""
            is SearchIntent.UseRecent -> {
                query.value = intent.query
                remember(intent.query)
            }

            SearchIntent.SearchAllMonths -> allMonths.value = true
            SearchIntent.SearchMonthOnly -> allMonths.value = false
            is SearchIntent.Filter -> {
                // Picking a month means searching that month.
                if (intent.intent is FilterIntent.Apply && filters.value.sheet is FilterSheet.Month) {
                    allMonths.value = false
                }
                filters.update { it.reduce(intent.intent, clock.currentMonth()) }
            }

            is SearchIntent.OpenResult -> {
                remember(query.value)
                effectQueue.send(SearchEffect.OpenTransaction(intent.id))
            }

            SearchIntent.Back -> effectQueue.send(SearchEffect.NavigateBack)
        }
    }

    private fun remember(text: String) {
        if (text.isBlank()) return
        viewModelScope.launch { searchHistoryStore.add(text) }
    }

    private fun initialState() = SearchState(
        month = filters.value.month,
        currentMonth = clock.currentMonth(),
        today = clock.today(),
        zone = clock.zone(),
    )
}
