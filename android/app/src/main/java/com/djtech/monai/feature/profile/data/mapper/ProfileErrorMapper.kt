package com.djtech.monai.feature.profile.data.mapper

import com.djtech.monai.core.network.ApiError
import com.djtech.monai.feature.profile.domain.model.ProfileError

// Reads only fail offline or unexpectedly; write error codes are mapped once the profile can be edited.
fun ApiError.toProfileError(): ProfileError = when (this) {
    ApiError.Network -> ProfileError.Network
    is ApiError.Http, is ApiError.Unknown -> ProfileError.Unexpected
}
