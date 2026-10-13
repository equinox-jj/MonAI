package com.djtech.monai.navigation

import androidx.compose.runtime.mutableStateOf
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavKey
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.feature.transactions.presentation.transactions.TransactionsDestination
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import java.time.YearMonth

class TransactionsNavigationTest {

    private val navigator = MainNavigator(
        stacks = TopLevelDestination.entries.associateWith { NavBackStack<NavKey>(it.route) },
        currentTab = mutableStateOf(TopLevelDestination.Transactions),
    )

    @Test
    fun `the list's links open on the transactions tab`() {
        navigator.openFromTransactions(TransactionsDestination.Search(YearMonth.of(2026, 9)))
        navigator.openFromTransactions(TransactionsDestination.Detail("t1"))
        navigator.openFromTransactions(TransactionsDestination.Edit("t1"))
        navigator.openFromTransactions(TransactionsDestination.Add)

        assertEquals(
            listOf(
                HomeRoute,
                TransactionsRoute,
                TransactionSearchRoute("2026-09"),
                TransactionDetailRoute("t1"),
                TransactionFormRoute("t1"),
                TransactionFormRoute(),
            ),
            navigator.backStack,
        )
    }

    @Test
    fun `deleting from the edit form closes it and that transaction's detail`() {
        navigator.navigate(TransactionDetailRoute("t1"))
        navigator.navigate(TransactionFormRoute("t1"))

        navigator.closeDeletedTransaction("t1")

        assertEquals(listOf(HomeRoute, TransactionsRoute), navigator.backStack)
    }

    @Test
    fun `closing a deleted transaction leaves other screens alone`() {
        navigator.navigate(TransactionDetailRoute("other"))

        navigator.closeDeletedTransaction("t1")

        assertEquals(listOf(HomeRoute, TransactionsRoute, TransactionDetailRoute("other")), navigator.backStack)
    }

    @Test
    fun `detail, form, search and the category form are full screen, tab roots are not`() {
        assertTrue(TransactionDetailRoute("t1").isFullScreen())
        assertTrue(TransactionFormRoute().isFullScreen())
        assertTrue(CategoryFormRoute(CategoryType.EXPENSE).isFullScreen())
        assertTrue(TransactionSearchRoute().isFullScreen())
        assertFalse(TransactionsRoute.isFullScreen())
        assertFalse(HomeRoute.isFullScreen())
    }
}
