package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import androidx.room3.Entity
import androidx.room3.PrimaryKey
import com.djtech.monai.core.model.Budget
import com.djtech.monai.core.model.BudgetStatus
import java.time.YearMonth

@Entity(tableName = "budgets")
data class BudgetEntity(
    @PrimaryKey
    @ColumnInfo(name = "month")
    val month: YearMonth,

    @ColumnInfo(name = "limit_amount")
    val limitAmount: Long,

    @ColumnInfo(name = "spent")
    val spent: Long,

    @ColumnInfo(name = "remaining")
    val remaining: Long,

    @ColumnInfo(name = "progress_percent")
    val progressPercent: Double,

    @ColumnInfo(name = "status")
    val status: BudgetStatus,
)

fun BudgetEntity.asModel() = Budget(
    month = month,
    limitAmount = limitAmount,
    spent = spent,
    remaining = remaining,
    progressPercent = progressPercent,
    status = status,
)

fun Budget.asEntity() = BudgetEntity(
    month = month,
    limitAmount = limitAmount,
    spent = spent,
    remaining = remaining,
    progressPercent = progressPercent,
    status = status,
)
