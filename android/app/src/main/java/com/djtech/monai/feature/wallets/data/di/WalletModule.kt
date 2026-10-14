package com.djtech.monai.feature.wallets.data.di

import com.djtech.monai.feature.wallets.data.remote.PaymentProviderApiService
import com.djtech.monai.feature.wallets.data.remote.WalletApiService
import com.djtech.monai.feature.wallets.data.repository.PaymentProviderRepositoryImpl
import com.djtech.monai.feature.wallets.data.repository.WalletRepositoryImpl
import com.djtech.monai.feature.wallets.data.seed.AssetPaymentProviderSeed
import com.djtech.monai.feature.wallets.data.seed.PaymentProviderSeed
import com.djtech.monai.feature.wallets.domain.repository.PaymentProviderRepository
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
abstract class WalletModule {

    @Binds
    abstract fun bindWalletRepository(repository: WalletRepositoryImpl): WalletRepository

    @Binds
    abstract fun bindPaymentProviderRepository(repository: PaymentProviderRepositoryImpl): PaymentProviderRepository

    @Binds
    abstract fun bindPaymentProviderSeed(seed: AssetPaymentProviderSeed): PaymentProviderSeed

    companion object {

        @Provides
        @Singleton
        fun provideWalletApiService(retrofit: Retrofit): WalletApiService = retrofit.create()

        @Provides
        @Singleton
        fun providePaymentProviderApiService(retrofit: Retrofit): PaymentProviderApiService = retrofit.create()
    }
}
