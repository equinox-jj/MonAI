package com.djtech.monai.feature.auth.data.di

import com.djtech.monai.core.network.auth.SessionExpiredHandler
import com.djtech.monai.feature.auth.data.remote.AuthApiService
import com.djtech.monai.feature.auth.data.repository.ApiAuthRepository
import com.djtech.monai.feature.auth.data.session.ClearSessionOnExpiry
import com.djtech.monai.feature.auth.domain.repository.AuthRepository
import dagger.Binds
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import retrofit2.create
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class AuthBindsModule {

    @Binds
    abstract fun bindSessionExpiredHandler(handler: ClearSessionOnExpiry): SessionExpiredHandler

    @Binds
    abstract fun bindAuthRepository(repository: ApiAuthRepository): AuthRepository
}

@Module
@InstallIn(SingletonComponent::class)
object AuthModule {

    @Provides
    @Singleton
    fun provideAuthApiService(retrofit: Retrofit): AuthApiService = retrofit.create()
}
