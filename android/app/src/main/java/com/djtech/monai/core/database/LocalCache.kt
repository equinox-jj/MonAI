package com.djtech.monai.core.database

import com.djtech.monai.core.datastore.SearchHistoryStore
import javax.inject.Inject

/** The offline copy of the user's data, search history included. Cleared on logout and when the session expires. */
interface LocalCache {
    suspend fun clear()
}

class RoomLocalCache @Inject constructor(
    private val database: MonAIDatabase,
    private val searchHistoryStore: SearchHistoryStore,
) : LocalCache {
    override suspend fun clear() {
        // Runs on the database's query context, which DatabaseModule sets to the IO dispatcher.
        database.clearAllTables()
        searchHistoryStore.clear()
    }
}
