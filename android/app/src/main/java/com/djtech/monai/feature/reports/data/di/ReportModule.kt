package com.djtech.monai.feature.reports.data.di

import com.djtech.monai.feature.reports.data.remote.ReportApiService
import com.djtech.monai.feature.reports.data.repository.ApiReportRepository
import com.djtech.monai.feature.reports.domain.repository.ReportRepository
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
abstract class ReportBindsModule {

    @Binds
    abstract fun bindReportRepository(repository: ApiReportRepository): ReportRepository
}

@Module
@InstallIn(SingletonComponent::class)
object ReportModule {

    @Provides
    @Singleton
    fun provideReportApiService(retrofit: Retrofit): ReportApiService = retrofit.create()
}
