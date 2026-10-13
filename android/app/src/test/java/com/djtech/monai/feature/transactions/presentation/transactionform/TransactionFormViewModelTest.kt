package com.djtech.monai.feature.transactions.presentation.transactionform

import com.djtech.monai.R
import com.djtech.monai.core.common.coroutines.MainDispatcherRule
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.time.FixedAppClock
import com.djtech.monai.core.common.ui.UiText
import com.djtech.monai.core.designsystem.component.FieldHighlight
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.NOW
import com.djtech.monai.core.model.OCTOBER
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.category
import com.djtech.monai.core.model.draft
import com.djtech.monai.core.model.draftConfidence
import com.djtech.monai.core.model.transaction
import com.djtech.monai.core.model.wallet
import com.djtech.monai.feature.budgets.domain.repository.FakeBudgetRepository
import com.djtech.monai.feature.categories.domain.event.CategoryCreationEvents
import com.djtech.monai.feature.categories.domain.model.CategoryInput
import com.djtech.monai.feature.categories.domain.repository.FakeCategoryRepository
import com.djtech.monai.feature.categories.domain.usecase.CreateCategoryUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveCreatedCategoriesUseCase
import com.djtech.monai.feature.categories.domain.usecase.ObserveVisibleCategoriesUseCase
import com.djtech.monai.feature.quickadd.domain.repository.FakeQuickAddRepository
import com.djtech.monai.feature.quickadd.domain.usecase.SuggestCategoryUseCase
import com.djtech.monai.feature.reports.domain.repository.FakeReportRepository
import com.djtech.monai.feature.transactions.domain.event.TransactionDeletionEvents
import com.djtech.monai.feature.transactions.domain.model.TransactionError
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import com.djtech.monai.feature.transactions.domain.repository.FakeTransactionRepository
import com.djtech.monai.feature.transactions.domain.usecase.CreateTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.DeleteTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.FindCategoryForNoteUseCase
import com.djtech.monai.feature.transactions.domain.usecase.ObserveTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionDependentsUseCase
import com.djtech.monai.feature.transactions.domain.usecase.RefreshTransactionUseCase
import com.djtech.monai.feature.transactions.domain.usecase.UpdateTransactionUseCase
import com.djtech.monai.feature.transactions.presentation.transactionform.model.FormSheet
import com.djtech.monai.feature.transactions.presentation.transactionform.model.TransactionFormPreset
import com.djtech.monai.feature.transactions.presentation.transactionform.model.WalletTarget
import com.djtech.monai.feature.wallets.domain.repository.FakeWalletRepository
import com.djtech.monai.feature.wallets.domain.usecase.ObserveAllWalletsUseCase
import com.djtech.monai.feature.wallets.domain.usecase.ObserveWalletsUseCase
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test
import java.time.LocalDate
import java.time.YearMonth

class TransactionFormViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val clock = FixedAppClock(NOW)
    private val today = LocalDate.of(2026, 10, 10)
    private val wallets = FakeWalletRepository(
        listOf(wallet("bca", isDefault = true), wallet("gopay"), wallet("ovo", isArchived = true)),
    )
    private val categories = FakeCategoryRepository(
        listOf(category("food"), category("salary", type = CategoryType.INCOME)),
    )
    private val categoryCreations = CategoryCreationEvents()
    private val lunch = transaction("lunch", note = "Makan siang", merchant = "Warteg", walletId = "gopay")
    private val transactions = FakeTransactionRepository(listOf(lunch))
    private val quickAdd = FakeQuickAddRepository()

    private fun viewModel(
        id: String? = null,
        preset: TransactionFormPreset = TransactionFormPreset(),
    ): TransactionFormViewModel {
        val dependents = RefreshTransactionDependentsUseCase(wallets, FakeReportRepository(), FakeBudgetRepository())
        return TransactionFormViewModel(
            transactionId = id,
            preset = preset,
            observeTransaction = ObserveTransactionUseCase(transactions),
            refreshTransaction = RefreshTransactionUseCase(transactions),
            createTransaction = CreateTransactionUseCase(transactions, dependents, clock),
            updateTransaction = UpdateTransactionUseCase(transactions, dependents, clock),
            deleteTransaction = DeleteTransactionUseCase(transactions, TransactionDeletionEvents(), dependents),
            observeWallets = ObserveWalletsUseCase(wallets),
            observeAllWallets = ObserveAllWalletsUseCase(wallets),
            observeCategories = ObserveCategoriesUseCase(categories),
            observeVisibleCategories = ObserveVisibleCategoriesUseCase(categories),
            observeCreatedCategories = ObserveCreatedCategoriesUseCase(categoryCreations),
            suggestCategory = SuggestCategoryUseCase(FindCategoryForNoteUseCase(transactions), quickAdd, clock),
            clock = clock,
        )
    }

    private fun runFormTest(
        id: String? = null,
        preset: TransactionFormPreset = TransactionFormPreset(),
        block: suspend TestScope.(TransactionFormViewModel, MutableList<TransactionFormEffect>) -> Unit,
    ) = runTest(mainDispatcherRule.dispatcher) {
        val viewModel = viewModel(id, preset)
        val effects = mutableListOf<TransactionFormEffect>()
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.state.collect {} }
        backgroundScope.launch(UnconfinedTestDispatcher(testScheduler)) { viewModel.effects.toList(effects) }
        advanceUntilIdle()
        block(viewModel, effects)
    }

    private fun TestScope.send(viewModel: TransactionFormViewModel, vararg intents: TransactionFormIntent) {
        intents.forEach(viewModel::onIntent)
        advanceUntilIdle()
    }

    @Test
    fun `a new expense starts today, from the default wallet, with the type's categories`() = runFormTest { vm, _ ->
        val state = vm.state.value

        assertEquals(TransactionType.EXPENSE, state.type)
        assertEquals(today, state.date)
        assertEquals("bca", state.walletId)
        assertEquals(listOf("food"), state.categories.map { it.id })
        assertEquals(listOf("bca", "gopay"), state.wallets.map { it.id })
        assertFalse(state.isEdit)
    }

    @Test
    fun `the keypad types the amount`() = runFormTest { vm, _ ->
        send(
            vm,
            TransactionFormIntent.Digit(3),
            TransactionFormIntent.Digit(5),
            TransactionFormIntent.TripleZero,
            TransactionFormIntent.Digit(1),
            TransactionFormIntent.Backspace,
        )

        assertEquals(35_000L, vm.state.value.amount)
    }

    @Test
    fun `switching type drops a category of the other type and lists that type's categories`() = runFormTest { vm, _ ->
        send(vm, TransactionFormIntent.PickCategory("food"), TransactionFormIntent.SelectType(TransactionType.INCOME))

        assertNull(vm.state.value.categoryId)
        assertEquals(listOf("salary"), vm.state.value.categories.map { it.id })
    }

    @Test
    fun `a transfer starts out to the first other wallet`() = runFormTest { vm, _ ->
        send(vm, TransactionFormIntent.SelectType(TransactionType.TRANSFER))

        assertEquals("gopay", vm.state.value.toWalletId)
        assertEquals(emptyList<Any>(), vm.state.value.categories)
    }

    @Test
    fun `a transfer preset starts from the given wallet to the first other one`() =
        runFormTest(preset = TransactionFormPreset(TransactionType.TRANSFER, walletId = "gopay")) { vm, _ ->
            val state = vm.state.value

            assertEquals(TransactionType.TRANSFER, state.type)
            assertEquals("gopay", state.walletId)
            assertEquals("bca", state.toWalletId)
        }

    @Test
    fun `an untouched preset form closes at once`() =
        runFormTest(preset = TransactionFormPreset(TransactionType.TRANSFER, walletId = "gopay")) { vm, effects ->
            send(vm, TransactionFormIntent.Close)

            assertEquals(listOf<TransactionFormEffect>(TransactionFormEffect.Close), effects)
        }

    @Test
    fun `a preset wallet replaces the default wallet`() =
        runFormTest(preset = TransactionFormPreset(walletId = "gopay")) { vm, _ ->
            assertEquals(TransactionType.EXPENSE, vm.state.value.type)
            assertEquals("gopay", vm.state.value.walletId)
            assertNull(vm.state.value.toWalletId)
        }

    @Test
    fun `editing ignores the preset`() =
        runFormTest("lunch", TransactionFormPreset(TransactionType.TRANSFER, walletId = "bca")) { vm, _ ->
            assertEquals(TransactionType.EXPENSE, vm.state.value.type)
            assertEquals("gopay", vm.state.value.walletId)
        }

    @Test
    fun `saving a valid expense creates it and closes`() = runFormTest { vm, effects ->
        send(
            vm,
            TransactionFormIntent.Digit(5),
            TransactionFormIntent.TripleZero,
            TransactionFormIntent.PickCategory("food"),
            TransactionFormIntent.NoteChanged("Parkir"),
            TransactionFormIntent.Save,
        )

        assertEquals(
            listOf(
                TransactionInput(
                    type = TransactionType.EXPENSE,
                    amount = 5_000,
                    walletId = "bca",
                    toWalletId = null,
                    categoryId = "food",
                    date = today,
                    note = "Parkir",
                ),
            ),
            transactions.created,
        )
        assertEquals(listOf<TransactionFormEffect>(TransactionFormEffect.Saved("new")), effects)
    }

    @Test
    fun `saving an incomplete form marks each missing field`() = runFormTest { vm, effects ->
        send(vm, TransactionFormIntent.Save)

        assertEquals(
            mapOf(
                TransactionField.AMOUNT to UiText.Resource(R.string.transaction_form_error_amount_required),
                TransactionField.CATEGORY to UiText.Resource(R.string.transaction_form_error_category_required),
            ),
            vm.state.value.errors,
        )
        assertEquals(emptyList<Any>(), transactions.created)
        assertEquals(emptyList<TransactionFormEffect>(), effects)

        send(vm, TransactionFormIntent.Digit(1))
        assertEquals(setOf(TransactionField.CATEGORY), vm.state.value.errors.keys)
    }

    @Test
    fun `field errors from the server land on their fields`() = runFormTest { vm, _ ->
        transactions.saveResult = Outcome.Failure(
            TransactionError.InvalidFields(
                listOf(TransactionFieldError(TransactionField.WALLET, TransactionFieldIssue.ARCHIVED)),
            ),
        )

        send(vm, TransactionFormIntent.Digit(1), TransactionFormIntent.PickCategory("food"), TransactionFormIntent.Save)

        assertEquals(
            mapOf(TransactionField.WALLET to UiText.Resource(R.string.transaction_form_error_archived)),
            vm.state.value.errors,
        )
    }

    @Test
    fun `a failed save says why and keeps the form`() = runFormTest { vm, effects ->
        transactions.saveResult = Outcome.Failure(TransactionError.Network)

        send(vm, TransactionFormIntent.Digit(1), TransactionFormIntent.PickCategory("food"), TransactionFormIntent.Save)

        assertEquals(
            listOf(TransactionFormEffect.ShowMessage(UiText.Resource(R.string.transaction_error_network))),
            effects,
        )
        assertFalse(vm.state.value.isSaving)
        assertEquals(1L, vm.state.value.amount)
    }

    @Test
    fun `wallet pickers apply on confirm, to the side they were opened for`() = runFormTest { vm, _ ->
        send(
            vm,
            TransactionFormIntent.SelectType(TransactionType.TRANSFER),
            TransactionFormIntent.OpenWalletPicker(WalletTarget.DESTINATION),
            TransactionFormIntent.SheetPickWallet("bca"),
        )
        assertEquals(FormSheet.Wallet(WalletTarget.DESTINATION, "bca"), vm.state.value.sheet)
        assertEquals("gopay", vm.state.value.toWalletId)

        send(vm, TransactionFormIntent.ConfirmSheet)

        assertEquals("bca", vm.state.value.toWalletId)
        assertNull(vm.state.value.sheet)
    }

    @Test
    fun `the date picker skips future days and months`() = runFormTest { vm, _ ->
        send(
            vm,
            TransactionFormIntent.OpenDatePicker,
            TransactionFormIntent.SheetPickDate(today.plusDays(1)),
            TransactionFormIntent.SheetShowMonth(YearMonth.of(2026, 11)),
        )
        assertEquals(FormSheet.Date(today, OCTOBER), vm.state.value.sheet)

        send(
            vm,
            TransactionFormIntent.SheetShowMonth(YearMonth.of(2026, 9)),
            TransactionFormIntent.SheetPickDate(LocalDate.of(2026, 9, 28)),
            TransactionFormIntent.ConfirmSheet,
        )

        assertEquals(LocalDate.of(2026, 9, 28), vm.state.value.date)
    }

    private fun newCategory(name: String, type: CategoryType) = CategoryInput(
        name = name,
        type = type,
        icon = null,
        color = null,
    )

    @Test
    fun `new in the category picker opens the category form for the form's type`() = runFormTest { vm, effects ->
        send(
            vm,
            TransactionFormIntent.SelectType(TransactionType.INCOME),
            TransactionFormIntent.OpenCategoryPicker,
            TransactionFormIntent.NewCategory,
        )

        assertEquals(listOf<TransactionFormEffect>(TransactionFormEffect.OpenNewCategory(CategoryType.INCOME)), effects)
    }

    @Test
    fun `a category created from the picker is selected in it`() = runFormTest { vm, _ ->
        send(vm, TransactionFormIntent.OpenCategoryPicker, TransactionFormIntent.NewCategory)

        CreateCategoryUseCase(categories, categoryCreations)(newCategory("Kopi", CategoryType.EXPENSE))
        advanceUntilIdle()

        val created = categories.categories.value.single { it.name == "Kopi" }
        assertEquals(FormSheet.Category(created.id), vm.state.value.sheet)
        assertTrue(created in vm.state.value.categories)
    }

    @Test
    fun `a category created of another type is not selected`() = runFormTest { vm, _ ->
        send(vm, TransactionFormIntent.OpenCategoryPicker)

        CreateCategoryUseCase(categories, categoryCreations)(newCategory("Bonus", CategoryType.INCOME))
        advanceUntilIdle()

        assertEquals(FormSheet.Category(null), vm.state.value.sheet)
    }

    @Test
    fun `dismissing a picker keeps the old choice`() = runFormTest { vm, _ ->
        send(
            vm,
            TransactionFormIntent.OpenCategoryPicker,
            TransactionFormIntent.SheetPickCategory("food"),
            TransactionFormIntent.DismissSheet,
        )

        assertNull(vm.state.value.categoryId)
    }

    @Test
    fun `closing an untouched form closes at once`() = runFormTest { vm, effects ->
        send(vm, TransactionFormIntent.Close)

        assertEquals(listOf<TransactionFormEffect>(TransactionFormEffect.Close), effects)
    }

    @Test
    fun `closing after a change asks first`() = runFormTest { vm, effects ->
        send(vm, TransactionFormIntent.Digit(1), TransactionFormIntent.Close)
        assertTrue(vm.state.value.showDiscardDialog)
        assertEquals(emptyList<TransactionFormEffect>(), effects)

        send(vm, TransactionFormIntent.KeepEditing)
        assertFalse(vm.state.value.showDiscardDialog)

        send(vm, TransactionFormIntent.Close, TransactionFormIntent.ConfirmDiscard)
        assertEquals(listOf<TransactionFormEffect>(TransactionFormEffect.Close), effects)
    }

    @Test
    fun `editing fills the form and saves every field, the merchant included`() = runFormTest("lunch") { vm, effects ->
        val state = vm.state.value
        assertTrue(state.isEdit)
        assertEquals(35_000L, state.amount)
        assertEquals(35_000L, state.originalAmount)
        assertEquals("gopay", state.walletId)
        assertEquals("Makan siang", state.note)

        send(vm, TransactionFormIntent.Backspace, TransactionFormIntent.Save)

        assertEquals("lunch", transactions.updated.single().first)
        assertEquals(3_500L, transactions.updated.single().second.amount)
        assertEquals("Warteg", transactions.updated.single().second.merchant)
        assertEquals(listOf<TransactionFormEffect>(TransactionFormEffect.Saved("lunch")), effects)
    }

    @Test
    fun `an edit that can't be loaded shows the error`() {
        transactions.refreshTransactionResult = Outcome.Failure(TransactionError.Network)
        runFormTest("gone") { vm, _ ->
            assertEquals(UiText.Resource(R.string.transactions_load_failed_network), vm.state.value.loadError)
            assertFalse(vm.state.value.isLoading)
        }
    }

    @Test
    fun `deleting while editing reports it`() = runFormTest("lunch") { vm, effects ->
        send(vm, TransactionFormIntent.Delete)

        assertEquals(listOf("lunch"), transactions.deletedIds)
        assertEquals(listOf<TransactionFormEffect>(TransactionFormEffect.Deleted("lunch")), effects)
    }

    @Test
    fun `a quick-add draft fills the form and marks its unsure fields`() = runFormTest(
        preset = TransactionFormPreset(
            draft = draft(
                amount = null,
                walletId = "bca",
                categoryId = "food",
                date = today.minusDays(1),
                note = "Kopi",
                confidence = draftConfidence(amount = 0.0, wallet = 0.5),
            ),
        ),
    ) { vm, _ ->
        val state = vm.state.value
        assertEquals(0L, state.amount)
        assertEquals("food", state.categoryId)
        assertEquals(today.minusDays(1), state.date)
        assertEquals("Kopi", state.note)
        assertEquals(
            mapOf(
                TransactionField.AMOUNT to FieldHighlight.Low,
                TransactionField.WALLET to FieldHighlight.Low,
                TransactionField.CATEGORY to FieldHighlight.Ai,
                TransactionField.DATE to FieldHighlight.Ai,
            ),
            state.highlights,
        )

        send(vm, TransactionFormIntent.Digit(9))

        assertNull(vm.state.value.highlights[TransactionField.AMOUNT])
    }

    @Test
    fun `a quick-add draft is saved as a quick add`() =
        runFormTest(preset = TransactionFormPreset(draft = draft())) { vm, _ ->
            send(vm, TransactionFormIntent.Save)

            assertEquals(TransactionSource.QUICK_ADD, transactions.created.single().source)
        }

    @Test
    fun `typing a note suggests the category used for it before`() = runFormTest { vm, _ ->
        categories.categories.value += category("drinks")
        transactions.noteCategories = mapOf("kopi kenangan" to "drinks")

        send(vm, TransactionFormIntent.NoteChanged("Kopi Kenangan"))

        assertEquals("drinks", vm.state.value.categoryId)
        assertEquals(FieldHighlight.Ai, vm.state.value.highlights[TransactionField.CATEGORY])
    }

    @Test
    fun `a category the user picked is never replaced by a suggestion`() = runFormTest { vm, _ ->
        categories.categories.value += category("drinks")
        transactions.noteCategories = mapOf("kopi kenangan" to "drinks")

        send(vm, TransactionFormIntent.PickCategory("food"), TransactionFormIntent.NoteChanged("Kopi Kenangan"))

        assertEquals("food", vm.state.value.categoryId)
    }

    @Test
    fun `scan opens the receipt scanner`() = runFormTest { vm, effects ->
        send(vm, TransactionFormIntent.Scan)

        assertEquals(listOf<TransactionFormEffect>(TransactionFormEffect.OpenScan), effects)
    }
}
