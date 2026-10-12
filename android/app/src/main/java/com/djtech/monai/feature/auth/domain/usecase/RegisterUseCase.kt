package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.model.User
import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator
import com.djtech.monai.feature.auth.domain.validation.normalizedEmail
import com.djtech.monai.feature.auth.domain.validation.normalizedName
import javax.inject.Inject

class RegisterUseCase @Inject constructor(private val authRepository: AuthRepository) {

    suspend operator fun invoke(name: String, email: String, password: String): AuthResult<User> {
        val cleanName = name.normalizedName()
        val cleanEmail = email.normalizedEmail()
        return AuthInputValidator.register(cleanName, cleanEmail, password).failOr {
            authRepository.register(cleanName, cleanEmail, password)
        }
    }
}
