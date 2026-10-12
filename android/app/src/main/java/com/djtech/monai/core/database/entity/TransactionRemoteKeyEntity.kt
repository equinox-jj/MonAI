package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import androidx.room3.Entity
import androidx.room3.PrimaryKey
import java.time.Instant

/**
 * Where the transactions RemoteMediator left off for one list query. [queryKey] encodes
 * the month, filters and search text; [nextCursor] is null once the last page is loaded.
 */
@Entity(tableName = "transaction_remote_keys")
data class TransactionRemoteKeyEntity(
    @PrimaryKey
    @ColumnInfo(name = "query_key")
    val queryKey: String,

    @ColumnInfo(name = "next_cursor")
    val nextCursor: String?,

    @ColumnInfo(name = "updated_at")
    val updatedAt: Instant,
)
