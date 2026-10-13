package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.feature.auth.domain.model.AuthResult
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import javax.inject.Inject

/** Revokes every token of the user, this device's included, then signs out here. */
class LogoutAllDevicesUseCase @Inject constructor(private val authRepository: AuthRepository) {
    suspend operator fun invoke(): AuthResult<Unit> = authRepository.logoutAllDevices()
}
