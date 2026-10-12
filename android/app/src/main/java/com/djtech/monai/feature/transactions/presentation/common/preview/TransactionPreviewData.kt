package com.djtech.monai.feature.transactions.presentation.common.preview

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
import java.time.LocalTime
import java.time.YearMonth
import java.time.ZoneId

/** The design's sample month (October 2026, today the 10th) for the transaction screens' previews. */
internal object TransactionPreviewData {
    val zone: ZoneId = ZoneId.of("Asia/Jakarta")
    val today: LocalDate = LocalDate.of(2026, 10, 10)
    val month: YearMonth = YearMonth.from(today)
    private val created = Instant.parse("2026-01-01T00:00:00Z")

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
        createdAt = created,
        updatedAt = created,
    )

    private fun wallet(id: String, name: String, type: WalletType, balance: Long, isDefault: Boolean = false) = Wallet(
        id = id,
        providerId = null,
        name = name,
        type = type,
        logoUrl = null,
        initialBalance = 0,
        currentBalance = balance,
        icon = null,
        color = null,
        isDefault = isDefault,
        isArchived = false,
        createdAt = created,
        updatedAt = created,
    )

    val categories = listOf(
        category("food", "Food", "restaurant", "#F97316"),
        category("transport", "Transport", "directions_car", "#0EA5E9"),
        category("bills", "Bills", "receipt_long", "#8B5CF6"),
        category("shopping", "Shopping", "shopping_bag", "#EC4899"),
        category("fun", "Entertainment", "movie", "#F59E0B"),
        category("kopi", "Kopi", "local_cafe", "#6366F1"),
        category("salary", "Salary", "payments", "#14B8A6", CategoryType.INCOME),
        category("bonus", "Bonus", "redeem", "#84CC16", CategoryType.INCOME),
    )

    val wallets = listOf(
        wallet("bca", "BCA Tabungan", WalletType.BANK, 8_250_000, isDefault = true),
        wallet("mandiri", "Mandiri", WalletType.BANK, 2_565_000),
        wallet("gopay", "GoPay", WalletType.E_WALLET, 1_185_000),
        wallet("cash", "Cash", WalletType.CASH, 450_000),
    )

    val lookups = TransactionLookups.of(categories, wallets)

    private fun transaction(
        id: String,
        note: String,
        amount: Long,
        category: String?,
        wallet: String,
        day: Int,
        time: String,
        type: TransactionType = TransactionType.EXPENSE,
        toWallet: String? = null,
        merchant: String? = null,
        receipt: Boolean = false,
    ) = Transaction(
        id = id,
        type = type,
        amount = amount,
        walletId = wallet,
        toWalletId = toWallet,
        categoryId = category,
        date = LocalDate.of(2026, 10, day),
        note = note,
        merchant = merchant,
        receiptUrl = if (receipt) "https://example.com/receipt.jpg" else null,
        source = if (receipt) TransactionSource.RECEIPT else TransactionSource.MANUAL,
        createdAt = LocalDate.of(2026, 10, day).atTime(LocalTime.parse(time)).atZone(zone).toInstant(),
        updatedAt = created,
    )

    val transactions = listOf(
        transaction("t1", "Makan siang", 35_000, "food", "gopay", 10, "12:40"),
        transaction("t2", "Kopi susu", 25_000, "food", "cash", 10, "09:15"),
        transaction("t3", "Parkir", 5_000, "transport", "cash", 10, "08:50"),
        transaction(
            "t4",
            "Belanja bulanan",
            187_500,
            "shopping",
            "bca",
            9,
            "20:05",
            merchant = "Toko Sumber Rejeki",
            receipt = true,
        ),
        transaction(
            "t5",
            "Top up GoPay",
            500_000,
            null,
            "bca",
            9,
            "19:20",
            type = TransactionType.TRANSFER,
            toWallet = "gopay",
        ),
        transaction("t6", "Ojek ke kantor", 28_000, "transport", "gopay", 9, "08:10"),
        transaction("t7", "Listrik PLN", 410_000, "bills", "bca", 8, "19:42"),
        transaction("t8", "Nonton bioskop", 85_000, "fun", "mandiri", 8, "18:30"),
    )
}
