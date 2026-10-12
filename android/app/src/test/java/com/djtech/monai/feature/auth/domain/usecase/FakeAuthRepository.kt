package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.Role
import com.djtech.monai.core.model.User
import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import java.time.Instant

/** Records the calls it gets and answers with the configured results. */
class FakeAuthRepository : AuthRepository {
    var userResult: AuthResult<User> = Outcome.Success(testUser)
    var unitResult: AuthResult<Unit> = Outcome.Success(Unit)

    val calls = mutableListOf<String>()

    override suspend fun register(name: String, email: String, password: String): AuthResult<User> {
        calls += "register($name, $email, $password)"
        return userResult
    }

    override suspend fun login(email: String, password: String): AuthResult<User> {
        calls += "login($email, $password)"
        return userResult
    }

    override suspend fun logout() {
        calls += "logout"
    }

    override suspend fun logoutAllDevices(): AuthResult<Unit> {
        calls += "logoutAllDevices"
        return unitResult
    }

    override suspend fun changePassword(currentPassword: String, newPassword: String): AuthResult<Unit> {
        calls += "changePassword($currentPassword, $newPassword)"
        return unitResult
    }
}

val testUser = User(
    id = "2b1f6c1e-4a7d-4c1b-9a43-1f7e0c9d2a11",
    name = "Joshua",
    email = "joshua@example.com",
    avatarUrl = null,
    timezone = "Asia/Jakarta",
    role = Role(slug = "user", name = "User"),
    permissions = emptySet(),
    createdAt = Instant.parse("2026-10-08T12:30:00Z"),
)
