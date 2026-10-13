package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.feature.profile.domain.model.NameIssue
import com.djtech.monai.feature.profile.domain.model.ProfileChanges
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.model.ProfileResult
import com.djtech.monai.feature.profile.domain.model.isKnownTimezone
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
import kotlinx.coroutines.flow.first
import javax.inject.Inject

/** Saves the display name and timezone, sending only what differs from the cached user. */
class UpdateProfileUseCase @Inject constructor(private val profileRepository: ProfileRepository) {

    suspend operator fun invoke(name: String, timezone: String): ProfileResult<Unit> {
        val trimmed = name.trim()
        when {
            trimmed.isEmpty() -> return Outcome.Failure(ProfileError.InvalidName(NameIssue.REQUIRED))
            trimmed.length > MAX_NAME_LENGTH -> return Outcome.Failure(ProfileError.InvalidName(NameIssue.TOO_LONG))
            !isKnownTimezone(timezone) -> return Outcome.Failure(ProfileError.InvalidTimezone)
        }
        val current = profileRepository.observeUser().first()
        val changes = ProfileChanges(
            name = trimmed.takeIf { it != current?.name },
            timezone = timezone.takeIf { it != current?.timezone },
        )
        if (changes.isEmpty) return Outcome.Success(Unit)
        return when (val result = profileRepository.updateProfile(changes)) {
            is Outcome.Success -> Outcome.Success(Unit)
            is Outcome.Failure -> result
        }
    }

    companion object {
        const val MAX_NAME_LENGTH = 100
    }
}
