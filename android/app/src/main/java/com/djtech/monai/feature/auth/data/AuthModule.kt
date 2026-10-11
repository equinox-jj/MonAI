package com.djtech.monai.feature.auth.data

import com.djtech.monai.core.network.auth.SessionExpiredHandler
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
abstract class AuthModule {

    @Binds
    abstract fun bindSessionExpiredHandler(handler: ClearSessionOnExpiry): SessionExpiredHandler
}
