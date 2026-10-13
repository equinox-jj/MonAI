package com.djtech.monai.core.database.entity

import androidx.room3.ColumnInfo
import java.time.LocalDate

/** One day's income minus expenses, in rupiah; transfers count as zero. */
data class DailyNet(
    @ColumnInfo(name = "date")
    val date: LocalDate,

    @ColumnInfo(name = "net")
    val net: Long,
)

/** One day's total of some transactions, in positive rupiah. */
data class DailyAmount(
    @ColumnInfo(name = "date")
    val date: LocalDate,

    @ColumnInfo(name = "amount")
    val amount: Long,
)
