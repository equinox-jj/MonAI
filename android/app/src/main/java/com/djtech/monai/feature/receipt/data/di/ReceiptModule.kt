package com.djtech.monai.feature.receipt.data.di

import com.djtech.monai.feature.receipt.data.ocr.MlKitReceiptTextReader
import com.djtech.monai.feature.receipt.data.remote.ReceiptApiService
import com.djtech.monai.feature.receipt.data.repository.ApiReceiptRepository
import com.djtech.monai.feature.receipt.domain.ocr.ReceiptTextReader
import com.djtech.monai.feature.receipt.domain.repository.ReceiptRepository
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
abstract class ReceiptModule {

    @Binds
    abstract fun bindReceiptRepository(repository: ApiReceiptRepository): ReceiptRepository

    @Binds
    abstract fun bindReceiptTextReader(reader: MlKitReceiptTextReader): ReceiptTextReader

    companion object {

        @Provides
        @Singleton
        fun provideReceiptApiService(retrofit: Retrofit): ReceiptApiService = retrofit.create()
    }
}
