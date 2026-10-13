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
    type: WalletType = WalletType.BANK,
    providerId: String? = null,
    initialBalance: Long = 0,
    color: String? = null,
) = Wallet(
    id = id,
    providerId = providerId,
    name = name,
    type = type,
    logoUrl = null,
    initialBalance = initialBalance,
    currentBalance = balance,
    icon = null,
    color = color,
    isDefault = isDefault,
    isArchived = isArchived,
    createdAt = CREATED,
    updatedAt = CREATED,
)

/** [id] is empty for an entry of the bundled seed catalog, which only knows slugs. */
fun paymentProvider(
    slug: String,
    id: String = "p-$slug",
    name: String = slug,
    type: WalletType = WalletType.BANK,
    sortOrder: Int = 0,
) = PaymentProvider(
    id = id,
    slug = slug,
    name = name,
    type = type,
    logoUrl = null,
    aliases = listOf(slug),
    sortOrder = sortOrder,
)

fun category(
    id: String,
    name: String = id,
    icon: String? = null,
    color: String? = null,
    type: CategoryType = CategoryType.EXPENSE,
    isHidden: Boolean = false,
) = Category(
    id = id,
    name = name,
    type = type,
    icon = icon,
    color = color,
    isDefault = true,
    isSystem = false,
    isHidden = isHidden,
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
    receiptUrl: String? = null,
    source: TransactionSource = TransactionSource.MANUAL,
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
    receiptUrl = receiptUrl,
    source = source,
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
