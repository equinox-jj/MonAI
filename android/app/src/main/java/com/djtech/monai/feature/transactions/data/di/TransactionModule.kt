package com.djtech.monai.feature.transactions.data.di

import com.djtech.monai.feature.transactions.data.remote.TransactionApiService
import com.djtech.monai.feature.transactions.data.repository.ApiTransactionRepository
import com.djtech.monai.feature.transactions.domain.repository.TransactionRepository
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
abstract class TransactionModule {

    @Binds
    abstract fun bindTransactionRepository(repository: ApiTransactionRepository): TransactionRepository

    companion object {

        @Provides
        @Singleton
        fun provideTransactionApiService(retrofit: Retrofit): TransactionApiService = retrofit.create()
    }
}
