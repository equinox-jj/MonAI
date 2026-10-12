package com.djtech.monai.core.database

class FakeLocalCache : LocalCache {
    var clearCount = 0
        private set

    override suspend fun clear() {
        clearCount++
    }
}
