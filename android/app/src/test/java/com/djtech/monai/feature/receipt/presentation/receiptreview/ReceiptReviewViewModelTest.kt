package com.djtech.monai.feature.receipt.presentation.receiptreview

import com.djtech.monai.core.common.dispatcher.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.media.FakeImageProcessor
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.ReceiptDraft
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.draftConfidence
import com.djtech.monai.core.model.receiptDraft
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.quickadd.domain.repository.FakeQuickAddRepository
import com.djtech.monai.feature.quickadd.domain.usecase.SuggestCategoryUseCase
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.CreateTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.CreateTransactionWithReceiptUseCase
import com.djtech.monai.feature.transactions.domain.usecase.DependentRepositories
import com.djtech.monai.feature.transactions.domain.usecase.FindCategoryForNoteUseCase
import com.djtech.monai.feature.transactions.domain.usecase.UploadReceiptUseCase
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
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import java.time.LocalDate

class ReceiptReviewViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val transactions = FakeTransactionRepository()
    private val scanned = ReceiptDraft(
        draft = draft(
            amount = 187_500,
            walletId = null,
            categoryId = "shopping",
            date = LocalDate.of(2026, 10, 9),
            note = null,
            merchant = "Toko Sumber Rejeki",
            confidence = draftConfidence(wallet = 0.0, date = 0.4),
        ),
        items = receiptDraft().items,
    )

    private fun runReviewTest(
        receipt: ReceiptDraft = scanned,
        aiFailed: Boolean = false,
        block: suspend TestScope.(ReceiptReviewViewModel, MutableList<ReceiptReviewEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val clock = testClock()
        val viewModel = ReceiptReviewViewModel(
            photoUri = "content://camera/1",
            receipt = receipt,
            aiFailed = aiFailed,
            createTransactionWithReceipt = CreateTransactionWithReceiptUseCase(
                UploadReceiptUseCase(transactions, FakeImageProcessor()),
                CreateTransactionUseCase(transactions, DependentRepositories().refreshDependents, clock),
                clock,
            ),
            suggestCategory = SuggestCategoryUseCase(
                FindCategoryForNoteUseCase(transactions),
                FakeQuickAddRepository(),
                clock,
            ),
            observeWallets = ObserveWalletsUseCase(
                FakeWalletRepository(listOf(wallet("bca", name = "BCA", isDefault = true))),
            ),
            observeCategories = ObserveCategoriesUseCase(
                FakeCategoryRepository(
                    listOf(
                        category("shopping", name = "Shopping"),
                        category("food", name = "Food"),
                        category("salary", name = "Salary", type = CategoryType.INCOME),
                    ),
                ),
            ),
            clock = clock,
        )
        val effects = mutableListOf<ReceiptReviewEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: ReceiptReviewViewModel, vararg intents: ReceiptReviewIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `fills the review from the receipt and marks what to check`() = runReviewTest { vm, _ ->
        val state = vm.state.value
        assertEquals(187_500L, state.amount)
        assertEquals("Toko Sumber Rejeki", state.merchant)
        assertTrue(state.merchantFromAi)
        assertEquals("Shopping", state.category?.name)
        assertEquals("BCA", state.walletName)
        assertEquals(2, state.items.size)
        assertEquals(FieldHighlight.Ai, state.highlights[TransactionField.AMOUNT])
        assertEquals(FieldHighlight.Low, state.highlights[TransactionField.DATE])
        // The receipt names no wallet, so the default one is used unmarked.
        assertNull(state.highlights[TransactionField.WALLET])
    }

    @Test
    fun `saving uploads the photo and creates a receipt transaction`() = runReviewTest { vm, effects ->
        send(vm, ReceiptReviewIntent.Save)

        val input = transactions.created.single()
        assertEquals(TransactionSource.RECEIPT, input.source)
        assertEquals("Toko Sumber Rejeki", input.merchant)
        assertEquals("receipts-pending/key.webp", input.receiptKey)
        assertEquals("bca", input.walletId)
        assertEquals(listOf<ReceiptReviewEffect>(ReceiptReviewEffect.Saved("new")), effects)
        assertNull(vm.state.value.uploadProgress)
    }

    @Test
    fun `a failed upload keeps the review and says why`() = runReviewTest { vm, effects ->
        transactions.uploadResult = Outcome.Failure(TransactionError.PhotoTooLarge)

        send(vm, ReceiptReviewIntent.Save)

        assertEquals(emptyList<Any>(), transactions.created)
        assertTrue(effects.single() is ReceiptReviewEffect.ShowMessage)
        assertTrue(!vm.state.value.isSaving)
    }

    @Test
    fun `an empty draft after an AI failure needs an amount before anything uploads`() = runReviewTest(
        receipt = ReceiptDraft(draft(amount = null, categoryId = null, merchant = null), emptyList()),
        aiFailed = true,
    ) { vm, _ ->
        assertEquals(emptyMap<TransactionField, FieldHighlight>(), vm.state.value.highlights)

        send(vm, ReceiptReviewIntent.Save)

        assertTrue(vm.state.value.errors.containsKey(TransactionField.AMOUNT))
        assertEquals(emptyList<Any>(), transactions.uploadedImages)
    }

    @Test
    fun `switching to income drops the expense category`() = runReviewTest { vm, _ ->
        send(vm, ReceiptReviewIntent.SelectType(TransactionType.INCOME))

        assertNull(vm.state.value.category)
        assertEquals(listOf("salary"), vm.state.value.categories.map { it.id })
    }

    @Test
    fun `typing a merchant suggests a category until one is picked`() = runReviewTest(
        receipt = ReceiptDraft(draft(categoryId = null, merchant = null), emptyList()),
        aiFailed = true,
    ) { vm, _ ->
        send(vm, ReceiptReviewIntent.MerchantChanged("Warung Bakso"))

        assertEquals("Food", vm.state.value.category?.name)
        assertEquals(FieldHighlight.Ai, vm.state.value.highlights[TransactionField.CATEGORY])
    }
}
