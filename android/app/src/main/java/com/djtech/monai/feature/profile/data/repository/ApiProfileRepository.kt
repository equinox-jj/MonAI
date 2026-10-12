package com.djtech.monai.feature.profile.data.repository

import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.database.dao.UserDao
import com.djtech.monai.core.database.entity.asEntity
import com.djtech.monai.core.database.entity.asModel
import com.djtech.monai.core.model.User
import com.djtech.monai.core.network.ApiCaller
import com.djtech.monai.core.network.model.asModel
import com.djtech.monai.feature.profile.data.mapper.toProfileError
import com.djtech.monai.feature.profile.data.remote.ProfileApiService
import com.djtech.monai.feature.profile.domain.model.ProfileError
import com.djtech.monai.feature.profile.domain.model.ProfileResult
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.coroutines.cancellation.CancellationException

@Singleton
class ApiProfileRepository @Inject constructor(
    private val profileApiService: ProfileApiService,
    private val apiCaller: ApiCaller,
    private val userDao: UserDao,
    private val errorLogger: ErrorLogger,
) : ProfileRepository {

    override fun observeUser(): Flow<User?> = userDao.observe().map { it?.asModel() }

    override suspend fun refreshUser(): ProfileResult<Unit> {
        // Mapped inside the call, so a value that fails to parse becomes an error, not an exception.
        return when (val result = apiCaller.callRaw { profileApiService.getMe().data.asModel() }) {
            is Outcome.Success -> cache(result.data)
            is Outcome.Failure -> Outcome.Failure(result.error.toProfileError())
        }
    }

    // ApiCaller covers network failures; this keeps a failed cache write from throwing too.
    private suspend fun cache(user: User): ProfileResult<Unit> = try {
        userDao.replace(user.asEntity())
        Outcome.Success(Unit)
    } catch (e: CancellationException) {
        throw e
    } catch (e: Exception) {
        errorLogger.log("Caching the user failed", e)
        Outcome.Failure(ProfileError.Unexpected)
    }
}
