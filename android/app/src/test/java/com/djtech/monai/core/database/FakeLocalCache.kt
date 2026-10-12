package com.djtech.monai.core.database

class FakeLocalCache : LocalCache {
    var clearCount = 0
        private set

    /** When set, [clear] throws it, like a database that cannot be written. */
    var failure: Exception? = null

    override suspend fun clear() {
        failure?.let { throw it }
        clearCount++
    }
}
