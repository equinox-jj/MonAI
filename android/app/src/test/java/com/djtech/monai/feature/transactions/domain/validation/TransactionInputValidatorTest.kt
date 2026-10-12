package com.djtech.monai.feature.transactions.domain.validation

import com.djtech.monai.core.common.format.MAX_AMOUNT
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.feature.transactions.domain.model.TransactionField
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldError
import com.djtech.monai.feature.transactions.domain.model.TransactionFieldIssue
import com.djtech.monai.feature.transactions.domain.model.TransactionInput
import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class TransactionInputValidatorTest {

    @Test
    fun `a complete expense is valid`() {
        assertEquals(emptyList<TransactionFieldError>(), EXPENSE.validate(TODAY))
    }

    @Test
    fun `an expense needs an amount, a wallet and a category`() {
        val input = EXPENSE.copy(amount = 0, walletId = null, categoryId = null)

        assertEquals(
            listOf(
                TransactionFieldError(TransactionField.AMOUNT, TransactionFieldIssue.REQUIRED),
                TransactionFieldError(TransactionField.WALLET, TransactionFieldIssue.REQUIRED),
                TransactionFieldError(TransactionField.CATEGORY, TransactionFieldIssue.REQUIRED),
            ),
            input.validate(TODAY),
        )
    }

    @Test
    fun `amounts past the API's limit are too large`() {
        assertEquals(
            listOf(TransactionFieldError(TransactionField.AMOUNT, TransactionFieldIssue.TOO_LARGE)),
            EXPENSE.copy(amount = MAX_AMOUNT + 1).validate(TODAY),
        )
    }

    @Test
    fun `a transfer needs a destination other than its source and no category`() {
        val transfer = EXPENSE.copy(type = TransactionType.TRANSFER, categoryId = null)

        assertEquals(
            listOf(TransactionFieldError(TransactionField.TO_WALLET, TransactionFieldIssue.REQUIRED)),
            transfer.validate(TODAY),
        )
        assertEquals(
            listOf(TransactionFieldError(TransactionField.TO_WALLET, TransactionFieldIssue.SAME_WALLET)),
            transfer.copy(toWalletId = "bca").validate(TODAY),
        )
        assertEquals(emptyList<TransactionFieldError>(), transfer.copy(toWalletId = "gopay").validate(TODAY))
    }

    @Test
    fun `dates after today are rejected, today is fine`() {
        assertEquals(emptyList<TransactionFieldError>(), EXPENSE.copy(date = TODAY).validate(TODAY))
        assertEquals(
            listOf(TransactionFieldError(TransactionField.DATE, TransactionFieldIssue.FUTURE_DATE)),
            EXPENSE.copy(date = TODAY.plusDays(1)).validate(TODAY),
        )
    }

    @Test
    fun `notes over 200 characters are too long`() {
        assertEquals(emptyList<TransactionFieldError>(), EXPENSE.copy(note = "a".repeat(200)).validate(TODAY))
        assertEquals(
            listOf(TransactionFieldError(TransactionField.NOTE, TransactionFieldIssue.TOO_LARGE)),
            EXPENSE.copy(note = "a".repeat(201)).validate(TODAY),
        )
    }

    @Test
    fun `normalized trims the note and drops fields the type doesn't use`() {
        val messy = EXPENSE.copy(toWalletId = "gopay", note = "  kopi  ", merchant = " ")

        assertEquals(EXPENSE.copy(note = "kopi", merchant = null), messy.normalized())
        assertEquals(
            EXPENSE.copy(type = TransactionType.TRANSFER, toWalletId = "gopay", categoryId = null, note = null),
            messy.copy(type = TransactionType.TRANSFER, note = "   ").normalized(),
        )
    }

    private companion object {
        val TODAY: LocalDate = LocalDate.of(2026, 10, 10)
        val EXPENSE = TransactionInput(
            type = TransactionType.EXPENSE,
            amount = 35_000,
            walletId = "bca",
            toWalletId = null,
            categoryId = "food",
            date = LocalDate.of(2026, 10, 9),
            note = "Makan siang",
        )
    }
}
