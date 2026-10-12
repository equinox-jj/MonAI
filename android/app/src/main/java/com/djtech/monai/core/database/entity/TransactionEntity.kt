package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import androidx.room3.Entity
import androidx.room3.Fts4
import androidx.room3.FtsOptions
import androidx.room3.Index
import androidx.room3.PrimaryKey
import com.djtech.monai.core.model.Transaction
import com.djtech.monai.core.model.TransactionSource
import com.djtech.monai.core.model.TransactionType
import java.time.Instant
import java.time.LocalDate

/**
 * No foreign keys to wallets or categories: each endpoint fills the cache on its own,
 * so a transaction can arrive before the wallet it belongs to.
 */
@Entity(
    tableName = "transactions",
    indices = [
        Index("date", "id"),
        Index("wallet_id"),
        Index("to_wallet_id"),
        Index("category_id"),
    ],
)
data class TransactionEntity(
    @PrimaryKey
    @ColumnInfo(name = "id")
    val id: String,

    @ColumnInfo(name = "type")
    val type: TransactionType,

    @ColumnInfo(name = "amount")
    val amount: Long,

    @ColumnInfo(name = "wallet_id")
    val walletId: String,

    @ColumnInfo(name = "to_wallet_id")
    val toWalletId: String?,

    @ColumnInfo(name = "category_id")
    val categoryId: String?,

    @ColumnInfo(name = "date")
    val date: LocalDate,

    @ColumnInfo(name = "note")
    val note: String?,

    @ColumnInfo(name = "merchant")
    val merchant: String?,

    @ColumnInfo(name = "receipt_url")
    val receiptUrl: String?,

    @ColumnInfo(name = "source")
    val source: TransactionSource,

    @ColumnInfo(name = "created_at")
    val createdAt: Instant,

    @ColumnInfo(name = "updated_at")
    val updatedAt: Instant,
)

/**
 * Full-text index over note and merchant for offline search. Room keeps it in sync with
 * `transactions` through triggers; join on `rowid`. unicode61 folds case beyond ASCII.
 */
@Fts4(contentEntity = TransactionEntity::class, tokenizer = FtsOptions.TOKENIZER_UNICODE61)
@Entity(tableName = "transactions_fts")
data class TransactionFtsEntity(
    @ColumnInfo(name = "note")
    val note: String?,

    @ColumnInfo(name = "merchant")
    val merchant: String?,
)

fun TransactionEntity.asModel() = Transaction(
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
    updatedAt = updatedAt,
)

fun Transaction.asEntity() = TransactionEntity(
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
    updatedAt = updatedAt,
)
