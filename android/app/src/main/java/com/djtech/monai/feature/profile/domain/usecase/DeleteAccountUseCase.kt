package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.model.ProfileResult
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
import javax.inject.Inject

/** Deletes the account once the password is typed; the session ends with it. */
class DeleteAccountUseCase @Inject constructor(private val profileRepository: ProfileRepository) {
    suspend operator fun invoke(password: String): ProfileResult<Unit> {
        // Sent as typed: spaces may be part of the password.
        if (password.isEmpty()) return Outcome.Failure(ProfileError.PasswordRequired)
        return profileRepository.deleteAccount(password)
    }
}
