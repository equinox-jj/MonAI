package com.djtech.monai.core.database

import com.djtech.monai.core.database.dao.UserDao
import com.djtech.monai.core.database.entity.UserEntity
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow

class FakeUserDao(initial: UserEntity? = null) : UserDao {
    private val row = MutableStateFlow(initial)

    /** When set, every write throws it, like a database that cannot be written. */
    var failure: Exception? = null

    val user: UserEntity? get() = row.value

    override fun observe(): Flow<UserEntity?> = row

    override suspend fun upsert(user: UserEntity) {
        failure?.let { throw it }
        row.value = user
    }

    override suspend fun deleteAll() {
        failure?.let { throw it }
        row.value = null
    }
}
