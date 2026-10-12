package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import androidx.room3.Entity
import androidx.room3.PrimaryKey
import com.djtech.monai.core.model.Wallet
import com.djtech.monai.core.model.WalletType
import java.time.Instant

@Entity(tableName = "wallets")
data class WalletEntity(
    @PrimaryKey
    @ColumnInfo(name = "id")
    val id: String,

    @ColumnInfo(name = "provider_id")
    val providerId: String?,

    @ColumnInfo(name = "name")
    val name: String,

    @ColumnInfo(name = "type")
    val type: WalletType,

    @ColumnInfo(name = "logo_url")
    val logoUrl: String?,

    @ColumnInfo(name = "initial_balance")
    val initialBalance: Long,

    @ColumnInfo(name = "current_balance")
    val currentBalance: Long,

    @ColumnInfo(name = "icon")
    val icon: String?,

    @ColumnInfo(name = "color")
    val color: String?,

    @ColumnInfo(name = "is_default")
    val isDefault: Boolean,

    @ColumnInfo(name = "is_archived")
    val isArchived: Boolean,

    @ColumnInfo(name = "created_at")
    val createdAt: Instant,

    @ColumnInfo(name = "updated_at")
    val updatedAt: Instant,
)

fun WalletEntity.asModel() = Wallet(
    id = id,
    providerId = providerId,
    name = name,
    type = type,
    logoUrl = logoUrl,
    initialBalance = initialBalance,
    currentBalance = currentBalance,
    icon = icon,
    color = color,
    isDefault = isDefault,
    isArchived = isArchived,
    createdAt = createdAt,
    updatedAt = updatedAt,
)

fun Wallet.asEntity() = WalletEntity(
    id = id,
    providerId = providerId,
    name = name,
    type = type,
    logoUrl = logoUrl,
    initialBalance = initialBalance,
    currentBalance = currentBalance,
    icon = icon,
    color = color,
    isDefault = isDefault,
    isArchived = isArchived,
    createdAt = createdAt,
    updatedAt = updatedAt,
)
