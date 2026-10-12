package com.djtech.monai.core.database

import android.content.Context
import androidx.paging.PagingSource
import androidx.room3.Room
import androidx.sqlite.driver.bundled.BundledSQLiteDriver
import androidx.test.core.app.ApplicationProvider
import com.djtech.monai.core.database.entity.BudgetEntity
import com.djtech.monai.core.database.entity.CategoryEntity
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.UserEntity
import com.djtech.monai.core.database.entity.WalletEntity
import com.djtech.monai.core.model.BudgetStatus
import com.djtech.monai.core.model.CategoryType
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import com.djtech.monai.core.model.WalletType
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth

/** Same driver as production, so FTS behaves the same. */
fun inMemoryDatabase(): MonAIDatabase {
    val context = ApplicationProvider.getApplicationContext<Context>()
    return Room.inMemoryDatabaseBuilder<MonAIDatabase>(context)
        .setDriver(BundledSQLiteDriver())
        .build()
}

suspend fun <T : Any> PagingSource<Int, T>.loadAll(): List<T> {
    val params = PagingSource.LoadParams.Refresh<Int>(
        key = null,
        loadSize = 100,
        placeholdersEnabled = false,
    )
    return when (val result = load(params)) {
        is PagingSource.LoadResult.Page -> result.data
        is PagingSource.LoadResult.Error -> throw result.throwable
        is PagingSource.LoadResult.Invalid -> error("PagingSource was invalidated")
    }
}

private val CREATED = Instant.parse("2026-10-01T00:00:00Z")

fun wallet(id: String, name: String = id, isDefault: Boolean = false) = WalletEntity(
    id = id,
    providerId = null,
    name = name,
    type = WalletType.CASH,
    logoUrl = null,
    initialBalance = 0,
    currentBalance = 0,
    icon = null,
    color = null,
    isDefault = isDefault,
    isArchived = false,
    createdAt = CREATED,
    updatedAt = CREATED,
)

fun category(id: String, name: String = id, type: CategoryType = CategoryType.EXPENSE) =
    CategoryEntity(
        id = id,
        name = name,
        type = type,
        icon = null,
        color = null,
        isDefault = false,
        isSystem = false,
        isHidden = false,
        createdAt = CREATED,
        updatedAt = CREATED,
    )

fun transaction(
    id: String,
    date: LocalDate = LocalDate.of(2026, 10, 1),
    type: TransactionType = TransactionType.EXPENSE,
    walletId: String = "cash",
    toWalletId: String? = null,
    categoryId: String? = "food",
    note: String? = null,
    merchant: String? = null,
) = TransactionEntity(
    id = id,
    type = type,
    amount = 35_000,
    walletId = walletId,
    toWalletId = toWalletId,
    categoryId = categoryId,
    date = date,
    note = note,
    merchant = merchant,
    receiptUrl = null,
    source = TransactionSource.MANUAL,
    createdAt = CREATED,
    updatedAt = CREATED,
)

fun budget(month: YearMonth) = BudgetEntity(
    month = month,
    limitAmount = 3_000_000,
    spent = 2_400_000,
    remaining = 600_000,
    progressPercent = 80.0,
    status = BudgetStatus.WARNING,
)

fun user(id: String, name: String = "Joshua") = UserEntity(
    id = id,
    name = name,
    email = "$id@example.com",
    avatarUrl = null,
    timezone = "Asia/Jakarta",
    roleSlug = "user",
    roleName = "User",
    permissions = listOf("payment_provider.view"),
    createdAt = CREATED,
)
