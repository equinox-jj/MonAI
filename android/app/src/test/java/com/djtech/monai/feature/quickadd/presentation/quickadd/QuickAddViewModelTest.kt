package com.djtech.monai.feature.quickadd.presentation.quickadd

import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.paymentProvider
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveVisibleCategoriesUseCase
import com.djtech.monai.feature.quickadd.domain.model.QuickAddError
import com.djtech.monai.feature.quickadd.domain.repository.FakeQuickAddRepository
import com.djtech.monai.feature.quickadd.domain.usecase.CompleteDraftsWithAiUseCase
import com.djtech.monai.feature.quickadd.domain.usecase.ObserveQuickAddContextUseCase
import com.djtech.monai.feature.quickadd.domain.usecase.ParseQuickAddUseCase
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.ChipKind
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.EngineNote
import com.djtech.monai.feature.quickadd.presentation.quickadd.model.QuickAddChip
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.FindCategoryForNoteUseCase
import com.djtech.monai.feature.transactions.domain.usecase.testClock
import com.djtech.monai.feature.wallets.domain.repository.FakePaymentProviderRepository
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObservePaymentProvidersUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import java.time.LocalDate

class QuickAddViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val today = LocalDate.of(2026, 10, 10)
    private val gopay = paymentProvider("gopay", name = "GoPay")
    private val ai = FakeQuickAddRepository()

    private fun runQuickAddTest(
        block: suspend TestScope.(QuickAddViewModel, MutableList<QuickAddEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val clock = testClock()
        val categories = ObserveVisibleCategoriesUseCase(
            FakeCategoryRepository(
                listOf(
                    category("food", name = "Food"),
                    category("transport", name = "Transport"),
                    category("other", name = "Other", isSystem = true),
                    category("salary", name = "Salary", type = CategoryType.INCOME),
                ),
            ),
        )
        val viewModel = QuickAddViewModel(
            observeQuickAddContext = ObserveQuickAddContextUseCase(
                ObserveWalletsUseCase(
                    FakeWalletRepository(
                        listOf(
                            wallet("bca", name = "BCA", isDefault = true),
                            wallet("w-gopay", name = "GoPay", providerId = gopay.id, type = WalletType.E_WALLET),
                        ),
                    ),
                ),
                categories,
                ObservePaymentProvidersUseCase(FakePaymentProviderRepository(listOf(gopay))),
                clock,
            ),
            parseQuickAdd = ParseQuickAddUseCase(
                FindCategoryForNoteUseCase(FakeTransactionRepository()),
                mainDispatcherRule.dispatcher,
            ),
            completeDraftsWithAi = CompleteDraftsWithAiUseCase(ai, clock),
        )
        val effects = mutableListOf<QuickAddEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: QuickAddViewModel, vararg intents: QuickAddIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `typing shows what the phone understood`() = runQuickAddTest { vm, _ ->
        send(vm, QuickAddIntent.TextChanged("makan siang 35rb pakai gopay"))

        val state = vm.state.value
        assertEquals(
            listOf(
                QuickAddChip(ChipKind.AMOUNT, false, amount = 35_000),
                QuickAddChip(ChipKind.CATEGORY, false, name = "Food"),
                QuickAddChip(ChipKind.WALLET, false, name = "GoPay"),
                QuickAddChip(ChipKind.DATE, false, date = today),
            ),
            state.chips,
        )
        assertEquals(EngineNote.OnPhone, state.engineNote)
        assertEquals("Makan siang", state.drafts.single().title)
    }

    @Test
    fun `a confident phrase opens the form without asking the AI`() = runQuickAddTest { vm, effects ->
        send(vm, QuickAddIntent.TextChanged("makan siang 35rb pakai gopay"), QuickAddIntent.Submit)

        val draft = (effects.single() as QuickAddEffect.OpenForm).draft
        assertEquals(35_000L, draft.amount)
        assertEquals(emptyList<String>(), ai.texts)
    }

    @Test
    fun `two amounts go to the review, using the default wallet`() = runQuickAddTest { vm, effects ->
        send(vm, QuickAddIntent.PickExample("kopi 25rb sama parkir 5rb kmrn"))

        assertEquals(EngineNote.DefaultWallet("BCA"), vm.state.value.engineNote)

        send(vm, QuickAddIntent.Submit)

        val review = effects.single() as QuickAddEffect.OpenReview
        assertEquals("kopi 25rb sama parkir 5rb kmrn", review.phrase)
        assertEquals(2, review.drafts.size)
    }

    @Test
    fun `an unsure phrase asks the AI once and shows its drafts before continuing`() = runQuickAddTest { vm, effects ->
        ai.result = Outcome.Success(listOf(draft(amount = 150_000, categoryId = "other", note = "Arisan")))
        send(vm, QuickAddIntent.TextChanged("bayar arisan ke tante"))
        assertEquals(EngineNote.WillAskAi, vm.state.value.engineNote)
        assertTrue(vm.state.value.amountMissing)

        send(vm, QuickAddIntent.Submit)

        assertEquals(listOf("bayar arisan ke tante"), ai.texts)
        assertEquals(EngineNote.AskedAi, vm.state.value.engineNote)
        assertEquals(150_000L, vm.state.value.drafts.single().amount)
        assertEquals(emptyList<QuickAddEffect>(), effects)

        send(vm, QuickAddIntent.Submit)

        assertEquals(150_000L, (effects.single() as QuickAddEffect.OpenForm).draft.amount)
        assertEquals(1, ai.texts.size)
    }

    @Test
    fun `when the AI is busy the phone's draft is kept with a notice`() = runQuickAddTest { vm, _ ->
        ai.result = Outcome.Failure(QuickAddError.RateLimited)

        send(vm, QuickAddIntent.TextChanged("bayar laundry 45 ribu kemarin"), QuickAddIntent.Submit)

        val state = vm.state.value
        assertTrue(state.showFallback)
        assertEquals(45_000L, state.drafts.single().amount)
        assertTrue(state.chips.contains(QuickAddChip(ChipKind.CATEGORY, true, name = "Other")))
    }

    @Test
    fun `changing the phrase drops the AI's answer`() = runQuickAddTest { vm, _ ->
        ai.result = Outcome.Failure(QuickAddError.AiUnavailable)
        send(vm, QuickAddIntent.TextChanged("bayar laundry 45 ribu"), QuickAddIntent.Submit)

        send(vm, QuickAddIntent.TextChanged("bayar laundry 50 ribu"))

        assertFalse(vm.state.value.showFallback)
        assertEquals(50_000L, vm.state.value.drafts.single().amount)
    }

    @Test
    fun `blank text does nothing on submit`() = runQuickAddTest { vm, effects ->
        send(vm, QuickAddIntent.Submit)

        assertEquals(emptyList<QuickAddEffect>(), effects)
        assertEquals(emptyList<String>(), ai.texts)
    }
}
