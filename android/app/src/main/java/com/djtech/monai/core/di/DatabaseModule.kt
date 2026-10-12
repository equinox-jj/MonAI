package com.djtech.monai.core.di

import android.content.Context
import androidx.room3.Room
import androidx.sqlite.driver.bundled.BundledSQLiteDriver
import com.djtech.monai.core.common.dispatcher.Dispatcher
import com.djtech.monai.core.common.dispatcher.MonAIDispatcher
import com.djtech.monai.core.database.LocalCache
import com.djtech.monai.core.database.MonAIDatabase
import com.djtech.monai.core.database.RoomLocalCache
import dagger.Binds
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class DatabaseBindsModule {

    @Binds
    abstract fun bindLocalCache(cache: RoomLocalCache): LocalCache
}

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideDatabase(
        @ApplicationContext context: Context,
        @Dispatcher(MonAIDispatcher.IO) ioDispatcher: CoroutineDispatcher,
    ): MonAIDatabase = Room.databaseBuilder<MonAIDatabase>(context, MonAIDatabase.NAME)
        // Bundled SQLite gives the same FTS behavior on every Android version.
        .setDriver(BundledSQLiteDriver())
        .setQueryCoroutineContext(ioDispatcher)
        // Only a cache: on a schema change, drop it and let the server re-fill it.
        .fallbackToDestructiveMigration(dropAllTables = true)
        .build()

    @Provides
    fun provideWalletDao(database: MonAIDatabase) = database.walletDao()

    @Provides
    fun provideCategoryDao(database: MonAIDatabase) = database.categoryDao()

    @Provides
    fun provideTransactionDao(database: MonAIDatabase) = database.transactionDao()

    @Provides
    fun provideTransactionRemoteKeyDao(database: MonAIDatabase) =
        database.transactionRemoteKeyDao()

    @Provides
    fun provideBudgetDao(database: MonAIDatabase) = database.budgetDao()

    @Provides
    fun providePaymentProviderDao(database: MonAIDatabase) = database.paymentProviderDao()

    @Provides
    fun provideMonthlyReportDao(database: MonAIDatabase) = database.monthlyReportDao()

    @Provides
    fun provideUserDao(database: MonAIDatabase) = database.userDao()
}
