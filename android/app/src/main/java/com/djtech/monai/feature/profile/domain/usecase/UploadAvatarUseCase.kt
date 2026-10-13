package com.djtech.monai.feature.profile.domain.usecase

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.CropSpec
import com.djtech.monai.core.media.ImageEncoding
import com.djtech.monai.core.media.ImageProcessor
import com.djtech.monai.feature.profile.domain.model.AvatarUpload
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emitAll
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

/**
 * Crops the photo at [uri] as framed by the crop window, re-encodes it as a 512×512 WebP (dropping
 * location and camera details) and uploads it.
 */
class UploadAvatarUseCase @Inject constructor(
    private val profileRepository: ProfileRepository,
    private val imageProcessor: ImageProcessor,
) {
    operator fun invoke(uri: String, crop: CropSpec): Flow<AvatarUpload> = flow {
        val image = imageProcessor.cropSquare(
            uri,
            crop,
            AVATAR_SIDE,
            ImageEncoding.WEBP_LOSSY,
            MAX_AVATAR_BYTES,
        )
        if (image == null) {
            emit(AvatarUpload.Done(Outcome.Failure(ProfileError.PhotoUnsupported)))
        } else {
            emitAll(profileRepository.uploadAvatar(image))
        }
    }

    companion object {
        const val AVATAR_SIDE = 512

        /** The API's limit is 2 MB. */
        const val MAX_AVATAR_BYTES = 2 * 1024 * 1024
    }
}
