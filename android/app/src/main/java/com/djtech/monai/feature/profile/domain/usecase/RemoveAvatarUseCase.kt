package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.feature.profile.domain.model.ProfileResult
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
import javax.inject.Inject

class RemoveAvatarUseCase @Inject constructor(private val profileRepository: ProfileRepository) {
    suspend operator fun invoke(): ProfileResult<Unit> = profileRepository.removeAvatar()
}
