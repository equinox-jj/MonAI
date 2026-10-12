package com.djtech.monai.core.database

import androidx.room3.ColumnTypeConverters
import androidx.room3.DaoReturnTypeConverters
import androidx.room3.Database
import androidx.room3.RoomDatabase
import androidx.room3.paging.PagingSourceDaoReturnTypeConverter
import com.djtech.monai.core.database.dao.BudgetDao
import com.djtech.monai.core.database.dao.CategoryDao
import com.djtech.monai.core.database.dao.MonthlyReportDao
import com.djtech.monai.core.database.dao.PaymentProviderDao
import com.djtech.monai.core.database.dao.TransactionDao
import com.djtech.monai.core.database.dao.TransactionRemoteKeyDao
import com.djtech.monai.core.database.dao.UserDao
import com.djtech.monai.core.database.dao.WalletDao
import com.djtech.monai.core.database.entity.BudgetEntity
import com.djtech.monai.core.database.entity.CategoryEntity
import com.djtech.monai.core.database.entity.MonthlyReportEntity
import com.djtech.monai.core.database.entity.PaymentProviderCatalogEntity
import com.djtech.monai.core.database.entity.PaymentProviderEntity
import com.djtech.monai.core.database.entity.ReportCategoryEntity
import com.djtech.monai.core.database.entity.TransactionEntity
import com.djtech.monai.core.database.entity.TransactionFtsEntity
import com.djtech.monai.core.database.entity.TransactionRemoteKeyEntity
import com.djtech.monai.core.database.entity.UserEntity
import com.djtech.monai.core.database.entity.WalletEntity

/**
 * Offline read cache of the server's data. The API is the source of truth, so schema
 * changes may drop and re-fill it instead of migrating (see DatabaseModule).
 */
@Database(
    entities = [
        WalletEntity::class,
        CategoryEntity::class,
        TransactionEntity::class,
        TransactionFtsEntity::class,
        TransactionRemoteKeyEntity::class,
        BudgetEntity::class,
        PaymentProviderEntity::class,
        PaymentProviderCatalogEntity::class,
        MonthlyReportEntity::class,
        ReportCategoryEntity::class,
        UserEntity::class,
    ],
    version = 2,
    exportSchema = true,
)
@ColumnTypeConverters(Converters::class)
@DaoReturnTypeConverters(PagingSourceDaoReturnTypeConverter::class)
abstract class MonAIDatabase : RoomDatabase() {
    abstract fun walletDao(): WalletDao
    abstract fun categoryDao(): CategoryDao
    abstract fun transactionDao(): TransactionDao
    abstract fun transactionRemoteKeyDao(): TransactionRemoteKeyDao
    abstract fun budgetDao(): BudgetDao
    abstract fun paymentProviderDao(): PaymentProviderDao
    abstract fun monthlyReportDao(): MonthlyReportDao
    abstract fun userDao(): UserDao

    companion object {
        const val NAME = "monai.db"
    }
}
