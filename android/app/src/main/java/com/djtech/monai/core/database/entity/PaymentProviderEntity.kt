package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import androidx.room3.Entity
import androidx.room3.PrimaryKey
import com.djtech.monai.core.model.PaymentProvider
import com.djtech.monai.core.model.WalletType

@Entity(tableName = "payment_providers")
data class PaymentProviderEntity(
    @PrimaryKey
    @ColumnInfo(name = "id")
    val id: String,

    @ColumnInfo(name = "slug")
    val slug: String,

    @ColumnInfo(name = "name")
    val name: String,

    @ColumnInfo(name = "type")
    val type: WalletType,

    @ColumnInfo(name = "logo_url")
    val logoUrl: String?,

    @ColumnInfo(name = "aliases")
    val aliases: List<String>,

    @ColumnInfo(name = "sort_order")
    val sortOrder: Int,
)

/** The cached catalog's version and ETag; a single row with [id] 0. */
@Entity(tableName = "payment_provider_catalog")
data class PaymentProviderCatalogEntity(
    @PrimaryKey
    @ColumnInfo(name = "id")
    val id: Int = SINGLE_ROW_ID,

    @ColumnInfo(name = "version")
    val version: Long,

    @ColumnInfo(name = "etag")
    val etag: String?,
) {
    companion object {
        const val SINGLE_ROW_ID = 0
    }
}

fun PaymentProviderEntity.asModel() = PaymentProvider(
    id = id,
    slug = slug,
    name = name,
    type = type,
    logoUrl = logoUrl,
    aliases = aliases,
    sortOrder = sortOrder,
)

fun PaymentProvider.asEntity() = PaymentProviderEntity(
    id = id,
    slug = slug,
    name = name,
    type = type,
    logoUrl = logoUrl,
    aliases = aliases,
    sortOrder = sortOrder,
)
