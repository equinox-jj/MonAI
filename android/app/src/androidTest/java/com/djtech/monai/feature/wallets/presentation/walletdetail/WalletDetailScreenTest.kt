package com.djtech.monai.feature.wallets.presentation.walletdetail

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.assertIsNotEnabled
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollToNode
import androidx.paging.PagingData
import androidx.paging.compose.collectAsLazyPagingItems
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletDetailDialog
import com.djtech.monai.feature.wallets.presentation.walletdetail.preview.WalletDetailPreviewData
import kotlinx.coroutines.flow.flowOf
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class WalletDetailScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private var state by mutableStateOf(WalletDetailPreviewData.state)
    private val intents = mutableListOf<WalletDetailIntent>()

    private fun setContent(initial: WalletDetailState = WalletDetailPreviewData.state) {
        state = initial
        compose.setContent {
            val items = remember { flowOf(PagingData.from(WalletDetailPreviewData.transactions)) }
                .collectAsLazyPagingItems()
            MonAITheme(darkTheme = false) { WalletDetailScreen(state, items, onIntent = { intents += it }) }
        }
    }

    @Test
    fun showsTheBalanceAndTheMonthsMoneyOut() {
        setContent()

        compose.onNodeWithText("Rp 8.250.000").assertIsDisplayed()
        compose.onNodeWithText("Money out · October").assertIsDisplayed()
        compose.onNodeWithText("−Rp 1.097.500").assertIsDisplayed()
    }

    @Test
    fun theDefaultWalletCantBeArchivedAndSaysWhy() {
        setContent()

        compose.onNodeWithText("Archive").assertIsNotEnabled()
        compose.onNodeWithText(
            "Your default wallet can't be archived. Make another wallet the default first.",
        ).assertIsDisplayed()
    }

    @Test
    fun aTransferOutReadsAsMoneyOutToTheOtherWallet() {
        setContent()

        compose.onNodeWithTag(WalletDetailTestTags.LIST).performScrollToNode(hasText("Top up GoPay"))
        compose.onNodeWithText("Transfer to GoPay · 9 Oct", substring = true).assertIsDisplayed()
        compose.onNodeWithText("−Rp 500.000").assertIsDisplayed()
    }

    @Test
    fun actionsSendTheirIntents() {
        setContent(WalletDetailPreviewData.state.copy(wallet = WalletDetailPreviewData.bca.copy(isDefault = false)))

        compose.onNodeWithText("Edit").performClick()
        compose.onNodeWithText("Transfer").performClick()
        compose.onNodeWithText("Archive").performClick()
        compose.onNodeWithContentDescription("More options").performClick()
        compose.onNodeWithText("Delete").performClick()

        assertEquals(
            listOf(
                WalletDetailIntent.Edit,
                WalletDetailIntent.Transfer,
                WalletDetailIntent.Archive,
                WalletDetailIntent.Delete,
            ),
            intents,
        )
    }

    @Test
    fun aRefusedDeleteOffersToArchive() {
        setContent(
            WalletDetailPreviewData.state.copy(
                wallet = WalletDetailPreviewData.bca.copy(isDefault = false),
                dialog = WalletDetailDialog.ArchiveInstead,
            ),
        )

        compose.onNodeWithText("Archive BCA Tabungan instead?").assertIsDisplayed()
        compose.onNodeWithText("You can unarchive any time").assertIsDisplayed()
    }
}
