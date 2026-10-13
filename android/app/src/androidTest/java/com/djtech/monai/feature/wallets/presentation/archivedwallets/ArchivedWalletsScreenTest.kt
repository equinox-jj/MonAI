package com.djtech.monai.feature.wallets.presentation.archivedwallets

import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onAllNodesWithText
import androidx.compose.ui.test.onFirst
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.presentation.archivedwallets.preview.ArchivedWalletsPreviewData
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class ArchivedWalletsScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private val intents = mutableListOf<ArchivedWalletsIntent>()

    private fun setContent(state: ArchivedWalletsState) {
        compose.setContent {
            MonAITheme(darkTheme = false) { ArchivedWalletsScreen(state, onIntent = { intents += it }) }
        }
    }

    @Test
    fun listsEachArchivedWalletWithItsTypeAndBalance() {
        setContent(ArchivedWalletsPreviewData.list)

        compose.onNodeWithText("Mandiri").assertIsDisplayed()
        compose.onNodeWithText("Bank · Rp 3.065.000").assertIsDisplayed()
    }

    @Test
    fun unarchiveSendsTheWallet() {
        setContent(ArchivedWalletsPreviewData.list)

        compose.onAllNodesWithText("Unarchive").onFirst().performClick()

        assertEquals(listOf<ArchivedWalletsIntent>(ArchivedWalletsIntent.Unarchive("mandiri")), intents)
    }

    @Test
    fun anEmptyArchiveSaysSo() {
        setContent(ArchivedWalletsState())

        compose.onNodeWithText("No archived wallets").assertIsDisplayed()
    }
}
