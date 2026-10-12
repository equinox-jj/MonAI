package com.djtech.monai.core.di

import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.time.SystemAppClock
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class CommonBindsModule {

    @Binds
    @Singleton
    abstract fun bindAppClock(clock: SystemAppClock): AppClock
}
