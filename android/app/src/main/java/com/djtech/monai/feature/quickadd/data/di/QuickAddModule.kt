package com.djtech.monai.feature.quickadd.data.di

import com.djtech.monai.feature.quickadd.data.remote.QuickAddApiService
import com.djtech.monai.feature.quickadd.data.repository.ApiQuickAddRepository
import com.djtech.monai.feature.quickadd.domain.repository.QuickAddRepository
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
abstract class QuickAddModule {

    @Binds
    abstract fun bindQuickAddRepository(repository: ApiQuickAddRepository): QuickAddRepository

    companion object {

        @Provides
        @Singleton
        fun provideQuickAddApiService(retrofit: Retrofit): QuickAddApiService = retrofit.create()
    }
}
