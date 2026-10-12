package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.model.User
import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator
import com.djtech.monai.feature.auth.domain.validation.normalizedEmail
import javax.inject.Inject

class LoginUseCase @Inject constructor(private val authRepository: AuthRepository) {

    suspend operator fun invoke(email: String, password: String): AuthResult<User> {
        val cleanEmail = email.normalizedEmail()
        return AuthInputValidator.login(cleanEmail, password).failOr { authRepository.login(cleanEmail, password) }
    }
}
