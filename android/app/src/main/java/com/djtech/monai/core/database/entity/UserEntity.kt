package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import androidx.room3.Entity
import androidx.room3.PrimaryKey
import com.djtech.monai.core.model.Role
import com.djtech.monai.core.model.User
import java.time.Instant

/** The signed-in user; the table holds at most one row. */
@Entity(tableName = "users")
data class UserEntity(
    @PrimaryKey
    @ColumnInfo(name = "id")
    val id: String,

    @ColumnInfo(name = "name")
    val name: String,

    @ColumnInfo(name = "email")
    val email: String,

    /** Presigned and short-lived, so a cached one may have expired; the UI falls back to initials. */
    @ColumnInfo(name = "avatar_url")
    val avatarUrl: String?,

    @ColumnInfo(name = "timezone")
    val timezone: String,

    @ColumnInfo(name = "role_slug")
    val roleSlug: String,

    @ColumnInfo(name = "role_name")
    val roleName: String,

    @ColumnInfo(name = "permissions")
    val permissions: List<String>,

    @ColumnInfo(name = "created_at")
    val createdAt: Instant,
)

fun UserEntity.asModel() = User(
    id = id,
    name = name,
    email = email,
    avatarUrl = avatarUrl,
    timezone = timezone,
    role = Role(slug = roleSlug, name = roleName),
    permissions = permissions.toSet(),
    createdAt = createdAt,
)

fun User.asEntity() = UserEntity(
    id = id,
    name = name,
    email = email,
    avatarUrl = avatarUrl,
    timezone = timezone,
    roleSlug = role.slug,
    roleName = role.name,
    // Sorted so the stored value doesn't depend on the set's order.
    permissions = permissions.sorted(),
    createdAt = createdAt,
)
