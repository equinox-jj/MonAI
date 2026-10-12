package com.djtech.monai.feature.budgets.data.di

import com.djtech.monai.feature.budgets.data.remote.BudgetApiService
import com.djtech.monai.feature.budgets.data.repository.ApiBudgetRepository
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
abstract class BudgetBindsModule {

    @Binds
    abstract fun bindBudgetRepository(repository: ApiBudgetRepository): BudgetRepository
}

@Module
@InstallIn(SingletonComponent::class)
object BudgetModule {

    @Provides
    @Singleton
    fun provideBudgetApiService(retrofit: Retrofit): BudgetApiService = retrofit.create()
}
