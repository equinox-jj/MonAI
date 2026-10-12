package com.djtech.monai.feature.transactions.presentation

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.transactions.presentation.common.model.TransactionLookups
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth
import java.time.ZoneId

/** Sample data for the transaction screen tests, around Saturday 10 October 2026 in Jakarta. */
object TransactionTestData {
    val zone: ZoneId = ZoneId.of("Asia/Jakarta")
    val today: LocalDate = LocalDate.of(2026, 10, 10)
    val october: YearMonth = YearMonth.of(2026, 10)
    private val created = Instant.parse("2026-01-01T00:00:00Z")

    fun category(id: String, name: String, type: CategoryType = CategoryType.EXPENSE) = Category(
        id = id,
        name = name,
        type = type,
        icon = null,
        color = null,
        isDefault = true,
        isSystem = false,
        isHidden = false,
        createdAt = created,
        updatedAt = created,
    )

    fun wallet(id: String, name: String, isDefault: Boolean = false, isArchived: Boolean = false) = Wallet(
        id = id,
        providerId = null,
        name = name,
        type = WalletType.BANK,
        logoUrl = null,
        initialBalance = 0,
        currentBalance = 1_000_000,
        icon = null,
        color = null,
        isDefault = isDefault,
        isArchived = isArchived,
        createdAt = created,
        updatedAt = created,
    )

    fun transaction(
        id: String,
        note: String?,
        date: LocalDate = today,
        amount: Long = 35_000,
        type: TransactionType = TransactionType.EXPENSE,
        walletId: String = "gopay",
        toWalletId: String? = null,
        categoryId: String? = "food",
        merchant: String? = null,
        receiptUrl: String? = null,
        source: TransactionSource = TransactionSource.MANUAL,
    ) = Transaction(
        id = id,
        type = type,
        amount = amount,
        walletId = walletId,
        toWalletId = toWalletId,
        categoryId = categoryId,
        date = date,
        note = note,
        merchant = merchant,
        receiptUrl = receiptUrl,
        source = source,
        // 12:40 in Jakarta.
        createdAt = date.atTime(12, 40).atZone(zone).toInstant(),
        updatedAt = created,
    )

    val categories = listOf(
        category("food", "Food"),
        category("transport", "Transport"),
        category("salary", "Salary", CategoryType.INCOME),
    )
    val wallets = listOf(wallet("bca", "BCA Tabungan", isDefault = true), wallet("gopay", "GoPay"))
    val lookups = TransactionLookups.of(categories, wallets)
}
