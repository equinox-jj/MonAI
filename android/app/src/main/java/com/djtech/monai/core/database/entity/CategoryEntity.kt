package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import androidx.room3.Entity
import androidx.room3.Index
import androidx.room3.PrimaryKey
import com.djtech.monai.core.model.Category
import com.djtech.monai.core.model.CategoryType
import java.time.Instant

@Entity(tableName = "categories", indices = [Index("type")])
data class CategoryEntity(
    @PrimaryKey
    @ColumnInfo(name = "id")
    val id: String,

    @ColumnInfo(name = "name")
    val name: String,

    @ColumnInfo(name = "type")
    val type: CategoryType,

    @ColumnInfo(name = "icon")
    val icon: String?,

    @ColumnInfo(name = "color")
    val color: String?,

    @ColumnInfo(name = "is_default")
    val isDefault: Boolean,

    @ColumnInfo(name = "is_system")
    val isSystem: Boolean,

    @ColumnInfo(name = "is_hidden")
    val isHidden: Boolean,

    @ColumnInfo(name = "created_at")
    val createdAt: Instant,

    @ColumnInfo(name = "updated_at")
    val updatedAt: Instant,
)

fun CategoryEntity.asModel() = Category(
    id = id,
    name = name,
    type = type,
    icon = icon,
    color = color,
    isDefault = isDefault,
    isSystem = isSystem,
    isHidden = isHidden,
    createdAt = createdAt,
    updatedAt = updatedAt,
)

fun Category.asEntity() = CategoryEntity(
    id = id,
    name = name,
    type = type,
    icon = icon,
    color = color,
    isDefault = isDefault,
    isSystem = isSystem,
    isHidden = isHidden,
    createdAt = createdAt,
    updatedAt = updatedAt,
)
