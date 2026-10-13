package com.djtech.monai.feature.wallets.presentation.walletform

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.test.assertIsDisplayed
import androidx.compose.ui.test.hasClickAction
import androidx.compose.ui.test.hasText
import androidx.compose.ui.test.junit4.v2.createComposeRule
import androidx.compose.ui.test.onNodeWithText
import androidx.compose.ui.test.performClick
import androidx.compose.ui.test.performScrollTo
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.djtech.monai.R
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.theme.MonAITheme
import com.djtech.monai.feature.wallets.domain.model.WalletField
import com.djtech.monai.feature.wallets.presentation.walletform.preview.WalletFormPreviewData
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class WalletFormScreenTest {

    @get:Rule
    val compose = createComposeRule()

    private var state by mutableStateOf(WalletFormPreviewData.add)
    private val intents = mutableListOf<WalletFormIntent>()

    private fun setContent(initial: WalletFormState) {
        state = initial
        compose.setContent {
            MonAITheme(darkTheme = false) { WalletFormScreen(state, onIntent = { intents += it }) }
        }
    }

    @Test
    fun pickingAProviderOrCustomSendsIt() {
        setContent(WalletFormPreviewData.add)

        compose.onNodeWithText("GoPay").performClick()
        compose.onNodeWithText("Custom").performClick()

        assertEquals(listOf(WalletFormIntent.PickProvider("gopay"), WalletFormIntent.PickCustom), intents)
    }

    @Test
    fun aProviderWalletSaysItsTypeIsSetByTheProvider() {
        setContent(WalletFormPreviewData.add)

        compose.onNodeWithText("Set by the provider.").performScrollTo().assertIsDisplayed()
        compose.onNodeWithText("You can rename it — e.g. “BCA Bisnis”.").assertIsDisplayed()
    }

    @Test
    fun aFieldErrorReplacesItsHint() {
        setContent(
            WalletFormPreviewData.add.copy(
                errors = mapOf(WalletField.NAME to UiText.Resource(R.string.wallet_form_error_name_taken)),
            ),
        )

        compose.onNodeWithText("You already have a wallet with this name.").assertIsDisplayed()
    }

    @Test
    fun addingSaves() {
        setContent(WalletFormPreviewData.add)

        // The title says "Add wallet" too; the button is the clickable one.
        compose.onNode(hasText("Add wallet") and hasClickAction()).performClick()

        assertEquals(listOf<WalletFormIntent>(WalletFormIntent.Save), intents)
    }

    @Test
    fun editingShowsHowTheCurrentBalanceShifts() {
        setContent(WalletFormPreviewData.edit)

        compose.onNodeWithText(
            "Changing the starting balance shifts the current balance by the same amount: " +
                "Rp 2.565.000 → Rp 3.065.000 (+Rp 500.000). Your transactions don't change.",
        ).performScrollTo().assertIsDisplayed()
        compose.onNodeWithText("Save").performClick()

        assertEquals(listOf<WalletFormIntent>(WalletFormIntent.Save), intents)
    }
}
