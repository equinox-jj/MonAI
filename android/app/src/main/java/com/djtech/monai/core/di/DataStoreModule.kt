package com.djtech.monai.core.di

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.core.handlers.ReplaceFileCorruptionHandler
import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.preferencesDataStoreFile
import com.djtech.monai.core.common.dispatcher.Dispatcher
import com.djtech.monai.core.common.dispatcher.MonAIDispatcher
import com.djtech.monai.core.datastore.AppPreferences
import com.djtech.monai.core.datastore.KeystoreTokenCipher
import com.djtech.monai.core.datastore.SessionPreferences
import com.djtech.monai.core.datastore.SessionStore
import com.djtech.monai.core.datastore.TokenCipher
import com.djtech.monai.core.network.auth.AccessTokenProvider
import dagger.Binds
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import java.io.File
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class DataStoreBindsModule {

    @Binds
    abstract fun bindTokenCipher(cipher: KeystoreTokenCipher): TokenCipher

    @Binds
    abstract fun bindAccessTokenProvider(store: SessionStore): AccessTokenProvider
}

@Module
@InstallIn(SingletonComponent::class)
object DataStoreModule {

    @Provides
    @Singleton
    @SessionPreferences
    fun provideSessionDataStore(
        @ApplicationContext context: Context,
        @Dispatcher(MonAIDispatcher.IO) ioDispatcher: CoroutineDispatcher,
    ): DataStore<Preferences> = createPreferencesDataStore(CoroutineScope(ioDispatcher + SupervisorJob())) {
        context.preferencesDataStoreFile("session")
    }

    @Provides
    @Singleton
    @AppPreferences
    fun provideAppDataStore(
        @ApplicationContext context: Context,
        @Dispatcher(MonAIDispatcher.IO) ioDispatcher: CoroutineDispatcher,
    ): DataStore<Preferences> = createPreferencesDataStore(CoroutineScope(ioDispatcher + SupervisorJob())) {
        context.preferencesDataStoreFile("app")
    }
}

/**
 * A damaged file would fail every read and write, so it is replaced with an empty one: the session
 * reads as signed out and onboarding as not done, which the user can recover from.
 */
internal fun createPreferencesDataStore(scope: CoroutineScope, produceFile: () -> File): DataStore<Preferences> =
    PreferenceDataStoreFactory.create(
        corruptionHandler = ReplaceFileCorruptionHandler { emptyPreferences() },
        scope = scope,
        produceFile = produceFile,
    )
