package com.djtech.monai.feature.profile.data.di

import com.djtech.monai.feature.profile.data.remote.ProfileApiService
import com.djtech.monai.feature.profile.data.repository.ProfileRepositoryImpl
import com.djtech.monai.feature.profile.domain.repository.ProfileRepository
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
abstract class ProfileModule {

    @Binds
    abstract fun bindProfileRepository(repository: ProfileRepositoryImpl): ProfileRepository

    companion object {

        @Provides
        @Singleton
        fun provideProfileApiService(retrofit: Retrofit): ProfileApiService = retrofit.create()
    }
}
