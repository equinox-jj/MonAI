package com.djtech.monai.feature.home.presentation.home

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.WhileUiSubscribed
import com.djtech.monai.core.common.format.initialsOf
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.ui.EffectQueue
import com.djtech.monai.core.common.ui.RefreshStatus
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.MonthlyReport
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.User
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.feature.budgets.domain.model.BudgetError
import com.djtech.monai.feature.budgets.domain.usecase.ObserveBudgetUseCase
import com.djtech.monai.feature.budgets.domain.usecase.RefreshBudgetUseCase
import com.djtech.monai.feature.categories.domain.model.CategoryError
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.RefreshCategoriesUseCase
import com.djtech.monai.feature.home.presentation.home.mapper.daysLeftInMonth
import com.djtech.monai.feature.home.presentation.home.mapper.greetingFor
import com.djtech.monai.feature.home.presentation.home.mapper.toRecent
import com.djtech.monai.feature.home.presentation.home.mapper.toSpendingSlices
import com.djtech.monai.feature.home.presentation.home.mapper.toSummary
import com.djtech.monai.feature.home.presentation.home.model.BudgetCard
import com.djtech.monai.feature.home.presentation.home.model.Greeting
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.usecase.ObserveUserUseCase
import com.djtech.monai.feature.profile.domain.usecase.RefreshUserUseCase
import com.djtech.monai.feature.reports.domain.model.ReportError
import com.djtech.monai.feature.reports.domain.usecase.ObserveMonthlyReportUseCase
import com.djtech.monai.feature.reports.domain.usecase.RefreshMonthlyReportUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.usecase.ObserveRecentTransactionsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshRecentTransactionsUseCase
import com.djtech.monai.feature.wallets.domain.model.WalletError
import com.djtech.monai.feature.wallets.domain.model.totalBalance
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.RefreshWalletsUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.LocalTime
import java.time.YearMonth
import javax.inject.Inject

/** Rows in the recent transactions list. */
internal const val RECENT_TRANSACTION_LIMIT = 5

/**
 * Shows the cache at once and refreshes every section from the API in the background. A failed
 * refresh keeps what is cached; only a first load with nothing cached replaces the dashboard.
 */
@OptIn(ExperimentalCoroutinesApi::class)
@HiltViewModel
class HomeViewModel @Inject constructor(
    private val observeUser: ObserveUserUseCase,
    private val refreshUser: RefreshUserUseCase,
    private val observeAllWallets: ObserveAllWalletsUseCase,
    private val refreshWallets: RefreshWalletsUseCase,
    private val observeCategories: ObserveCategoriesUseCase,
    private val refreshCategories: RefreshCategoriesUseCase,
    private val observeRecentTransactions: ObserveRecentTransactionsUseCase,
    private val refreshRecentTransactions: RefreshRecentTransactionsUseCase,
    private val observeBudget: ObserveBudgetUseCase,
    private val refreshBudget: RefreshBudgetUseCase,
    private val observeMonthlyReport: ObserveMonthlyReportUseCase,
    private val refreshMonthlyReport: RefreshMonthlyReportUseCase,
    private val clock: AppClock,
    private val savedState: SavedStateHandle,
) : ViewModel() {

    // Read again on every refresh, so the greeting, "today" and the month move on.
    private val moment = MutableStateFlow(readMoment())
    private val load = MutableStateFlow(LoadStatus())
    private val isBalanceHidden = savedState.getStateFlow(KEY_BALANCE_HIDDEN, false)

    private val content: Flow<HomeContent> = moment
        .map { it.month }
        .distinctUntilChanged()
        .flatMapLatest(::observeContent)

    val state: StateFlow<HomeState> = combine(
        content,
        moment,
        load,
        isBalanceHidden,
        ::toState,
    )
        .stateIn(viewModelScope, WhileUiSubscribed, HomeState(month = moment.value.month))

    private val effectQueue = EffectQueue<HomeEffect>()
    val effects: Flow<HomeEffect> = effectQueue.flow

    init {
        refresh(userInitiated = false)
    }

    fun onIntent(intent: HomeIntent) {
        when (intent) {
            HomeIntent.Refresh -> refresh(userInitiated = true)
            HomeIntent.ToggleBalanceVisibility -> savedState[KEY_BALANCE_HIDDEN] = !isBalanceHidden.value
            is HomeIntent.Open -> effectQueue.send(HomeEffect.Navigate(intent.destination))
        }
    }

    private fun observeContent(month: YearMonth): Flow<HomeContent> = combine(
        observeUser(),
        observeAllWallets(),
        observeCategories(),
        observeRecentTransactions(month, RECENT_TRANSACTION_LIMIT),
        combine(observeBudget(month), observeMonthlyReport(month), ::Pair),
    ) { user, wallets, categories, recent, (budget, report) ->
        HomeContent(
            month = month,
            user = user,
            wallets = wallets,
            categories = categories,
            recent = recent,
            budget = budget,
            report = report,
        )
    }

    private fun refresh(userInitiated: Boolean) {
        if (load.value.refresh.isRunning) return
        val current = readMoment()
        val month = current.month
        moment.value = current
        load.update { it.copy(refresh = it.refresh.started(userInitiated)) }

        viewModelScope.launch {
            val (budget, recent, others) = coroutineScope {
                val budget = async { refreshBudget(month) }
                val recent = async { refreshRecentTransactions(month, RECENT_TRANSACTION_LIMIT) }
                val others = listOf(
                    async { refreshUser() },
                    async { refreshWallets() },
                    async { refreshCategories() },
                    async { refreshMonthlyReport(month) },
                )
                Triple(budget.await(), recent.await(), others.awaitAll())
            }
            val failure = failureOf(listOf(budget, recent) + others)
            load.update {
                it.copy(
                    refresh = it.refresh.finished(failure),
                    budgetLoadedFor = if (budget is Outcome.Success) month else it.budgetLoadedFor,
                    transactionsLoadedFor = if (recent is Outcome.Success) month else it.transactionsLoadedFor,
                )
            }
            // With nothing cached the state shows the error itself, so there's no message too.
            if (failure != null && hasCachedContent()) {
                effectQueue.send(
                    HomeEffect.ShowMessage(failure.refreshMessage(), isOffline = failure == LoadFailure.NETWORK),
                )
            }
        }
    }

    private suspend fun hasCachedContent(): Boolean =
        observeUser().first() != null || observeAllWallets().first().isNotEmpty()

    private fun toState(
        content: HomeContent,
        moment: Moment,
        load: LoadStatus,
        isBalanceHidden: Boolean,
    ): HomeState {
        val hasCache = content.user != null || content.wallets.isNotEmpty()
        val categoriesById = content.categories.associateBy(Category::id)
        val walletsById = content.wallets.associateBy(Wallet::id)
        val recent = content.recent.map {
            it.toRecent(
                categoriesById,
                walletsById,
                moment.today,
                clock.zone(),
            )
        }
        val nothingThisMonth = load.transactionsLoadedFor == content.month && recent.isEmpty()
        return HomeState(
            month = content.month,
            isLoading = load.refresh.isLoading(hasCache),
            loadError = load.refresh.loadFailure(hasCache)?.loadMessage(),
            isRefreshing = load.refresh.isRefreshing(hasCache),
            greeting = if (nothingThisMonth) Greeting.WELCOME else greetingFor(moment.time),
            userName = content.user?.name.orEmpty(),
            initials = initialsOf(content.user?.name.orEmpty()),
            avatarUrl = content.user?.avatarUrl,
            isBalanceHidden = isBalanceHidden,
            totalBalance = content.wallets.totalBalance(),
            wallets = content.wallets.filterNot(Wallet::isArchived),
            summary = content.report?.toSummary(),
            budget = when {
                content.budget != null -> BudgetCard.Set(content.budget, daysLeftInMonth(moment.today))
                load.budgetLoadedFor == content.month -> BudgetCard.NotSet
                else -> null
            },
            spending = content.report?.categories?.toSpendingSlices().orEmpty(),
            recent = recent,
        )
    }

    private fun readMoment() = Moment(clock.today(), clock.localTime())

    private companion object {
        const val KEY_BALANCE_HIDDEN = "balance_hidden"
    }
}

private data class Moment(val today: LocalDate, val time: LocalTime) {
    val month: YearMonth get() = YearMonth.from(today)
}

/** What the cache holds for [month]. */
private data class HomeContent(
    val month: YearMonth,
    val user: User?,
    /** Archived ones included, to label their transactions. */
    val wallets: List<Wallet>,
    val categories: List<Category>,
    val recent: List<Transaction>,
    val budget: Budget?,
    val report: MonthlyReport?,
)

/**
 * @param budgetLoadedFor the month whose budget was last fetched, so a missing one means "not set".
 * @param transactionsLoadedFor the month whose transactions were last fetched, so an empty list means "none yet".
 */
private data class LoadStatus(
    val refresh: RefreshStatus<LoadFailure> = RefreshStatus(),
    val budgetLoadedFor: YearMonth? = null,
    val transactionsLoadedFor: YearMonth? = null,
)

private enum class LoadFailure { NETWORK, UNEXPECTED }

/** Being offline explains every other failure, so it wins. */
private fun failureOf(results: List<Outcome<Unit, Any>>): LoadFailure? {
    val errors = results.mapNotNull { (it as? Outcome.Failure)?.error }
    return when {
        errors.isEmpty() -> null
        errors.any(::isNetworkError) -> LoadFailure.NETWORK
        else -> LoadFailure.UNEXPECTED
    }
}

private fun isNetworkError(error: Any): Boolean = when (error) {
    ProfileError.Network,
    WalletError.Network,
    CategoryError.Network,
    TransactionError.Network,
    BudgetError.Network,
    ReportError.Network,
        -> true

    else -> false
}

private fun LoadFailure.refreshMessage(): UiText = UiText.Resource(
    when (this) {
        LoadFailure.NETWORK -> R.string.home_refresh_failed_network
        LoadFailure.UNEXPECTED -> R.string.home_refresh_failed_unexpected
    },
)

private fun LoadFailure.loadMessage(): UiText = UiText.Resource(
    when (this) {
        LoadFailure.NETWORK -> R.string.home_load_failed_network
        LoadFailure.UNEXPECTED -> R.string.home_load_failed_unexpected
    },
)
