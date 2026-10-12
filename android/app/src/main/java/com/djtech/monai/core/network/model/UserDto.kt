package com.djtech.monai.core.network.model

import com.djtech.monai.core.model.Role
import com.djtech.monai.core.model.User
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.time.Instant

/** The API's `Me` object, returned by `/me` and inside every auth response. */
@Serializable
data class UserDto(
    @SerialName("id") val id: String,
    @SerialName("name") val name: String,
    @SerialName("email") val email: String,
    @SerialName("avatar_url") val avatarUrl: String? = null,
    @SerialName("timezone") val timezone: String,
    @SerialName("role") val role: RoleDto,
    @SerialName("permissions") val permissions: List<String> = emptyList(),
    @SerialName("created_at") val createdAt: String,
)

@Serializable
data class RoleDto(
    @SerialName("slug") val slug: String,
    @SerialName("name") val name: String,
)

fun UserDto.asModel(): User = User(
    id = id,
    name = name,
    email = email,
    avatarUrl = avatarUrl,
    timezone = timezone,
    role = Role(slug = role.slug, name = role.name),
    permissions = permissions.toSet(),
    createdAt = Instant.parse(createdAt),
)
