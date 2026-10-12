package com.djtech.monai.core.di

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStoreFile
import com.djtech.monai.core.common.dispatcher.Dispatcher
import com.djtech.monai.core.common.dispatcher.MonAIDispatcher
import com.djtech.monai.core.datastore.KeystoreTokenCipher
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
    fun provideSessionDataStore(
        @ApplicationContext context: Context,
        @Dispatcher(MonAIDispatcher.IO) ioDispatcher: CoroutineDispatcher,
    ): DataStore<Preferences> = PreferenceDataStoreFactory.create(
        scope = CoroutineScope(ioDispatcher + SupervisorJob()),
    ) { context.preferencesDataStoreFile("session") }
}
