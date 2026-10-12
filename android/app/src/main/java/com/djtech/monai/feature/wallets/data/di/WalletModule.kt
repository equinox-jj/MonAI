package com.djtech.monai.feature.wallets.data.di

import com.djtech.monai.feature.wallets.data.remote.WalletApiService
import com.djtech.monai.feature.wallets.data.repository.ApiWalletRepository
import com.djtech.monai.feature.wallets.domain.repository.WalletRepository
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
abstract class WalletBindsModule {

    @Binds
    abstract fun bindWalletRepository(repository: ApiWalletRepository): WalletRepository
}

@Module
@InstallIn(SingletonComponent::class)
object WalletModule {

    @Provides
    @Singleton
    fun provideWalletApiService(retrofit: Retrofit): WalletApiService = retrofit.create()
}
