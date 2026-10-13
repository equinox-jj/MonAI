package com.djtech.monai.feature.wallets.presentation.walletdetail.preview

import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.WalletType
import com.djtech.monai.feature.wallets.presentation.walletdetail.WalletDetailState
import com.djtech.monai.feature.wallets.presentation.walletdetail.mapper.toOutflowDays
import com.djtech.monai.feature.wallets.presentation.walletdetail.model.WalletRowLookups
import com.djtech.monai.feature.wallets.presentation.wallets.preview.WalletsPreviewData
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth

internal object WalletDetailPreviewData {

    private val month = YearMonth.of(2026, 10)
    private val today = LocalDate.of(2026, 10, 10)
    private val outflows = mapOf(LocalDate.of(2026, 10, 8) to 410_000L, LocalDate.of(2026, 10, 9) to 687_500L)

    val bca = WalletsPreviewData.wallet("bca", "BCA Tabungan", WalletType.BANK, 8_250_000, isDefault = true)

    val state = WalletDetailState(
        month = month,
        today = today,
        wallet = bca,
        isLoading = false,
        outflows = outflows.toOutflowDays(month, today),
        outflowTotal = outflows.values.sum(),
        lookups = WalletRowLookups(
            categories = listOf(
                category("shopping", "Shopping", "shopping_bag", "#EC4899"),
                category("bills", "Bills", "receipt_long", "#8B5CF6"),
                category("salary", "Salary", "payments", "#14B8A6", CategoryType.INCOME),
            ).associateBy { it.id },
            walletNames = mapOf("bca" to "BCA Tabungan", "gopay" to "GoPay"),
        ),
    )

    val transactions = listOf(
        transaction("t1", "Belanja bulanan", TransactionType.EXPENSE, 187_500, 9, categoryId = "shopping"),
        transaction("t2", "Top up GoPay", TransactionType.TRANSFER, 500_000, 9, toWalletId = "gopay"),
        transaction("t3", "Listrik PLN", TransactionType.EXPENSE, 410_000, 8, categoryId = "bills"),
        transaction("t4", "Gaji Oktober", TransactionType.INCOME, 8_500_000, 1, categoryId = "salary"),
    )

    private fun category(
        id: String,
        name: String,
        icon: String,
        color: String,
        type: CategoryType = CategoryType.EXPENSE,
    ) = Category(
        id = id,
        name = name,
        type = type,
        icon = icon,
        color = color,
        isDefault = true,
        isSystem = false,
        isHidden = false,
        createdAt = Instant.EPOCH,
        updatedAt = Instant.EPOCH,
    )

    private fun transaction(
        id: String,
        note: String,
        type: TransactionType,
        amount: Long,
        day: Int,
        categoryId: String? = null,
        toWalletId: String? = null,
    ) = Transaction(
        id = id,
        type = type,
        amount = amount,
        walletId = "bca",
        toWalletId = toWalletId,
        categoryId = categoryId,
        date = month.atDay(day),
        note = note,
        merchant = null,
        receiptUrl = null,
        source = TransactionSource.MANUAL,
        createdAt = Instant.EPOCH,
        updatedAt = Instant.EPOCH,
    )
}
