package com.djtech.monai.feature.profile.domain.model

/** Why a profile action failed, in terms the profile screens can show. */
sealed interface ProfileError {
    data object Network : ProfileError

    data object Unexpected : ProfileError
}
