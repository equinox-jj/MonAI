package com.djtech.monai.feature.profile.domain.repository

import com.djtech.monai.core.model.User
import com.djtech.monai.feature.profile.domain.model.ProfileResult
import kotlinx.coroutines.flow.Flow

/** The signed-in user, read from the local cache; [refreshUser] fills it from the API. */
interface ProfileRepository {

    /** The cached user; null until `GET /me` has been fetched since the last sign-in. */
    fun observeUser(): Flow<User?>

    /** Fetches the current user and replaces the cached one. */
    suspend fun refreshUser(): ProfileResult<Unit>
}
