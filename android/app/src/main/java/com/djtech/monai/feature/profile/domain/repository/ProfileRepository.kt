package com.djtech.monai.feature.profile.domain.repository

import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.core.model.User
import com.djtech.monai.feature.profile.domain.model.AvatarUpload
import com.djtech.monai.feature.profile.domain.model.ProfileChanges
import com.djtech.monai.feature.profile.domain.model.ProfileResult
import kotlinx.coroutines.flow.Flow

/** The signed-in user, read from the local cache; every write caches what the API returns. */
interface ProfileRepository {

    /** The cached user; null until `GET /me` has been fetched since the last sign-in. */
    fun observeUser(): Flow<User?>

    /** Fetches the current user and replaces the cached one. */
    suspend fun refreshUser(): ProfileResult<Unit>

    suspend fun updateProfile(changes: ProfileChanges): ProfileResult<User>

    /** Sends [image] as the profile photo, reporting progress, then caches the updated user. */
    fun uploadAvatar(image: EncodedImage): Flow<AvatarUpload>

    /** Goes back to the initials. */
    suspend fun removeAvatar(): ProfileResult<Unit>

    /** Deletes the account and every piece of its data, then signs out of this device. */
    suspend fun deleteAccount(password: String): ProfileResult<Unit>
}
