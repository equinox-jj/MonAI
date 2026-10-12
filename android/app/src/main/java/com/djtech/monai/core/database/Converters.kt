package com.djtech.monai.core.database

import androidx.room3.ColumnTypeConverter
import com.djtech.monai.core.network.NetworkJson
import java.time.Instant
import java.time.LocalDate
import java.time.YearMonth

/** Enums use Room's built-in name mapping, so stored values match the API's. */
class Converters {

    @ColumnTypeConverter
    fun fromInstant(value: Instant?): Long? = value?.toEpochMilli()

    @ColumnTypeConverter
    fun toInstant(value: Long?): Instant? = value?.let(Instant::ofEpochMilli)

    // ISO text sorts in date order, so ORDER BY and BETWEEN work on the column directly.
    @ColumnTypeConverter
    fun fromLocalDate(value: LocalDate?): String? = value?.toString()

    @ColumnTypeConverter
    fun toLocalDate(value: String?): LocalDate? = value?.let(LocalDate::parse)

    @ColumnTypeConverter
    fun fromYearMonth(value: YearMonth?): String? = value?.toString()

    @ColumnTypeConverter
    fun toYearMonth(value: String?): YearMonth? = value?.let(YearMonth::parse)

    @ColumnTypeConverter
    fun fromStringList(value: List<String>): String = NetworkJson.encodeToString(value)

    @ColumnTypeConverter
    fun toStringList(value: String): List<String> = NetworkJson.decodeFromString(value)
}
