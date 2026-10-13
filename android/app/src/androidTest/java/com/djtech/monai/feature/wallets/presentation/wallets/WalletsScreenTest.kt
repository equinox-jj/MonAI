package com.djtech.monai.feature.wallets.presentation.wallets

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithContentDescription
import androidx.compose.ui.test.onNodeWithTag
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollToNode
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.MonAIWidthClass
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.wallets.preview.WalletsPreviewData
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class WalletsScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private var state by mutableStateOf(WalletsPreviewData.list)
    private val intents = mutableListOf<WalletsIntent>()

    private fun setContent(
        initial: WalletsState = WalletsPreviewData.list,
        widthClass: MonAIWidthClass = MonAIWidthClass.Compact,
    ) {
        state = initial
        compose.setContent {
            MonAITheme(darkTheme = false) {
                WalletsScreen(state, onIntent = { intents += it }, widthClass = widthClass)
            }
        }
    }

    @Test
    fun showsTheTotalAndItsSplitByType() {
        setContent()

        compose.onNodeWithText("Total across 4 wallets").assertIsDisplayed()
        compose.onNodeWithText("Rp 12.450.000").assertIsDisplayed()
        compose.onNodeWithContentDescription("Bank 87%", substring = true).assertIsDisplayed()
    }

    @Test
    fun tappingAWalletOpensItsDetail() {
        setContent()

        compose.onNodeWithText("GoPay").performClick()

        assertEquals(listOf<WalletsIntent>(WalletsIntent.Open(WalletsDestination.Detail("gopay"))), intents)
    }

    @Test
    fun onAWideScreenTappingAWalletShowsItBeside() {
        setContent(widthClass = MonAIWidthClass.Expanded)

        compose.onNodeWithText("GoPay").performClick()

        assertEquals(listOf<WalletsIntent>(WalletsIntent.Select("gopay")), intents)
    }

    @Test
    fun theArchivedLinkOpensTheArchive() {
        setContent()

        compose.onNodeWithTag(WalletsTestTags.LIST).performScrollToNode(hasText("Show 1 archived wallet"))
        compose.onNodeWithText("Show 1 archived wallet").performClick()

        assertEquals(listOf<WalletsIntent>(WalletsIntent.Open(WalletsDestination.Archived)), intents)
    }

    @Test
    fun addWalletOpensTheForm() {
        setContent()

        compose.onNodeWithText("Add wallet").performClick()

        assertEquals(listOf<WalletsIntent>(WalletsIntent.Open(WalletsDestination.Add)), intents)
    }

    @Test
    fun aFailedFirstLoadOffersARetry() {
        setContent(WalletsState(isLoading = false, loadError = UiText.Resource(R.string.wallets_load_failed_network)))

        compose.onNodeWithText("Couldn't load your wallets").assertIsDisplayed()
        compose.onNodeWithText("Try again").performClick()

        assertEquals(listOf<WalletsIntent>(WalletsIntent.Refresh), intents)
    }
}
