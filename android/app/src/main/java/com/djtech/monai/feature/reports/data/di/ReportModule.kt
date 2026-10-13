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
abstract class ReportModule {

    @Binds
    abstract fun bindReportRepository(repository: ApiReportRepository): ReportRepository

    companion object {

        @Provides
        @Singleton
        fun provideReportApiService(retrofit: Retrofit): ReportApiService = retrofit.create()
    }
}
