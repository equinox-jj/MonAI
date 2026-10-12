package com.djtech.monai.core.di

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.emptyPreferences
import com.djtech.monai.core.datastore.AppPreferences
import com.djtech.monai.core.datastore.SessionPreferences
import dagger.Module
import dagger.Provides
import dagger.hilt.components.SingletonComponent
import dagger.hilt.testing.TestInstallIn
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import javax.inject.Singleton

/**
 * Hilt builds a new singleton component per test, and a file DataStore refuses a second instance on
 * the same file while the first one's scope lives on. Tests get a fresh in-memory store instead.
 */
@Module
@TestInstallIn(components = [SingletonComponent::class], replaces = [DataStoreModule::class])
object TestDataStoreModule {

    @Provides
    @Singleton
    @SessionPreferences
    fun provideSessionDataStore(): DataStore<Preferences> = InMemoryDataStore()

    @Provides
    @Singleton
    @AppPreferences
    fun provideAppDataStore(): DataStore<Preferences> = InMemoryDataStore()
}

/** A Preferences DataStore kept in memory. */
internal class InMemoryDataStore : DataStore<Preferences> {
    private val state = MutableStateFlow(emptyPreferences())
    private val lock = Mutex()

    override val data: Flow<Preferences> = state

    override suspend fun updateData(transform: suspend (t: Preferences) -> Preferences): Preferences =
        lock.withLock { transform(state.value).also { state.value = it } }
}
