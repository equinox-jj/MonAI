package com.djtech.monai.feature.categories.data.di

import com.djtech.monai.feature.categories.data.remote.CategoryApiService
import com.djtech.monai.feature.categories.data.repository.CategoryRepositoryImpl
import com.djtech.monai.feature.categories.domain.repository.CategoryRepository
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
abstract class CategoryModule {

    @Binds
    abstract fun bindCategoryRepository(repository: CategoryRepositoryImpl): CategoryRepository

    companion object {

        @Provides
        @Singleton
        fun provideCategoryApiService(retrofit: Retrofit): CategoryApiService = retrofit.create()
    }
}
