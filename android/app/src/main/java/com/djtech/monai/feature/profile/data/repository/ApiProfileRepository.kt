package com.djtech.monai.feature.profile.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.LocalCache
import com.djtech.monai.core.database.dao.UserDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.model.asModel
import com.djtech.monai.core.network.upload.filePart
import com.djtech.monai.feature.profile.data.dto.DeleteAccountRequestDto
import com.djtech.monai.feature.profile.data.dto.UpdateMeRequestDto
import com.djtech.monai.feature.profile.data.mapper.toProfileError
import com.djtech.monai.feature.profile.data.remote.ProfileApiService
import com.djtech.monai.feature.profile.domain.model.AvatarUpload
import com.djtech.monai.feature.profile.domain.model.ProfileChanges
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.model.ProfileResult
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.channelFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.cancellation.CancellationException

@Singleton
class ApiProfileRepository @Inject constructor(
    private val profileApiService: ProfileApiService,
    private val apiCaller: ApiCaller,
    private val userDao: UserDao,
    private val sessionStore: SessionStore,
    private val localCache: LocalCache,
    private val errorLogger: ErrorLogger,
) : ProfileRepository {

    override fun observeUser(): Flow<User?> = userDao.observe().map { it?.asModel() }

    override suspend fun refreshUser(): ProfileResult<Unit> =
        fetchUser { profileApiService.getMe().data.asModel() }.unit()

    override suspend fun updateProfile(changes: ProfileChanges): ProfileResult<User> =
        fetchUser { profileApiService.updateMe(UpdateMeRequestDto(changes.name, changes.timezone)).data.asModel() }

    override fun uploadAvatar(image: EncodedImage): Flow<AvatarUpload> = channelFlow {
        val part = filePart(image.bytes, image.mimeType) { trySend(AvatarUpload.Progress(it)) }
        val result = fetchUser { profileApiService.setAvatar(part).data.asModel() }.unit()
        send(AvatarUpload.Done(result))
    }

    override suspend fun removeAvatar(): ProfileResult<Unit> =
        when (val result = apiCaller.callRaw { profileApiService.deleteAvatar() }) {
            // The response has no user, so the cached one just loses its photo.
            is Outcome.Success -> writingCache {
                userDao.observe().first()?.let { userDao.upsert(it.copy(avatarUrl = null)) }
            }
            is Outcome.Failure -> Outcome.Failure(result.error.toProfileError())
        }

    override suspend fun deleteAccount(password: String): ProfileResult<Unit> =
        when (val result = apiCaller.callRaw { profileApiService.deleteMe(DeleteAccountRequestDto(password)) }) {
            is Outcome.Success -> signOut()
            is Outcome.Failure -> Outcome.Failure(result.error.toProfileError())
        }

    // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
    private suspend fun fetchUser(request: suspend () -> User): ProfileResult<User> =
        when (val result = apiCaller.callRaw(request)) {
            is Outcome.Success -> when (val cached = writingCache { userDao.replace(result.data.asEntity()) }) {
                is Outcome.Success -> Outcome.Success(result.data)
                is Outcome.Failure -> cached
            }
            is Outcome.Failure -> Outcome.Failure(result.error.toProfileError())
        }

    /**
     * The account is gone on the server, so this device signs out whatever happens next: a token
     * that can't be removed is rejected on the next request anyway.
     */
    private suspend fun signOut(): ProfileResult<Unit> {
        try {
            sessionStore.clear()
        } catch (e: CancellationException) {
            throw e
        } catch (e: Exception) {
            errorLogger.log("Removing the token of a deleted account failed", e)
        }
        try {
            localCache.clear()
        } catch (e: CancellationException) {
            throw e
        } catch (e: Exception) {
            errorLogger.log("Clearing the cache of a deleted account failed", e)
        }
        return Outcome.Success(Unit)
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private suspend fun writingCache(block: suspend () -> Unit): ProfileResult<Unit> = try {
        block()
        Outcome.Success(Unit)
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Caching the user failed", e)
        Outcome.Failure(ProfileError.Unexpected)
    }
}

private fun <T> ProfileResult<T>.unit(): ProfileResult<Unit> = when (this) {
    is Outcome.Success -> Outcome.Success(Unit)
    is Outcome.Failure -> this
}
