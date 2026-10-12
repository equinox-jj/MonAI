package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.core.model.User
import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator
import javax.inject.Inject

class LoginUseCase @Inject constructor(private val authRepository: AuthRepository) {

    suspend operator fun invoke(email: String, password: String): AuthResult<User> =
        AuthInputValidator.login(email, password).failOr { authRepository.login(email, password) }
}
