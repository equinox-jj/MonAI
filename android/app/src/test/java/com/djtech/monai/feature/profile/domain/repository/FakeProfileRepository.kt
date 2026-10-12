package com.djtech.monai.feature.profile.domain.repository

import com.djtech.monai.core.common.result.Outcome
import com.djtech.monai.core.model.User
import com.djtech.monai.feature.profile.domain.model.ProfileResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow

/** Serves [user] as the cache and answers refresh with [refreshResult]. */
class FakeProfileRepository(user: User? = null) : ProfileRepository {
    val user = MutableStateFlow(user)
    var refreshResult: ProfileResult<Unit> = Outcome.Success(Unit)
    var refreshCount = 0

    override fun observeUser(): Flow<User?> = user

    override suspend fun refreshUser(): ProfileResult<Unit> {
        refreshCount++
        return refreshResult
    }
}
