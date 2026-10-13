package com.djtech.monai.feature.profile.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.core.model.User
import com.djtech.monai.feature.profile.domain.model.AvatarUpload
import com.djtech.monai.feature.profile.domain.model.ProfileChanges
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.model.ProfileResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.flow

/**
 * Serves [user] as the cache. Writes are recorded and succeed, updating [user], unless their
 * error is set.
 */
class FakeProfileRepository(user: User? = null) : ProfileRepository {
    val user = MutableStateFlow(user)
    var refreshResult: ProfileResult<Unit> = Outcome.Success(Unit)
    var refreshCount = 0

    val updates = mutableListOf<ProfileChanges>()
    var updateError: ProfileError? = null

    val uploadedImages = mutableListOf<EncodedImage>()
    var uploadError: ProfileError? = null

    /** The progress steps an upload reports before it finishes. */
    var uploadProgress = listOf(0.5f, 1f)

    /** The photo URL a successful upload sets. */
    var uploadedAvatarUrl = "https://cdn.example.com/avatars/new.webp"

    var removeAvatarCount = 0
    var removeAvatarError: ProfileError? = null

    val deletedWithPasswords = mutableListOf<String>()
    var deleteError: ProfileError? = null

    override fun observeUser(): Flow<User?> = user

    override suspend fun refreshUser(): ProfileResult<Unit> {
        refreshCount++
        return refreshResult
    }

    override suspend fun updateProfile(changes: ProfileChanges): ProfileResult<User> {
        updates += changes
        updateError?.let { return Outcome.Failure(it) }
        val updated = requireNotNull(user.value).let {
            it.copy(name = changes.name ?: it.name, timezone = changes.timezone ?: it.timezone)
        }
        user.value = updated
        return Outcome.Success(updated)
    }

    override fun uploadAvatar(image: EncodedImage): Flow<AvatarUpload> = flow {
        uploadedImages += image
        uploadProgress.forEach { emit(AvatarUpload.Progress(it)) }
        val error = uploadError
        if (error != null) {
            emit(AvatarUpload.Done(Outcome.Failure(error)))
        } else {
            user.value = user.value?.copy(avatarUrl = uploadedAvatarUrl)
            emit(AvatarUpload.Done(Outcome.Success(Unit)))
        }
    }

    override suspend fun removeAvatar(): ProfileResult<Unit> {
        removeAvatarCount++
        removeAvatarError?.let { return Outcome.Failure(it) }
        user.value = user.value?.copy(avatarUrl = null)
        return Outcome.Success(Unit)
    }

    override suspend fun deleteAccount(password: String): ProfileResult<Unit> {
        deletedWithPasswords += password
        deleteError?.let { return Outcome.Failure(it) }
        user.value = null
        return Outcome.Success(Unit)
    }
}
