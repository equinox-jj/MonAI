package com.djtech.monai.feature.auth.domain.usecase

import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import javax.inject.Inject

/** Expires the session now if its token is past the server's expiry, as a rejected token would. */
class ExpireSessionIfDueUseCase @Inject constructor(private val authRepository: AuthRepository) {
    suspend operator fun invoke() {
        authRepository.expireSessionIfDue()
    }
}
