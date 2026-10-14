package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import com.djtech.monai.feature.auth.domain.validation.AuthInputValidator
import javax.inject.Inject

/** Changes the password, which signs out every device, this one included. */
class ChangePasswordUseCase @Inject constructor(private val authRepository: AuthRepository) {

    suspend operator fun invoke(currentPassword: String, newPassword: String): AuthResult<Unit> =
        AuthInputValidator.changePassword(currentPassword, newPassword).failOr {
            authRepository.changePassword(currentPassword, newPassword)
        }
}
