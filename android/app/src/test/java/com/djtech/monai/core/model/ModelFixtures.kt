package com.djtech.monai.core.model

import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth

/** Sample domain models for tests, around 10 October 2026 in Jakarta. */
val OCTOBER: YearMonth = YearMonth.of(2026, 10)

/** 10 October 2026, 12:40 in Jakarta. */
val NOW: Instant = Instant.parse("2026-10-10T05:40:00Z")

private val CREATED: Instant = Instant.parse("2026-01-01T00:00:00Z")

fun user(name: String = "Joshua Putra", avatarUrl: String? = null) = User(
    id = "u1",
    name = name,
    email = "joshua@example.com",
    avatarUrl = avatarUrl,
    timezone = "Asia/Jakarta",
    role = Role(slug = "user", name = "User"),
    permissions = emptySet(),
    createdAt = CREATED,
)

fun wallet(
    id: String,
    name: String = id,
    balance: Long = 0,
    isDefault: Boolean = false,
    isArchived: Boolean = false,
) = Wallet(
    id = id,
    providerId = null,
    name = name,
    type = WalletType.BANK,
    logoUrl = null,
    initialBalance = 0,
    currentBalance = balance,
    icon = null,
    color = null,
    isDefault = isDefault,
    isArchived = isArchived,
    createdAt = CREATED,
    updatedAt = CREATED,
)

fun category(id: String, name: String = id, icon: String? = null, color: String? = null) = Category(
    id = id,
    name = name,
    type = CategoryType.EXPENSE,
    icon = icon,
    color = color,
    isDefault = true,
    isSystem = false,
    isHidden = false,
    createdAt = CREATED,
    updatedAt = CREATED,
)

fun transaction(
    id: String,
    date: LocalDate = LocalDate.of(2026, 10, 10),
    type: TransactionType = TransactionType.EXPENSE,
    amount: Long = 35_000,
    walletId: String = "bca",
    toWalletId: String? = null,
    categoryId: String? = "food",
    note: String? = null,
    merchant: String? = null,
    createdAt: Instant = NOW,
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
    receiptUrl = null,
    source = TransactionSource.MANUAL,
    createdAt = createdAt,
    updatedAt = createdAt,
)

fun budget(month: YearMonth = OCTOBER, limit: Long = 3_000_000, spent: Long = 2_415_000) = Budget(
    month = month,
    limitAmount = limit,
    spent = spent,
    remaining = limit - spent,
    progressPercent = spent * 100.0 / limit,
    status = BudgetStatus.WARNING,
)

fun breakdown(id: String, amount: Long, share: Double, color: String? = null) = CategoryBreakdown(
    categoryId = id,
    name = id,
    icon = null,
    color = color,
    amount = amount,
    sharePercent = share,
    previousAmount = 0,
    changePercent = null,
)

fun report(
    month: YearMonth = OCTOBER,
    income: Long = 8_500_000,
    expense: Long = 2_415_000,
    expenseChangePercent: Double? = -10.0,
    categories: List<CategoryBreakdown> = emptyList(),
) = MonthlyReport(
    month = month,
    incomeTotal = income,
    expenseTotal = expense,
    net = income - expense,
    previous = PreviousMonthTotals(month = month.minusMonths(1), incomeTotal = 0, expenseTotal = 2_700_000),
    expenseChangePercent = expenseChangePercent,
    categories = categories,
)
