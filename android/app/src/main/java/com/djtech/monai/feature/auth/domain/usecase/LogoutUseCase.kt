package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import javax.inject.Inject

/** Signs out of this device; navigation follows the session to Sign in. */
class LogoutUseCase @Inject constructor(private val authRepository: AuthRepository) {
    suspend operator fun invoke(): AuthResult<Unit> = authRepository.logout()
}
