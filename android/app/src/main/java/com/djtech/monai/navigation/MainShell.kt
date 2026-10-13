package com.djtech.monai.navigation

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.DialogProperties
import androidx.navigation3.runtime.entryProvider
import androidx.navigation3.scene.DialogSceneStrategy
import androidx.navigation3.ui.NavDisplay
import com.djtech.monai.R
import com.djtech.monai.core.common.time.toApiString
import com.djtech.monai.core.common.time.toYearMonthOrNull
import com.djtech.monai.core.designsystem.component.MonAIBottomBar
import com.djtech.monai.core.designsystem.component.MonAINavigationDrawer
import com.djtech.monai.core.designsystem.component.MonAINavigationRail
import com.djtech.monai.core.designsystem.component.MonAIWidthClass
import com.djtech.monai.core.designsystem.component.currentWidthClass
import com.djtech.monai.core.designsystem.component.monAIMainNavItems
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.budgets.presentation.budget.BudgetRoute
import com.djtech.monai.feature.categories.presentation.categories.CategoriesRoute
import com.djtech.monai.feature.categories.presentation.categoryform.CategoryFormRoute
import com.djtech.monai.feature.home.presentation.home.HomeRoute
import com.djtech.monai.feature.profile.presentation.editprofile.EditProfileRoute
import com.djtech.monai.feature.quickadd.presentation.quickadd.QuickAddRoute
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.QuickAddReviewRoute
import com.djtech.monai.feature.receipt.presentation.receiptreview.ReceiptReviewRoute
import com.djtech.monai.feature.receipt.presentation.scanreceipt.ScanReceiptRoute
import com.djtech.monai.feature.reports.presentation.report.ReportRoute
import com.djtech.monai.feature.settings.presentation.manageproviders.ManageProvidersRoute
import com.djtech.monai.feature.settings.presentation.providerform.ProviderFormRoute
import com.djtech.monai.feature.settings.presentation.settings.SettingsRoute
import com.djtech.monai.feature.settings.presentation.settings.model.SettingsPane
import com.djtech.monai.feature.transactions.presentation.search.SearchRoute
import com.djtech.monai.feature.transactions.presentation.transactiondetail.TransactionDetailRoute
import com.djtech.monai.feature.transactions.presentation.transactionform.TransactionFormRoute
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormPreset
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsRoute
import com.djtech.monai.feature.transactions.presentation.undodelete.UndoDeleteRoute
import com.djtech.monai.feature.wallets.presentation.archivedwallets.ArchivedWalletsRoute
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailRoute
import com.djtech.monai.feature.wallets.presentation.walletform.WalletFormRoute
import com.djtech.monai.feature.wallets.presentation.wallets.WalletsRoute
import java.time.YearMonth

/** The add/edit side sheet's width on a wide screen. */
private val SideSheetWidth = 440.dp

/**
 * The signed-in app: tab navigation around the current destination. Phones get a bottom bar,
 * tablet portrait a rail and tablet landscape a drawer.
 */
@Composable
internal fun MainShell(modifier: Modifier = Modifier) {
    val navigator = rememberMainNavigator()
    val widthClass = currentWidthClass()
    val items = monAIMainNavItems(
        home = stringResource(R.string.nav_home),
        transactions = stringResource(R.string.nav_transactions),
        wallets = stringResource(R.string.nav_wallets),
        settings = stringResource(R.string.nav_settings),
    )
    val selectedIndex = navigator.currentTab.ordinal
    val onItemClick =
        remember(navigator) { { index: Int -> navigator.selectTab(TopLevelDestination.entries[index]) } }
    val onAddClick = remember(navigator) { { navigator.navigate(TransactionFormRoute()) } }
    val addLabel = stringResource(R.string.nav_add_transaction)
    val content = @Composable { modifier: Modifier -> MainNavDisplay(navigator, widthClass, modifier) }

    when (widthClass) {
        MonAIWidthClass.Compact -> Column(modifier.fillMaxSize()) {
            content(Modifier.weight(1f))
            // Detail, form and search take the whole phone screen.
            if (!navigator.backStack.last().isFullScreen()) {
                MonAIBottomBar(
                    items,
                    selectedIndex,
                    onItemClick,
                    onAddClick,
                    addLabel,
                )
            }
        }

        MonAIWidthClass.Medium -> Row(modifier.fillMaxSize()) {
            MonAINavigationRail(
                items,
                selectedIndex,
                onItemClick,
                onAddClick,
                addLabel,
            )
            content(Modifier.weight(1f))
        }

        MonAIWidthClass.Expanded -> Row(modifier.fillMaxSize()) {
            MonAINavigationDrawer(
                stringResource(R.string.app_name),
                items,
                selectedIndex,
                onItemClick,
                onAddClick,
                addLabel,
            )
            content(Modifier.weight(1f))
        }
    }
}

@Composable
private fun MainNavDisplay(
    navigator: MainNavigator,
    widthClass: MonAIWidthClass,
    modifier: Modifier = Modifier,
) {
    val isExpanded = widthClass == MonAIWidthClass.Expanded
    // On a wide screen the form opens as a side sheet over what is behind it.
    val formMetadata = if (isExpanded) {
        DialogSceneStrategy.dialog(DialogProperties(usePlatformDefaultWidth = false))
    } else {
        emptyMap()
    }
    val openTransaction = { id: String -> navigator.navigate(TransactionDetailRoute(id)) }
    val editTransaction = { id: String -> navigator.navigate(TransactionFormRoute(id)) }
    Box(modifier) {
        // Each tab keeps its entries' ViewModels while another tab is shown, so switching tabs doesn't refetch.
        val entries = rememberMainNavEntries(
            navigator,
            entryProvider {
                entry<HomeRoute> { HomeRoute(onNavigate = navigator::openFromHome) }
                entry<TransactionsRoute> {
                    TransactionsRoute(
                        onNavigate = navigator::openFromTransactions,
                        detailPane = { id, paneModifier ->
                            TransactionDetailRoute(
                                transactionId = id,
                                onBack = {},
                                onEdit = editTransaction,
                                modifier = paneModifier,
                                isPane = true,
                            )
                        },
                    )
                }
                entry<TransactionDetailRoute> { key ->
                    TransactionDetailRoute(
                        transactionId = key.id,
                        onBack = navigator::goBack,
                        onEdit = editTransaction,
                    )
                }
                entry<TransactionFormRoute>(metadata = formMetadata) { key ->
                    SideSheetEntry(asSideSheet = isExpanded) { sheetModifier ->
                        TransactionFormRoute(
                            transactionId = key.id,
                            onClose = navigator::goBack,
                            onDeleted = navigator::closeDeletedTransaction,
                            onNewCategory = { type -> navigator.navigate(CategoryFormRoute(type)) },
                            modifier = sheetModifier,
                            preset = TransactionFormPreset(
                                type = key.presetType ?: TransactionType.EXPENSE,
                                walletId = key.presetWalletId,
                                draft = key.draft?.toModel(),
                            ),
                            onSaved = { if (key.draft != null) navigator.closeQuickAdd() else navigator.goBack() },
                            // Scanning is offered only on a blank add form.
                            onScan = if (key.id == null && key.draft == null) {
                                { navigator.navigate(ScanReceiptRoute) }
                            } else {
                                null
                            },
                            isSideSheet = isExpanded,
                        )
                    }
                }
                entry<QuickAddRoute> {
                    QuickAddRoute(
                        onClose = navigator::goBack,
                        onOpenForm = navigator::openDraftForm,
                        onOpenReview = navigator::openDraftReview,
                    )
                }
                entry<ScanReceiptRoute> {
                    ScanReceiptRoute(
                        onClose = navigator::goBack,
                        onOpenReview = navigator::openReceiptReview,
                        onOpenForm = navigator::typeInsteadOfScan,
                    )
                }
                entry<ReceiptReviewRoute> { key ->
                    ReceiptReviewRoute(
                        photoUri = key.photoUri,
                        receipt = key.draft.toModel(),
                        aiFailed = key.aiFailed,
                        onBack = navigator::goBack,
                        onRetake = navigator::goBack,
                        onSaved = navigator::showSavedReceipt,
                    )
                }
                entry<QuickAddReviewRoute> { key ->
                    QuickAddReviewRoute(
                        phrase = key.phrase,
                        drafts = key.drafts.map { it.toModel() },
                        onBack = navigator::goBack,
                        onFinish = navigator::closeQuickAdd,
                    )
                }
                entry<TransactionSearchRoute> { key ->
                    SearchRoute(
                        initialMonth = key.month,
                        onBack = navigator::goBack,
                        onOpenTransaction = openTransaction,
                    )
                }
                entry<WalletsRoute> {
                    WalletsRoute(
                        onNavigate = navigator::openFromWallets,
                        detailPane = { id, paneModifier ->
                            // Deleting from the pane needs no navigation: the list shows the next wallet.
                            WalletDetailRoute(
                                walletId = id,
                                onNavigate = navigator::openFromWalletDetail,
                                onBack = {},
                                onDeleted = {},
                                modifier = paneModifier,
                                isPane = true,
                            )
                        },
                    )
                }
                entry<WalletDetailRoute> { key ->
                    WalletDetailRoute(
                        walletId = key.id,
                        onNavigate = navigator::openFromWalletDetail,
                        onBack = navigator::goBack,
                        onDeleted = navigator::closeDeletedWallet,
                    )
                }
                entry<WalletFormRoute>(metadata = formMetadata) { key ->
                    SideSheetEntry(asSideSheet = isExpanded) { sheetModifier ->
                        WalletFormRoute(
                            walletId = key.id,
                            onClose = navigator::goBack,
                            onDeleted = navigator::closeDeletedWallet,
                            modifier = sheetModifier,
                            isSideSheet = isExpanded,
                        )
                    }
                }
                entry<ArchivedWalletsRoute> {
                    ArchivedWalletsRoute(
                        onBack = navigator::goBack,
                        onOpenWallet = { id -> navigator.navigate(WalletDetailRoute(id)) },
                    )
                }
                entry<CategoryFormRoute>(metadata = formMetadata) { key ->
                    SideSheetEntry(asSideSheet = isExpanded) { sheetModifier ->
                        CategoryFormRoute(
                            type = key.type,
                            onClose = navigator::goBack,
                            modifier = sheetModifier,
                            categoryId = key.id,
                            isSideSheet = isExpanded,
                        )
                    }
                }
                entry<ReportRoute> { key ->
                    ReportRoute(
                        initialMonth = key.month?.toYearMonthOrNull(),
                        onOpenBudget = { month -> navigator.navigate(BudgetRoute(month.toApiString())) },
                        onBack = navigator::goBack,
                    )
                }
                entry<BudgetRoute> { key ->
                    // Keys are only built with toApiString, so the month always parses.
                    BudgetRoute(month = YearMonth.parse(key.month), onClose = navigator::goBack)
                }
                entry<SettingsRoute> {
                    SettingsRoute(
                        onNavigate = navigator::openFromSettings,
                        detailPane = { pane, month, paneModifier ->
                            SettingsDetailPane(
                                navigator,
                                pane,
                                month,
                                paneModifier,
                            )
                        },
                    )
                }
                entry<EditProfileRoute> { key ->
                    EditProfileRoute(onClose = navigator::goBack, focusDelete = key.focusDelete)
                }
                entry<CategoriesRoute> {
                    CategoriesRoute(onNavigate = navigator::openFromCategories, onBack = navigator::goBack)
                }
                entry<ManageProvidersRoute> {
                    ManageProvidersRoute(onOpenForm = navigator::openProviderForm, onBack = navigator::goBack)
                }
                entry<ProviderFormRoute>(metadata = formMetadata) { key ->
                    SideSheetEntry(asSideSheet = isExpanded) { sheetModifier ->
                        ProviderFormRoute(
                            providerId = key.id,
                            onClose = navigator::goBack,
                            modifier = sheetModifier,
                            isSideSheet = isExpanded,
                        )
                    }
                }
            },
        )
        NavDisplay(
            entries = entries,
            sceneStrategies = listOf(DialogSceneStrategy()),
            onBack = navigator::goBack,
        )
        UndoDeleteRoute(Modifier.align(Alignment.BottomCenter))
    }
}

/** A Settings section beside the menu on a wide screen; its forms open over it as side sheets. */
@Composable
private fun SettingsDetailPane(
    navigator: MainNavigator,
    pane: SettingsPane,
    month: YearMonth,
    modifier: Modifier,
) {
    when (pane) {
        SettingsPane.Profile -> EditProfileRoute(onClose = {}, modifier = modifier, isPane = true)
        SettingsPane.Budget -> BudgetRoute(
            month = month,
            onClose = {},
            modifier = modifier,
            isPane = true,
        )

        SettingsPane.Categories -> CategoriesRoute(
            onNavigate = navigator::openFromCategories,
            onBack = {},
            modifier = modifier,
            isPane = true,
        )

        SettingsPane.Providers -> ManageProvidersRoute(
            onOpenForm = navigator::openProviderForm,
            onBack = {},
            modifier = modifier,
            isPane = true,
        )

        // Drawn by Settings itself.
        SettingsPane.Theme, SettingsPane.Language -> Unit
    }
}

/**
 * An add/edit form: full screen, or as an end-aligned sheet over what is behind it when
 * [asSideSheet]. [content] gets the modifier that sizes and shapes it.
 */
@Composable
private fun SideSheetEntry(asSideSheet: Boolean, content: @Composable (Modifier) -> Unit) {
    if (!asSideSheet) {
        content(Modifier)
        return
    }
    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.CenterEnd) {
        content(
            Modifier
                .width(SideSheetWidth)
                .fillMaxHeight()
                .clip(RoundedCornerShape(topStart = MonAITheme.radius.xxl, bottomStart = MonAITheme.radius.xxl))
                .background(MonAITheme.colors.surface),
        )
    }
}
