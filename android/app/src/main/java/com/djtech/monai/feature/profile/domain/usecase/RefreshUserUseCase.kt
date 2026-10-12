package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.feature.profile.domain.model.ProfileResult
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
import javax.inject.Inject

/** Fetches the signed-in user into the cache. */
class RefreshUserUseCase @Inject constructor(private val profileRepository: ProfileRepository) {
    suspend operator fun invoke(): ProfileResult<Unit> = profileRepository.refreshUser()
}
