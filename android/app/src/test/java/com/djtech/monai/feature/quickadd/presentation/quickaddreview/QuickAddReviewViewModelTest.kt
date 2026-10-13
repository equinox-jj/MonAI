package com.djtech.monai.feature.quickadd.presentation.quickaddreview

import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.draftConfidence
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewOutcome
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewSheet
import com.djtech.monai.feature.quickadd.presentation.quickaddreview.model.ReviewWalletTarget
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.CreateTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.DependentRepositories
import com.djtech.monai.feature.transactions.domain.usecase.testClock
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class QuickAddReviewViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val transactions = FakeTransactionRepository()
    private val kopi = draft(
        amount = 25_000,
        walletId = null,
        note = "Kopi",
        confidence = draftConfidence(wallet = 0.5),
    )
    private val parkir = draft(
        amount = null,
        categoryId = "transport",
        note = "Parkir",
        confidence = draftConfidence(amount = 0.0),
    )

    private fun runReviewTest(
        block: suspend TestScope.(QuickAddReviewViewModel, MutableList<QuickAddReviewEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val clock = testClock()
        val viewModel = QuickAddReviewViewModel(
            phrase = "kopi 25rb sama parkir",
            drafts = listOf(kopi, parkir),
            createTransaction = CreateTransactionUseCase(
                transactions,
                DependentRepositories().refreshDependents,
                clock,
            ),
            observeWallets = ObserveWalletsUseCase(
                FakeWalletRepository(listOf(wallet("bca", name = "BCA", isDefault = true), wallet("gopay"))),
            ),
            observeCategories = ObserveCategoriesUseCase(
                FakeCategoryRepository(
                    listOf(category("food", name = "Food"), category("transport", name = "Transport")),
                ),
            ),
            clock = clock,
        )
        val effects = mutableListOf<QuickAddReviewEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: QuickAddReviewViewModel, vararg intents: QuickAddReviewIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `shows the first draft with the default wallet marked for review`() = runReviewTest { vm, _ ->
        val state = vm.state.value
        assertEquals(0, state.index)
        assertEquals(2, state.total)
        assertEquals("Food", state.category?.name)
        assertEquals("BCA", state.walletName)
        assertEquals(FieldHighlight.Low, state.draft?.highlights?.get(TransactionField.WALLET))
    }

    @Test
    fun `save creates a quick add and moves on`() = runReviewTest { vm, _ ->
        send(vm, QuickAddReviewIntent.Save)

        val input = transactions.created.single()
        assertEquals(25_000L, input.amount)
        assertEquals("bca", input.walletId)
        assertEquals(TransactionSource.QUICK_ADD, input.source)
        assertEquals(1, vm.state.value.index)
        assertEquals("Transport", vm.state.value.category?.name)
    }

    @Test
    fun `a draft without an amount can't be saved until one is typed`() = runReviewTest { vm, _ ->
        send(vm, QuickAddReviewIntent.Skip, QuickAddReviewIntent.Save)

        assertTrue(vm.state.value.errors.containsKey(TransactionField.AMOUNT))
        assertEquals(1, vm.state.value.index)

        send(
            vm,
            QuickAddReviewIntent.OpenAmount,
            QuickAddReviewIntent.SheetAmount(5_000),
            QuickAddReviewIntent.ConfirmSheet,
        )
        assertEquals(5_000L, vm.state.value.draft?.amount)
        assertEquals(null, vm.state.value.draft?.highlights?.get(TransactionField.AMOUNT))

        send(vm, QuickAddReviewIntent.Save)

        assertTrue(vm.state.value.isDone)
        assertEquals(listOf(ReviewOutcome.SKIPPED, ReviewOutcome.SAVED), vm.state.value.summary.map { it.outcome })
        assertEquals(1, vm.state.value.savedCount)
    }

    @Test
    fun `pickers apply on confirm`() = runReviewTest { vm, _ ->
        send(vm, QuickAddReviewIntent.OpenWallet(ReviewWalletTarget.SOURCE))
        assertEquals(ReviewSheet.Wallet(ReviewWalletTarget.SOURCE, "bca"), vm.state.value.sheet)

        send(vm, QuickAddReviewIntent.SheetPickWallet("gopay"))
        assertEquals("BCA", vm.state.value.walletName)

        send(vm, QuickAddReviewIntent.ConfirmSheet)
        assertEquals("gopay", vm.state.value.walletName)
        assertEquals(null, vm.state.value.draft?.highlights?.get(TransactionField.WALLET))
    }

    @Test
    fun `a failed save keeps the draft and says why`() = runReviewTest { vm, effects ->
        transactions.saveResult = Outcome.Failure(TransactionError.Network)

        send(vm, QuickAddReviewIntent.Save)

        assertEquals(0, vm.state.value.index)
        assertTrue(effects.single() is QuickAddReviewEffect.ShowMessage)
    }
}
