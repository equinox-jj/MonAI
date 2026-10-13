package com.djtech.monai.core.di

import com.djtech.monai.core.common.locale.AppCompatLocaleManager
import com.djtech.monai.core.common.locale.AppLocaleManager
import com.djtech.monai.core.common.log.ErrorLogger
import com.djtech.monai.core.common.log.LogcatErrorLogger
import com.djtech.monai.core.common.time.AppClock
import com.djtech.monai.core.common.time.SystemAppClock
import com.djtech.monai.core.media.AndroidImageProcessor
import com.djtech.monai.core.media.ImageProcessor
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

    @Binds
    abstract fun bindErrorLogger(logger: LogcatErrorLogger): ErrorLogger

    @Binds
    abstract fun bindAppLocaleManager(manager: AppCompatLocaleManager): AppLocaleManager

    @Binds
    abstract fun bindImageProcessor(processor: AndroidImageProcessor): ImageProcessor
}
