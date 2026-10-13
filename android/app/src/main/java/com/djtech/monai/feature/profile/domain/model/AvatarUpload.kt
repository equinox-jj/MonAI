package com.djtech.monai.feature.profile.domain.model

/** Steps of a profile photo upload: progress while sending, then the outcome. */
sealed interface AvatarUpload {
    /** [fraction] of the photo sent, 0..1. */
    data class Progress(val fraction: Float) : AvatarUpload

    data class Done(val result: ProfileResult<Unit>) : AvatarUpload
}
