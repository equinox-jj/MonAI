package com.djtech.monai.feature.profile.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.log.runLogged
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.common.result.flatMap
import com.djtech.monai.core.common.result.map
import com.djtech.monai.core.common.result.mapError
import com.djtech.monai.core.database.LocalCache
import com.djtech.monai.core.database.dao.UserDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.media.EncodedImage
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.ApiError
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

@Singleton
class ProfileRepositoryImpl @Inject constructor(
    private val profileApiService: ProfileApiService,
    private val apiCaller: ApiCaller,
    private val userDao: UserDao,
    private val sessionStore: SessionStore,
    private val localCache: LocalCache,
    private val errorLogger: ErrorLogger,
) : ProfileRepository {

    override fun observeUser(): Flow<User?> = userDao.observe().map { it?.asModel() }

    override suspend fun refreshUser(): ProfileResult<Unit> = fetchUser {
        profileApiService.getMe().data.asModel()
    }.map { }

    override suspend fun updateProfile(changes: ProfileChanges): ProfileResult<User> = fetchUser {
        profileApiService.updateMe(UpdateMeRequestDto(changes.name, changes.timezone)).data.asModel()
    }

    override fun uploadAvatar(image: EncodedImage): Flow<AvatarUpload> = channelFlow {
        val part = filePart(image.bytes, image.mimeType) { trySend(AvatarUpload.Progress(it)) }
        val result = fetchUser { profileApiService.setAvatar(part).data.asModel() }.map { }
        send(AvatarUpload.Done(result))
    }

    override suspend fun removeAvatar(): ProfileResult<Unit> = apiCaller.callRaw { profileApiService.deleteAvatar() }
        .mapError(ApiError::toProfileError)
        .flatMap {
            // The response has no user, so the cached one just loses its photo.
            cacheUser {
                val user = userDao.observe().first() ?: return@cacheUser
                userDao.upsert(user.copy(avatarUrl = null))
            }
        }

    override suspend fun deleteAccount(password: String): ProfileResult<Unit> =
        apiCaller.callRaw { profileApiService.deleteMe(DeleteAccountRequestDto(password)) }
            .mapError(ApiError::toProfileError)
            .flatMap { signOut() }

    // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
    private suspend fun fetchUser(request: suspend () -> User): ProfileResult<User> = apiCaller.callRaw(request)
        .mapError(ApiError::toProfileError)
        .flatMap { user ->
            cacheUser {
                userDao.replace(user.asEntity())
                user
            }
        }

    /**
     * The account is gone on the server, so this device signs out whatever happens next: a token
     * that can't be removed is rejected on the next request anyway.
     */
    private suspend fun signOut(): ProfileResult<Unit> {
        errorLogger.runLogged("Removing the token of a deleted account failed", Unit) { sessionStore.clear() }
        errorLogger.runLogged("Clearing the cache of a deleted account failed", Unit) { localCache.clear() }
        return Outcome.Success(Unit)
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private inline fun <T> cacheUser(write: () -> T): ProfileResult<T> = errorLogger.runLogged(
        "Caching the user failed",
        ProfileError.Unexpected,
        write,
    )
}
