package com.djtech.monai.feature.budgets.data.di

import com.djtech.monai.feature.budgets.data.remote.BudgetApiService
import com.djtech.monai.feature.budgets.data.repository.BudgetRepositoryImpl
import com.djtech.monai.feature.budgets.domain.repository.BudgetRepository
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
abstract class BudgetModule {

    @Binds
    abstract fun bindBudgetRepository(repository: BudgetRepositoryImpl): BudgetRepository

    companion object {

        @Provides
        @Singleton
        fun provideBudgetApiService(retrofit: Retrofit): BudgetApiService = retrofit.create()
    }
}
