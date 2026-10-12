package com.djtech.monai.core.database

import javax.inject.Inject

/** The offline copy of the user's data. Cleared on logout and when the session expires. */
interface LocalCache {
    suspend fun clear()
}

class RoomLocalCache @Inject constructor(
    private val database: MonAIDatabase,
) : LocalCache {
    // Runs on the database's query context, which DatabaseModule sets to the IO dispatcher.
    override suspend fun clear() = database.clearAllTables()
}
