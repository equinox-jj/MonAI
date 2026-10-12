package com.djtech.monai.core.database.dao

import androidx.room3.Dao
import androidx.room3.Query
import androidx.room3.Transaction
import androidx.room3.Upsert
import com.djtech.monai.core.database.entity.UserEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface UserDao {

    /** The signed-in user, or null before `GET /me` has been cached. */
    @Query("SELECT * FROM users LIMIT 1")
    fun observe(): Flow<UserEntity?>

    @Upsert
    suspend fun upsert(user: UserEntity)

    @Query("DELETE FROM users")
    suspend fun deleteAll()

    /** Keeps the table at one row, even if the id changed. */
    @Transaction
    suspend fun replace(user: UserEntity) {
        deleteAll()
        upsert(user)
    }
}
