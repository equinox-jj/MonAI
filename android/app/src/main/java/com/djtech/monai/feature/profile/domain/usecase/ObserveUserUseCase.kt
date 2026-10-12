package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.model.User
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/** The cached signed-in user; null until it has been fetched since sign-in. */
class ObserveUserUseCase @Inject constructor(private val profileRepository: ProfileRepository) {
    operator fun invoke(): Flow<User?> = profileRepository.observeUser()
}
