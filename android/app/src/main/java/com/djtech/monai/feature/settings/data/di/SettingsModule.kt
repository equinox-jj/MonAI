package com.djtech.monai.feature.settings.data.di

import com.djtech.monai.feature.settings.data.remote.AdminProviderApiService
import com.djtech.monai.feature.settings.data.repository.ApiAdminProviderRepository
import com.djtech.monai.feature.settings.domain.repository.AdminProviderRepository
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
abstract class SettingsBindsModule {

    @Binds
    abstract fun bindAdminProviderRepository(repository: ApiAdminProviderRepository): AdminProviderRepository
}

@Module
@InstallIn(SingletonComponent::class)
object SettingsModule {

    @Provides
    @Singleton
    fun provideAdminProviderApiService(retrofit: Retrofit): AdminProviderApiService = retrofit.create()
}
